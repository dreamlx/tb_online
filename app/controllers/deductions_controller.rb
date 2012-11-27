class DeductionsController < ApplicationController
  def index
    #list
    #render :action => 'list'
    id = params[:prj_id]
    item_found =Deduction.find(:first,:conditions=>['project_id=?',id])
    if item_found.nil?
      redirect_to :action => 'new',:id=> id
    else
      redirect_to :action => 'show',:id => item_found
    end    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @deduction_pages, @deductions = paginate :deductions, :per_page => 20,:joins =>"inner join projects on deductions.project_id = projects.id ",
                                                :order_by => "projects.job_code"
  end

  def show
    @deduction = Deduction.find(params[:id])
  end

  def new
    init_set
    @deduction = Deduction.new
    @deduction.project_id = params[:id]
  end

  def create
    @deduction = Deduction.new(params[:deduction])
    if @deduction.save
      flash[:notice] = 'Deduction was successfully created.'
      redirect_to :action => 'show', :id => @deduction
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @deduction = Deduction.find(params[:id])
  end

  def update
    @deduction = Deduction.find(params[:id])
    if @deduction.update_attributes(params[:deduction])
      flash[:notice] = 'Deduction was successfully updated.'
      redirect_to :action => 'show', :id => @deduction
      #redirect_to :controller =>'initialfees', :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Deduction.find(params[:id]).destroy
    redirect_to :controller =>'deductions', :action => 'list'
  end

end
