class DictsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @dict = Dict.new(params[:dict])
    if not (@dict.category =="" or @dict.category.nil?)
      condition_sql = " category like '%#{@dict.category}%'"
    else
      condition_sql = " 1 "
    end
    @dict_pages, @dicts = paginate :dicts, :per_page => 20, :order_by => 'category', :conditions => condition_sql
  end

  def show
    @dict = Dict.find(params[:id])
  end

  def new
    @dict = Dict.new
  end

  def create
    @dict = Dict.new(params[:dict])
    if @dict.save
      flash[:notice] = 'Dict was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @dict = Dict.find(params[:id])
  end

  def update
    @dict = Dict.find(params[:id])
    if @dict.update_attributes(params[:dict])
      flash[:notice] = 'Dict was successfully updated.'
      redirect_to :action => 'show', :id => @dict
    else
      render :action => 'edit'
    end
  end

  def destroy
    Dict.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  

end
