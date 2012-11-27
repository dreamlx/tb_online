class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  #
  auto_complete_for :client,:english_name
  auto_complete_for :project,:job_code
  def index
    
    #@projects = Project.find(:all)f
    @project = Project.new(params[:project])
    @client = Client.new(params[:client])
    str_order = 'projects.status_id,job_code'
    str_status = " and title = 'Active' "
    sql = ' 1 '
    #sql += str_status
    sql += " and english_name like '%#{@client.english_name}%' " unless (@client.english_name.nil? or @client.english_name.blank?)
    sql += " and partner_id = #{@project.partner_id} " unless @project.partner_id == 0 or @project.partner_id.nil?
    sql += " and manager_id = #{@project.manager_id} " unless @project.manager_id == 0 or @project.manager_id.nil?
    sql += " and job_code like '%#{@project.job_code}%' " unless @project.job_code.nil? or @project.job_code.blank?
    @projects = Project.paginate  :page => params[:page], 
      :per_page => 20,
      :order=>str_order,
      :include =>[:status,:client],
      :conditions=>sql
        
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @projects.to_xml }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @project.to_xml }
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1;edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    if @project.job_code == nil or @project.job_code ==""                       
      @project.job_code =@project.client.client_code+@project.GMU.code+@project.service_code.code
    end
    
    respond_to do |format|
      if @project.save
        if (@project.service_code.code.to_i < 60 or @project.service_code.code.to_i >68) and @project.service_code.code.to_i != 100


          add_expense_observer(@project.job_code,200,"if prj code not in 60-68,then add 200")
        end
        flash[:notice] = _('%s was successfully created.', Project.human_name)
        format.html { redirect_to project_url(@project) }
        format.xml  { head :created, :location => project_url(@project) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors.to_xml }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])
    if @project.job_code.nil? or @project.job_code.blank?                      
      @project.job_code =@project.client.client_code+@project.GMU.code+@project.service_code.code
    end
    
    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = _('%s was successfully updated.', Project.human_name)
        format.html { redirect_to project_url(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors.to_xml }
      end
    end
  end
  
  #CLOSE 
  def close
    closed_item = Dict.find(:first,:conditions =>"category ='prj_status' and code = '0'")
    #需要判断balance是否为0，如果有结余！=0 则无法close
    allow_closed = is_balance(Project.find(params[:id]),Period.today_period)
    billings = Billing.find(:all,:conditions => "project_id = #{params[:id]}")
    billing_number= "<br/>|need close billings --"
    for item in billings
      if item.status.to_s == 0.to_s
        allow_closed = false
        billing_number = billing_number + item.number + " |"
      end
    end
    respond_to do |format|
      if allow_closed and Project.find(params[:id]).update_attribute(:status_id,closed_item.id)
        flash[:notice] ="Poject was successfully closed"
        format.html {redirect_to projects_path}# index.rhtml
        format.xml  { render :xml => @projects.to_xml }
      else
        flash[:notice] ="Poject error updated with projects"
        flash[:notice]=( "<font color=red>ballance is not 0!</font>" + "|service balance: #{ @service_balance.to_s}" +"|expense balance:"+ @expense_balance.to_s + billing_number) unless allow_closed
        format.html {redirect_to projects_path}# index.rhtml
      end
      
      
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.xml  { head :ok }
    end
  end
  
 def turn_next_year

    @projects = Project.find(:all, :conditions=>"starting_date < '2007-09-16'",:order=>' job_code ')

    for project in @projects
      unless (project.status.code != '0' )#closed
        Project.delete(project.id)
        Initialfee.delete_all(["project_id = ?", project.id])
        Deduction.delete_all(["project_id = ?", project.id])
        Billing.delete_all(["project_id = ?", project.id])
        Expense.delete_all(["project_id = ?", project.id])
        Personalcharge.delete_all(["project_id = ?", project.id])
        Ufafee.delete_all(["project_id = ?", project.id])
        flash[:notice] =" Clear complete initialfee,deduction, billing, expense, personalcharge, ufafee"
      end
     end
    #���㵱��+ȥ�����
    #
    @projects = Project.find(:all, :order=>' job_code ')

    for project in @projects
      unless (project.status.code != '0' )#closed
        #Project.delete(project.id)
        #Initialfee.delete_all(["project_id = ?", project.id])
        #Deduction.delete_all(["project_id = ?", project.id])
        #Billing.delete_all(["project_id = ?", project.id])
        #Expense.delete_all(["project_id = ?", project.id])
        #Personalcharge.delete_all(["project_id = ?", project.id])
        #Ufafee.delete_all(["project_id = ?", project.id])
        #flash[:notice] =" Clear complete initialfee,deduction, billing, expense, personalcharge, ufafee"
        #loop
      else
        sql_condition     = [" periods.number <= '2007-09-16' and project_id = ?", project.id]
        sql_join          = " inner join periods on periods.id = period_id "
        @sum_personal = Personalcharge.new
        @sum_personal.service_fee = Personalcharge.sum( "service_fee",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_personal.reimbursement = Personalcharge.sum("reimbursement",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_personal.meal_allowance = Personalcharge.sum("meal_allowance",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_personal.travel_allowance = Personalcharge.sum("travel_allowance",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_personal.hours = Personalcharge.sum("hours",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0

        @sum_expense = Expense.new
        @e_total = 0
        @sum_expense.commission =         Expense.sum(  "commission",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_expense.outsourcing =        Expense.sum(  "outsourcing",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_expense.tickets =            Expense.sum(  "tickets",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_expense.courrier =           Expense.sum(  "courrier",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_expense.postage =            Expense.sum(  "postage",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_expense.stationery =         Expense.sum(  "stationery",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_expense.report_binding =     Expense.sum(  "report_binding",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_expense.cash_advance =       Expense.sum(  "cash_advance",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_expense.payment_on_be_half = Expense.sum(  "payment_on_be_half",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0

        @e_total = @sum_expense.tickets+@sum_expense.courrier+@sum_expense.postage+@sum_expense.stationery+@sum_expense.report_binding+@sum_expense.cash_advance

        #billing ����ת
        @sum_billing = Billing.new
        @sum_billing.service_billing  = Billing.sum("service_billing",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_billing.expense_billing  = Billing.sum("expense_billing",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_billing.business_tax      = Billing.sum("business_tax",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        ###############????################
        @e_total += @sum_billing.business_tax

        @sum_UFA = Ufafee.new
        @sum_UFA.service_UFA = Ufafee.sum("service_UFA",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        @sum_UFA.expense_UFA = Ufafee.sum("expense_UFA",
                                                        :joins => sql_join,
                                                        :conditions => sql_condition)||0
        ################################

        @initialfee = Initialfee.find(:first, :conditions=>" project_id = #{project.id} ")||Initialfee.new
        @initialfee.project_id = project.id

        @deduction = Deduction.find(:first, :conditions=>" project_id = #{project.id} ") || Deduction.new
        @deduction.project_id = project.id

        @sum_service_PFA = (@sum_personal.service_fee * project.service_PFA/100)
        @sum_expense_PFA = (@sum_personal.reimbursement+@sum_personal.meal_allowance+ @sum_personal.travel_allowance+@e_total)*project.expense_PFA/100

        @initialfee.service_fee += @sum_personal.service_fee
        @initialfee.reimbursement += @sum_personal.reimbursement
        @initialfee.meal_allowance += @sum_personal.meal_allowance
        @initialfee.travel_allowance += @sum_personal.travel_allowance
        #@initialfee.hours += @sum_personal.hours
        @initialfee.commission += @sum_expense.commission
        @initialfee.outsourcing += @sum_expense.outsourcing
        @initialfee.tickets += @sum_expense.tickets
        @initialfee.courrier += @sum_expense.courrier
        @initialfee.postage += @sum_expense.postage
        @initialfee.stationery += @sum_expense.stationery
        @initialfee.report_binding += @sum_expense.report_binding
        @initialfee.cash_advance += @sum_expense.cash_advance
        @initialfee.payment_on_be_half += @sum_expense.payment_on_be_half
        @initialfee.business_tax += @sum_billing.business_tax


        @deduction.service_PFA +=@sum_service_PFA
        @deduction.expense_PFA +=@sum_expense_PFA
        @deduction.service_UFA +=@sum_UFA.service_UFA
        @deduction.expense_UFA +=@sum_UFA.expense_UFA
        @deduction.service_billing +=@sum_billing.service_billing
        @deduction.expense_billing +=@sum_billing.expense_billing

        #del personalcharge
        @del_list = Personalcharge.find(      :all, :joins => sql_join, :conditions => sql_condition)
        for del_now in @del_list
          Personalcharge.delete(del_now.id)
        end

        #del expense
        @del_list = Expense.find(      :all, :joins => sql_join, :conditions => sql_condition)
        for del_now in @del_list
          Expense.delete(del_now.id)
        end

        #del billing
        @del_list = Billing.find(      :all, :joins => sql_join, :conditions => sql_condition)
        for del_now in @del_list
          Billing.delete(del_now.id)
        end

        #del ufa
        @del_list = Ufafee.find(      :all, :joins => sql_join, :conditions => sql_condition)
        for del_now in @del_list
          Ufafee.delete(del_now.id)
        end

        @initialfee.save
        @deduction.save
        #flash[:notice] = 'Project was successfully created.'
        #end
        #@deduction.save
        #redirect_to :action => 'list'

        #
        #
      end
    end

  end
  private


  def is_balance(t_project,t_period)
    #@info = Personalcharge.new(params[:personalcharge])
    @statuses   = Dict.find(:all,
      :conditions =>"category ='prj_status' and code = '1'")# 1 open, 0 close
                   
    #sql_p     = " starting_date => '2007-09-16' or status_id = #{@statuses.id}}"
    @project = t_project
    @now_period = t_period
    
    @report = TimeReport.new
    @report.for_report(@project, @now_period)
    #charges
    @personalcharges = @report.personalcharges
    @p_currents = @report.p_currents
    @p_cumulatives = @report.p_cumulatives
    @p_total  = @report.p_total
    @user_list = @report.user_list
    #expenses
    @e_current = @report.e_current
    @e_cumulative  = @report.e_cumulative
    sum_expenses = 0
    sum_e_total = 0
				
    sum_expenses 	+= @e_current.courrier
    sum_e_total 	+= @e_cumulative.courrier
    sum_expenses 	+= @e_current.postage
    sum_e_total 	+= @e_cumulative.postage
    sum_expenses 	+= @e_current.payment_on_be_half
	
    sum_expenses 	+= @e_current.report_binding
    sum_e_total 	+= @e_cumulative.report_binding
    sum_expenses 	+= @e_current.stationery
    sum_e_total 	+= @e_cumulative.stationery
    sum_expenses 	+= @e_current.tickets
    sum_e_total 	+= @e_cumulative.tickets
    #sum_expenses 	+= @e_current.commission
    #sum_e_total 	+= @e_cumulative.commission
    #sum_expenses 	+= @e_current.outsourcing
    #sum_e_total 	+= @e_cumulative.outsourcing
    sum_e_total 	+= @e_cumulative.payment_on_be_half
    #billings
    @billings  = @report.billings
    @billing_total   = @report.b_total
    @bt={}
    @bt        = @report.bt   
    sum_expenses 	+=@bt["current"]
    sum_e_total 	+=@bt["cumulative"]
    @sum_all_expenses = sum_expenses
    @sum_e_total    = sum_e_total  	
    #initialfees
    @initialfee = @report.initialfee
    @sum_initialfee = @initialfee.courrier + @initialfee.postage + 
      @initialfee.payment_on_be_half + @initialfee.report_binding +
      @initialfee.stationery + @initialfee.tickets + @initialfee.commission + 
      @initialfee.outsourcing + @initialfee.business_tax
    @initialdeduction = @report.deduction
    
    #PFA and UFA
    @UFA_fees  = @report.UFA_fees
    @UFA_total   = @report.UFA_total
    
    @total_reimbs =  @p_total.travel_allowance  + @p_total.reimbursement + @p_total.meal_allowance
    #计算
     
    service_total_charges = @p_total.service_fee + @initialfee.service_fee + @e_cumulative.outsourcing + @e_cumulative.commission
    expense_total_charges = @sum_e_total  +@total_reimbs + @sum_initialfee + @initialfee.meal_allowance + @initialfee.travel_allowance + @initialfee.reimbursement 
    
    service_PFA = (@p_total.service_fee )*@project.service_PFA/100 +@initialdeduction.service_PFA
    expense_PFA = (@total_reimbs+@sum_e_total-@e_cumulative.payment_on_be_half)*@project.expense_PFA/100 +@initialdeduction.expense_PFA
    
    service_billing =@billing_total.service_billing + @initialdeduction.service_billing
    expense_billing = @billing_total.expense_billing + @initialdeduction.expense_billing
    
    service_UFA = @UFA_total.service_UFA+@initialdeduction.service_UFA
    expense_UFA = @UFA_total.expense_UFA+@initialdeduction.expense_UFA
    
    @service_balance = service_total_charges - service_PFA - service_billing - service_UFA
    @expense_balance = expense_total_charges - expense_PFA - expense_billing - expense_UFA
    
    if (@service_balance <1 and @service_balance >-1 ) and (@expense_balance <1  and @expense_balance >-1 )#为0 允许close
      return true
    else
      return false
    end
  end
end
