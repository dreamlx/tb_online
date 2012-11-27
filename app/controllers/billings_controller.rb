class BillingsController < ApplicationController

  def index
    #list
    #render :action => 'list'
    id = params[:prj_id]
    item_found =Billing.find(:first,:conditions=>['project_id=?',id])
    if item_found.nil?
      redirect_to :action => 'new',:id=> id
    else
      redirect_to :action => 'list',:id => id
    end
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  if not params[:id].nil?
    @billing_pages, @billings = paginate( :billings, 
                                          :per_page => 30,
                                          :conditions =>["project_id=?",params[:id]])
  else
    @billing_pages, @billings = paginate( :billings, 
                                          :per_page => 30)
  end                                            
  end

  def show
    @billing = Billing.find(params[:id])
    @receive_amounts = ReceiveAmount.find(:all, :conditions=>['billing_id = ?',@billing.id])
    @num = ReceiveAmount.count(['billing_id = ?',@billing.id])
    if @billing.status != '1'
      @billing_amount = ReceiveAmount.sum('receive_amount', :conditions =>['billing_id = ?', @billing.id ])||0
      #Billing.update(@billing.id, {:amount=>@billing.amount})
      @billing.outstanding = @billing.amount - @billing_amount
      Billing.update(@billing.id,{:outstanding =>@billing.outstanding})
      if @billing_amount == @billing.amount
        @billing.status = '1'
        Billing.update(@billing.id,{:status =>'1'})
      else
        @billing.status = '0'  
        Billing.update(@billing.id,{:status =>'0'})      
        
      end
    else
      @billing.outstanding =0
      Billing.update(@billing.id,{:outstanding =>@billing.outstanding})
    end
  end

  def new
    init_set
    billing_number_set
    @type = Dict.find(:all, :conditions => "category ='billing_type'")  
    @billing = Billing.new
    #@periods = Period.find_all
    @billing.project_id = params[:id]
    @billing.number = @billing_number.title + @str_number
    @now_period = get_now_period
    @billing.period_id = @now_period.id
    @billing.days_of_ageing = 0
    @billing.write_off = 0
    @billing.provision = 0
  end

  def create
    @billing = Billing.new(params[:billing])
    @billing_number = Dict.find(:first, :conditions =>" category ='billing_number' ")
    @number = @billing_number.code.to_i + 1
    @billing_number.code = @number.to_s
        
    update_collection_days
    get_tax
    get_amount
    @billing.outstanding = @billing.amount
    
    if @billing.save
      @billing_number.save
      flash[:notice] = @billing.project.job_code + ' -- Billing was successfully updated.'
      redirect_to :action => 'list', :id=> @billing.project_id
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @type = Dict.find(:all, :conditions => "category ='billing_type'")  
    
    @billing = Billing.find(params[:id])
    closed = true
    @projects.each do |project|
      closed = false if @billing.project_id == project.id
    end

    if closed == true
      flash[:notice] = @billing.project.job_code + ' -- project of the Billing  was closed.'
      redirect_to :action => 'search'
    end
  end

  def update
    @billing = Billing.find(params[:id])
    if @billing.update_attributes(params[:billing])
      flash[:notice] = @billing.project.job_code + ' -- Billing was successfully updated.'
      get_tax
      get_amount
      outstanding_net=  @billing.outstanding - @billing.write_off
      if outstanding_net == 0
        @billing.status = '1'
      end
      update_collection_days
      @billing.save
      redirect_to :action => 'show', :id => @billing
    else
      render :action => 'edit'
    end
  end

  def destroy
    Billing.find(params[:id]).destroy
    redirect_to :action => 'list',:id => params[:prj_id]
  end

  def search
    init_set
	person_status = Dict.find_by_title_and_category("Resigned","person_status")
	
	@people = Person.find(:all,
	:conditions=>" (grade like '%partner%' or grade like '%manager%' or grade like '%dir%') and status_id != '#{person_status.id}' ",
	:order => "english_name")
    @now_user = session[:user_id]
    person_id = params[:person_id]
	@billing = Billing.new(params[:billing]) 
    @period =Period.new(params[:period])
    sql_str = " select D.job_code, A.* from "+
              " billings as A, projects as D "+
              " where A.project_id = D.id and "
    sql_condition = "  1 " 
    sql_order = " order by A.number "
    
    unless @period.ending_date.nil?
      sql_condition += " and billing_date <= '#{@period.ending_date}'"
    end

    unless @period.nil?
      sql_condition += " and billing_date >= '#{@period.starting_date}'  "
    end

    if not @billing.project_id.nil?
      sql_condition += " and project_id =#{ @billing.project_id} "
    end

    if not @billing.number.nil?
      sql_condition += " and number like '%#{ @billing.number.lstrip}%' "
    end
    
    if not @billing.status == ""
      sql_condition += " and status = '#{@billing.status}'"    
    end
	
    if @now_user != 0
      sql_condition += " and (billing_manager_id =#{@now_user} or billing_partner_id = #{@now_user}) "
    else
		unless person_id.blank?
			sql_condition += " and (billing_manager_id =#{person_id} or billing_partner_id = #{person_id}) "
		end
	end
    @billings = Billing.find_by_sql(sql_str + sql_condition + sql_order )
    @sql=sql_str + sql_condition + sql_order
    
    @p_sql = sql_str
    @p_condition = sql_condition
    @p_order = sql_order
    @sum_recieve_all =0
    for billing in @billings
      billing_recieve = ReceiveAmount.sum('receive_amount', :conditions =>['billing_id = ?', billing.id ])||0
      @sum_recieve_all += billing_recieve
    end


    join_sql =' inner join projects on projects.id = billings.project_id'
    @b_total = Billing.new
    @b_total.amount = Billing.sum("amount", :joins=>join_sql, :conditions => sql_condition)||0
    @b_total.outstanding = Billing.sum("outstanding", :joins=>join_sql, :conditions => sql_condition)||0
    @b_total.service_billing = Billing.sum("service_billing",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.expense_billing = Billing.sum("expense_billing",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.business_tax = Billing.sum("business_tax",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.write_off = Billing.sum("write_off",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.provision = Billing.sum("provision",:joins=>join_sql, :conditions => sql_condition)||0
    @b_count = Billing.count(:joins=>join_sql,:conditions =>sql_condition)    ||0
  end
    
  private
  
  def get_cookie
    @cookie_value = cookies[:the_time]
    #render(:action=>index,:text =>" #{cookie_value}")
  end
  
  def get_tax
    tax_rate = 5.26/100
    @billing.business_tax = @billing.service_billing * tax_rate
  end
  
  def get_amount
    @billing.amount = @billing.service_billing + @billing.expense_billing
  end
  
  def update_collection_days
    if @billing.status == "1"
      @billing.collection_days = @billing.days_of_ageing
      @billing.outstanding =@billing.amount
    end
  end
end
