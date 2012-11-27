class InitialfeesController < ApplicationController
  
  def index
    id = params[:prj_id]
    #list
    item_found=Initialfee.find(:first,
                      :conditions =>["project_id=?",id])
    if item_found.nil?     
      redirect_to :action => 'new', :id =>id
    else
      redirect_to :action => 'show', :id =>item_found
    end                     
    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @initialfee_pages, @initialfees = paginate  :initialfees, :per_page => 20, :joins =>"inner join projects on initialfees.project_id = projects.id ",
                                                :order_by => "projects.job_code"
                                       
  end

  def show
    @initialfee = Initialfee.find(params[:id])
  end

  def new
    init_set 
    @initialfee = Initialfee.new
    @initialfee.project_id = params[:id]
  end

  def create
    @initialfee = Initialfee.new(params[:initialfee])
    if @initialfee.save
      flash[:notice] = 'Initialfee was successfully created.'
      redirect_to :action => 'show', :id => @initialfee
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @initialfee = Initialfee.find(params[:id])
  end

  def update
    @initialfee = Initialfee.find(params[:id])
    if @initialfee.update_attributes(params[:initialfee])
      flash[:notice] = 'Initialfee was successfully updated.'
      redirect_to :action => 'show', :id => @initialfee
    else
      render :action => 'edit'
    end
  end

  def destroy
    Initialfee.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  

  
end
