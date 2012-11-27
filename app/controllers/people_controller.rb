class PeopleController < ApplicationController
  auto_complete_for :person,:english_name
  auto_complete_for :person,:employee_number
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

   def list
#Person.find(:all,:order=>"english_name",:include=>:status,:conditions=>"title = 'Employed'").collect {|p| [ p.english_name, p.id ] }
    @person = Person.new(params[:person])
    person_id = params[:person][:id] unless params[:person].nil?
	#flash[:notice] = "#{person_id.length?}"
    sql_condition = " 1 "
    #unless @person.nil?
      sql_condition +=" and employee_number like '%#{@person.employee_number}%'" unless @person.employee_number.blank?
      sql_condition +=" and id = #{person_id}" unless person_id.blank? 
    #end
	@sql = sql_condition
    @person_pages, @people = paginate :people,
      :per_page => 20,
      :conditions=>sql_condition,
      :order_by => "employee_number"
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end


  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Person was successfully updated.'
      redirect_to :action => 'show', :id => @person
    else
      render :action => 'edit'
    end
  end

  def destroy
    Person.find(params[:id]).destroy if Person.find(params[:id]).english_name != "guest"
    redirect_to :action => 'list'
  end
  
  def new
    @person = Person.new
    @dicts = Dict.find(:all,
                      :conditions =>"category ='GMU'")    
    @status = Dict.find(:all,
                      :conditions =>"category ='person_status'")
    @gender = Dict.find(:all,
                      :conditions =>"category ='gender'")
    @departments = Dict.find(:all,
                      :conditions =>"category ='department'")                      
  end
  
  def edit
    @person = Person.find(@params["id"])
    @dicts = Dict.find(:all,
                      :conditions =>"category ='GMU'")
    @status = Dict.find(:all,
                      :conditions =>"category ='person_status'")
    @gender = Dict.find(:all,
                      :conditions =>"category ='gender'")
    @departments = Dict.find(:all,
                      :conditions =>"category ='department'")                       
  end
  
  def show
    @person = Person.find(@params["id"])
    @dicts = Dict.find(:all,
                      :conditions =>"category ='GMU'")
    @status = Dict.find(:all,
                      :conditions =>"category ='person_status'")
                 
  end  
end
