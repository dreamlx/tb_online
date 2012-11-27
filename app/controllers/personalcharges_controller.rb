class PersonalchargesController < ApplicationController
  def index
    #list
    #render :action => 'list'
    prj_id = params[:prj_id]
    person_id = params[:person_id]
    
    if not params[:person_id].nil?
      redirect_to :action => 'list', :person_id => person_id
    else
      item_found =Personalcharge.find(:first,:conditions=>['project_id=?',prj_id])
      if item_found.nil?
        redirect_to :action => 'new',:id=> prj_id
      else
        redirect_to :action => 'prj_list',:id => prj_id
      end 
    end 
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  get_now_period

  if not params[:person_id].nil?
    if not @now_period.nil?
    @personalcharge_pages, @personalcharges = paginate( :personalcharges, 
                                                        :per_page => 20, 
                                                        :conditions =>["person_id=? and period_id =?",params[:person_id],@now_period.id],
                                                        :order_by =>'period_id')
    else
    @personalcharge_pages, @personalcharges = paginate( :personalcharges, 
                                                        :per_page => 20, 
                                                        :conditions =>["person_id=? ",params[:person_id]],
                                                        :order_by =>'period_id')
    end
  
  else
    if params[:id].nil?
      @personalcharge_pages, @personalcharges = paginate( :personalcharges, 
                                                        :per_page => 20,
                                                        :order_by => 'project_id')  
    else
        @personalcharge_pages, @personalcharges = paginate( :personalcharges, 
                                                        :per_page => 20, 
                                                        :conditions =>["project_id=?",params[:id]])
    end
  end
  
  end
  
  def prj_list
    if params[:id].nil?
      @personalcharge_pages, @personalcharges = paginate( :personalcharges, 
                                                        :per_page => 20,
                                                        :order_by => 'project_id')  
    else
        @personalcharge_pages, @personalcharges = paginate( :personalcharges, 
                                                        :per_page => 20, 
                                                        :conditions =>["project_id=?",params[:id]])
    end  
  end

  def show
    @personalcharge = Personalcharge.find(params[:id])
  end
  
  def prj_show
    @personalcharge = Personalcharge.find(params[:id])
  end
  def new
    init_set
    
    @personalcharge = Personalcharge.new
    if not params[:person_id].nil?
      @personalcharge.person_id = params[:person_id]
    else  
      if not params[:id].nil?
        @personalcharge.project_id = params[:id]
      end
    end
  end

  def create
    person_status = Dict.find_by_title_and_category("Resigned","person_status")

  	@people = Person.find(:all,
  	:conditions=>" (grade like '%partner%' or grade like '%manager%' or grade like '%dir%') and status_id != '#{person_status.id}' ",
  	:order => "english_name")
    @personalcharge = Personalcharge.new(params[:personalcharge])
    person = Person.find(@personalcharge.person_id)
    @personalcharge.service_fee = @personalcharge.hours * person.charge_rate
    if @personalcharge.save
      flash[:notice] = 'Personalcharge was successfully created.'
      redirect_to :action => 'list', :person_id => @personalcharge.person_id, :id => @personalcharge.project_id
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @personalcharge = Personalcharge.find(params[:id])
  end

  def update
    @personalcharge = Personalcharge.find(params[:id])
    if @personalcharge.update_attributes(params[:personalcharge])
      flash[:notice] = 'Personalcharge was successfully updated.'
      person = Person.find(@personalcharge.person_id)
      @personalcharge.service_fee = @personalcharge.hours * person.charge_rate      
      @personalcharge.save
      redirect_to :action => 'show', :id => @personalcharge
    else
      render :action => 'edit'
    end
  end

  def destroy
    Personalcharge.find(params[:id]).destroy
    if not params[:person_id].nil?
      redirect_to :action => 'list', :person_id => params[:person_id], :id => params[:prj_id]
    else    
      redirect_to :action => 'list', :person_id => params[:person_id], :id => params[:prj_id]
    end
  end
  
  #totalfee
  #sql_str = "select sum(service_fee) as total,periods.number, people.english_name " +
  #          "from personalcharges,periods,people "+
  #          "where personalcharges.period_id=periods.id and person_id=people.id "+
  #          "group by period_id,person_id "+
  #          "order by periods.number,people.english_name"

  
  def search
    @personalcharge = Personalcharge.new(params[:personalcharge])
    @personalcharge.period_id = nil
    period_from_id = params[:period_from]
    period_to_id = params[:period_to]
    @period_condition = " "
    if period_from_id == period_to_id
      @personalcharge.period_id = period_to_id
    else
           
      unless period_from_id == ""
        @start_period = Period.find(period_from_id)
        @period_condition += " and C.starting_date >= '#{@start_period.starting_date}' "  
      end
      
      unless period_to_id == ""
        @end_period = Period.find(period_to_id)
        @period_condition += " and C.ending_date <= '#{@end_period.ending_date}' "
      end
     
    end
    @p_total = Personalcharge.new
    @projects = Project.find(:all, :order => 'job_code')
    @periods = Period.find(:all, :order =>'number DESC')
    
    
    sql_condition = " 1 "
    
    if not @personalcharge.period_id.nil?       
      sql_condition += " and period_id = #{ @personalcharge.period_id} "
    else
      sql_condition = " 1 " + @period_condition
    end
    
    if not @personalcharge.person_id .nil?
      sql_condition += " and person_id = #{ @personalcharge.person_id} "
    end
    
    if not @personalcharge.project_id.nil? and not ( @personalcharge.project_id == -1 or  @personalcharge.project_id == -2 )
      sql_condition += " and project_id =#{ @personalcharge.project_id} "
    
    end
    
    # select the frist char of jobCode in 0-9  
    if @personalcharge.project_id == -1
      sql_condition += " AND left( job_code, 1 )IN ( 01, 2, 3, 4, 5, 6, 7, 8, 9 )  "
    end
    
    # select the frist char of jobCode not in 0-9 
    if @personalcharge.project_id == -2
      sql_condition += " AND left( job_code, 1 )NOT IN ( 01, 2, 3, 4, 5, 6, 7, 8, 9 )"
    end
      
    sql_str ="select D.job_code, C.number, B.english_name, A.* from "+
              "personalcharges as A, people as B,periods as C, projects as D "+
              " where A.person_id = B.id and A.period_id = C.id and A.project_id = D.id and "
     
    sql_order =" order by D.job_code,  C.number, B.english_name "       
    #@personalcharges = Personalcharge.find(:all, :conditions =>sql_condition)
    @personalcharges        = Personalcharge.find_by_sql(sql_str + sql_condition + sql_order)
    @tempsql =sql_str + sql_condition + sql_order
    join_sql = " inner join projects on personalcharges.project_id = projects.id left join periods as C on personalcharges.period_id = C.id "
    @p_total.hours          = Personalcharge.sum("hours", 
        :joins =>join_sql,
        :conditions =>sql_condition)
    @p_total.service_fee    = Personalcharge.sum("service_fee", 
        :joins =>join_sql,
        :conditions =>sql_condition)                      
    @p_total.reimbursement  = Personalcharge.sum("reimbursement", 
        :joins =>join_sql,
        :conditions =>sql_condition)
    @p_total.meal_allowance = Personalcharge.sum("meal_allowance", 
        :joins =>join_sql,
        :conditions =>sql_condition)
    @p_total.travel_allowance = Personalcharge.sum("travel_allowance", 
        :joins =>join_sql,
        :conditions =>sql_condition)
    @p_count = Personalcharge.count(
          :joins =>join_sql,
          :conditions =>sql_condition)
    @pfa_fee = [0,0]
    
    @p_t1 = Personalcharge.new
    @p_t0 = Personalcharge.new
    person_status = Dict.find_by_title_and_category("Resigned","person_status")                                   
    @people = Person.find(:all,:conditions=>" status_id != '#{person_status.id}' ", :order => 'english_name')
  end

def get_now_period
@cookie_value = cookies[:the_time]
    if @cookie_value != ""
    sql_condition  = " id = '#{@cookie_value}'" 
    else
    sql_condition = "id = 0"
    end
    @now_period = Period.find(:first, :conditions => sql_condition )
#render(:action=>index,:text =>" #{cookie_value}")
end

end
