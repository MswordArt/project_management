class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :task_done, :destroy]
  before_action :isadmin?, only: [:create, :new, :edit, :destroy, :completed]
  before_action :res_user, only:[:edit, :destroy,:update, :show]
  # GET /tasks
  # GET /tasks.json
  def index
    if current_user.admin?
    @tasks = Task.order('created_at DESC')
    else
      @tasks = Task.joins(:responsibles).where('responsibles.user_id' => current_user.id, completed: false).order('created_at DESC')
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @responsibles = @task.responsibles
    @responsible = Responsible.find_by_task_id(:task_id)
    #@responsible.full_name = User.find_by_id(@responsible.user_id).full_name
    
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def mytasks    
    @mytasks = Task.joins(:responsibles).where('responsibles.user_id' => current_user.id)     
  end

def task_done
  @progress = 100 / @task.responsibles.size.to_f
     
    if @task.responsibles.exists?(user_id: current_user.id)
      @task.responsibles.each do |res|
        if res.done? && res.user_id == current_user.id
          res.done = false 
          res.save! 
          @task.decrement!(:progress, @progress) 
          redirect_to task_url, notice: 'Your task done mark  invoked succesfully.'         
        elsif res.done == false && res.user_id == current_user.id
          res.done = true
          res.save!       
          @task.increment!(:progress, @progress)
          redirect_to task_url, notice: 'You marked task as done. Waiting approve from management after %100 progress'           
        end


                  
      end
      



  
    else
      redirect_to tasks_url, alert: 'You have no responsibility for this task'
    end
   
  
    
    
    if @task.responsibles == true
      @task.update_attribute(:task_done, true)
      @task.save
    else
        @task.update_attribute(:task_done, false)
        @task.save
    end

             

end

def completed
    if current_user.admin?
    @tasks = Task.order('created_at DESC').where(completed: true)
    else
      redirect_to root_path, alert: "You have no permission for that event" unless current_user.admin?
    end
 
  
end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :completed, :target_date, responsibles_attributes:[:id,:user_id, :_destroy])
    end


def isadmin?
  redirect_to root_path, alert: "You have no permission for that event" unless current_user.admin?
end

def res_user
 redirect_to root_path, alert: "You are not responsible for this task" unless @task.responsibles.exists?(user_id: current_user.id) or current_user.admin?
  
end



def decrement!(attribute, by = 1)
  decrement(attribute, by).update_attribute(attribute, self[attribute])
end

def increment!(attribute, by = 1)
  increment(attribute, by).update_attribute(attribute, self[attribute])
end




end
