class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:new, :create, :show, :edit, :update, :task_done, :destroy, :mytasks]
  before_action :set_task, only: [:show, :edit, :update, :task_done, :destroy]
  before_action :isadmin?, only: [:create, :new, :edit, :destroy, :completed]
  before_action :res_user, only:[:edit, :destroy,:update, :show]
  # GET /tasks
  # GET /tasks.json
  def index
    @project = Project.find(params[:project_id])
    if current_user.admin?
    @tasks = @project.tasks.order('created_at DESC')
    else
      @tasks = @project.tasks.joins(:responsibles).where('responsibles.user_id' => current_user.id, completed: false).order('created_at DESC')
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
    #@project = Project.find(params[:id])
    @responsibles = @task.responsibles
    @responsible = Responsible.find_by_task_id(:task_id)
    @task.responsibles.each do |res|
      if res.user_id == current_user.id
      res.viewed = true unless res.viewed?
      res.save!
      end
    end
    #@responsible.full_name = User.find_by_id(@responsible.user_id).full_name
    
  end

  # GET /tasks/new
  def new
    @task = @project.tasks.new
    #@project = Project.find(params[:id])
    
    
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new(task_params)
    @task.user_id = current_user.id
    #@responsible = @task.responsibles.build

    respond_to do |format|
      if @task.save
        TaskMailer.new_task(@project,@task).deliver
        format.html { redirect_to project_task_path(@project, @task), notice: 'Task was successfully created.' }
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
        format.html { redirect_to @project, notice: 'Task was successfully updated.' }
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
      format.html { redirect_to project_url(@project), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  

  def task_done
    @progress = 100 / @task.responsibles.size.to_f
     
    if @task.responsibles.exists?(user_id: current_user.id)
      @task.responsibles.each do |res|
        if res.done? && res.user_id == current_user.id
          res.done = false 
          res.save! 
          @task.decrement!(:progress, @progress) 
          redirect_to project_task_url(@project, @task), notice: 'Your task done mark  invoked succesfully.'
          TaskMailer.task_done(@project, @task).deliver         
        elsif res.done == false && res.user_id == current_user.id
          res.done = true
          res.save!       
          @task.increment!(:progress, @progress)
          redirect_to project_task_url(@project, @task), notice: 'You marked task as done. Waiting approve from management after %100 progress' 
           TaskMailer.task_done(@project, @task).deliver          
        end                  
      end
  
    else
      redirect_to tasks_url, alert: 'You have no responsibility for this task'
    end  
    
    
      if @task.responsibles.all?(&:done?)
      @task.update_attribute(:task_done, true)
      @task.save
      else
        @task.update_attribute(:task_done, false)
        @task.save
      end           

  end

  

    def task_reminder
      @tasks = Task.where(task_done: false)
      TaskMailer.task_reminder(@tasks).deliver

      
    end


    def mytasks  
      @project = Project.find(params[:project_id])  
      @mytasks = @project.tasks.joins(:responsibles).where('responsibles.user_id' => current_user.id)     
    end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @project = Project.find(params[:project_id])
      @task = @project.tasks.find(params[:id])
    end
    def set_project
      @project = Project.find(params[:project_id])
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
