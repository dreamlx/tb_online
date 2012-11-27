class OutsourcingsController < ApplicationController
  def index
    #list
    #render :action => 'list'
    id = params[:prj_id]
    item_found =Outsourcing.find(:first,:conditions=>['project_id=?',id])
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
    if params[:id].nil?
    @outsourcing_pages, @outsourcings = paginate(:outsourcings, 
                                                  :per_page => 10) 
    else
    @outsourcing_pages, @outsourcings = paginate(:outsourcings, 
                                                  :per_page => 10, 
                                                  :conditions =>["project_id=?",params[:id]])
    end
  end

  def show
    @outsourcing = Outsourcing.find(params[:id])
  end

  def new
    init_set  
    @outsourcing = Outsourcing.new
    @outsourcing.project_id = params[:id]
  end

  def create
    @outsourcing = Outsourcing.new(params[:outsourcing])
    if @outsourcing.save
      flash[:notice] = 'Outsourcing was successfully created.'
      redirect_to :action => 'list', :id => @outsourcing.project_id
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @outsourcing = Outsourcing.find(params[:id])
  end

  def update
    @outsourcing = Outsourcing.find(params[:id])
    if @outsourcing.update_attributes(params[:outsourcing])
      flash[:notice] = 'Outsourcing was successfully updated.'
      redirect_to :action => 'show', :id => @outsourcing
    else
      render :action => 'edit'
    end
  end

  def destroy
    Outsourcing.find(params[:id]).destroy
    redirect_to :action => 'list', :id => params[:prj_id]
  end
end
