class IndustriesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @industry_pages, @industries = paginate :industries, :per_page => 10
  end

  def show
    @industry = Industry.find(params[:id])
  end

  def new
    @industry = Industry.new
  end

  def create
    @industry = Industry.new(params[:industry])
    if @industry.save
      flash[:notice] = 'Industry was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @industry = Industry.find(params[:id])
  end

  def update
    @industry = Industry.find(params[:id])
    if @industry.update_attributes(params[:industry])
      flash[:notice] = 'Industry was successfully updated.'
      redirect_to :action => 'show', :id => @industry
    else
      render :action => 'edit'
    end
  end

  def destroy
    Industry.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
