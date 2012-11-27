class OvertimesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
        
    init_set
    @ot_types = Dict.find(:all, :conditions => "category = 'ot_type'")
     
    @overtime = Overtime.new(params[:overtime])
    @period = Period.new(params[:period])
    
    sql_condition =" 1 "
    sql_condition += " and '#{@period.starting_date}' <= ot_date  " unless @period.starting_date.nil?
    sql_condition += " and '#{@period.ending_date}' >= ot_date  " unless @period.ending_date.nil?
    if request.get?
      sql_condition = cookies[:sql] unless params[:overtime].nil?
    else
      sql_condition += " and person_id  = #{@overtime.person_id} " unless @overtime.person_id.nil? or @overtime.person_id ==0 
      if @overtime.ot_type_id > 0
        sql_condition += " and ot_type_id = #{@overtime.ot_type_id} " 
      else
        sql_condition += "and ( 0"
        @ot_types.each do |ot_type|
          if @overtime.ot_type_id == 0 and ot_type.code.to_i >0 # ot type+
            sql_condition += " or ot_type_id = #{ot_type.id} " 
          end
          if  @overtime.ot_type_id ==-1 and ot_type.code.to_i <0 #ot type-
            sql_condition += " or ot_type_id = #{ot_type.id} " 
          end 
        end
        sql_condition += " ) "
     end

    end
    @sql = sql_condition
    cookies[:sql] = sql_condition
    @sum_ot = Overtime.new
    @sum_ot.real_hours = Overtime.sum("real_hours",:conditions =>sql_condition )
    @sum_ot.ot_hours = Overtime.sum("ot_hours",:conditions =>sql_condition)

    @overtime_pages, @overtimes = paginate :overtimes, :per_page => 30, :conditions =>sql_condition
  end

  def show
    @overtime = Overtime.find(params[:id])
  end

  def new
    init_set
    @ot_types = Dict.find(:all, :conditions => "category = 'ot_type'")
    @overtime = Overtime.new
  end

  def create
    @overtime = Overtime.new(params[:overtime])
    count_ot_hour
    if @overtime.save
      flash[:notice] = 'Overtime was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @ot_types = Dict.find(:all, :conditions => "category = 'ot_type'")
    @overtime = Overtime.find(params[:id])
  end

  def update
    @overtime = Overtime.find(params[:id])
    
    if @overtime.update_attributes(params[:overtime])
      @overtime = Overtime.find(params[:id])
      count_ot_hour
      @overtime.update
      flash[:notice] = 'Overtime was successfully updated.'
      redirect_to :action => 'show', :id => @overtime
    else
      render :action => 'edit'
    end
  end

  def destroy
    Overtime.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  private
  def count_ot_hour
    @overtime.ot_hours = @overtime.real_hours * @overtime.ot_type.code.to_i
    @overtime.ot_hours = @overtime.real_hours * (1.5) if @overtime.ot_type.code =='1.5'
  end
end
