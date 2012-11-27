class ClientsController < ApplicationController
  #model :client
  scaffold :client
  
  def index
    list
    render :action => 'list'
  end
  
  def new
    @client         = Client.new
    @industries     = Industry.find_all
    @categories     = Dict.find(:all,
                                :conditions =>"category ='client_category'",
                                :order =>"code")
    @statuses       = Dict.find(:all,
                                :conditions =>"category ='client_status'", 
                                :order =>"code")
                                 
    @regions        = Dict.find(:all,
                                :conditions =>"category ='region'", 
                                :order =>"code")
                             
    @gender         = Dict.find(:all,
                                :conditions =>"category ='gender'", 
                                :order =>"code")
    person_status = Dict.find_by_title_and_category("Resigned","person_status")                                   
    @account_owners = Person.find(:all,:conditions=>" status_id != '#{person_status.id}' ", :order => 'english_name')
                                                 
  end
   def create
    @client = Client.new(params[:client])
    @industries     = Industry.find_all
    @categories     = Dict.find(:all,
                                :conditions =>"category ='client_category'",
                                :order =>"code")
    @statuses       = Dict.find(:all,
                                :conditions =>"category ='client_status'", 
                                :order =>"code") 
    @regions        = Dict.find(:all,
                                :conditions =>"category ='region'", 
                                :order =>"code")
    @gender         = Dict.find(:all,
                                :conditions =>"category ='gender'", 
                                :order =>"code")
                                person_status = Dict.find_by_title_and_category("Resigned","person_status")                                   
                                @account_owners = Person.find(:all,:conditions=>" status_id != '#{person_status.id}' ", :order => 'english_name')
                                      if @client.save
      #flash[:notice] = @billing.project.job_code + ' -- Billing was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @client     = Client.find(params[:id])
    @industries = Industry.find_all
    @categories = Dict.find(:all,
                          :conditions =>"category ='client_category'", :order =>"code")
    @statuses   = Dict.find(:all,
                          :conditions =>"category ='client_status'", :order =>"code") 
    @regions    = Dict.find(:all,
                          :conditions =>"category ='region'", :order =>"code")
    @gender     = Dict.find(:all,
                          :conditions =>"category ='gender'", :order =>"code")
                          person_status = Dict.find_by_title_and_category("Resigned","person_status")                                   
                          @account_owners = Person.find(:all,:conditions=>" status_id != '#{person_status.id}' ", :order => 'english_name')                                                                                       
  end

  def list
    @client_pages, @clients = paginate :clients, :per_page => 20, :order_by => 'client_code'
    @statuses = Dict.find(:all,
                      :conditions =>"category ='client_status'")
  end
  
  def search
    @client = Client.new(params[:client])
    sql = "1"
     sql += " and client_code like '%"+@client.client_code+"%' " if @client.client_code
     sql += " and chinese_name like '%"+@client.chinese_name+"%' " if @client.chinese_name
    if @client.client_code 
      #@clients = Client.find(:all,
      #                      :conditions => ['client_code like ?', @client.client_code])
      @clients = Client.find(:all,:conditions=>sql)
    else
      redirect_to :action => 'list'
    end
  end
  
end
