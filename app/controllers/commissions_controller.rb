class CommissionsController < ApplicationController
  def index
    #list
    #render :action => 'list'
    id = params[:prj_id]
    item_found =Commission.find(:first,:conditions=>['project_id=?',id])
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
    @commission_pages, @commissions = paginate :commissions, :per_page => 10
    else
    @commission_pages, @commissions = paginate :commissions, :per_page => 10, :conditions =>["project_id=?",params[:id]]
    end
  end

  def show
    @commission = Commission.find(params[:id])
  end

  def new
    init_set
    @commission = Commission.new
    @commission.project_id = params[:id]    
  end

  def create
    @commission = Commission.new(params[:commission])
    if @commission.save
      flash[:notice] = 'Commission was successfully created.'
      redirect_to :action => 'list',  :id=> @commission.project_id
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @commission = Commission.find(params[:id])

  end

  def update
    @commission = Commission.find(params[:id])
    if @commission.update_attributes(params[:commission])
      flash[:notice] = 'Commission was successfully updated.'
      redirect_to :action => 'show', :id => @commission
    else
      render :action => 'edit'
    end
  end

  def destroy
    Commission.find(params[:id]).destroy
    redirect_to :action => 'list', :id => params[:prj_id]
  end
end
