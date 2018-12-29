class TaskMailer < ApplicationMailer

   def new_task(project, task)
    @project = project
    @task = task
  
  
  @responsibles = @task.responsibles

  # with variables set, let's create the loop to do its magic 
  @responsibles.each do |res|
    @res_username = User.find(res.user_id).full_name
    
    mail = mail(
        :to => "#{User.find(res.user_id).email}",
        #:from => "noreply@foo.org",
        #:return_path => "noreply@foo.org",  
        :subject => "New Task: #{@task.name}",
        :body => "Hi #{User.find(res.user_id).full_name}" 
        #:template_path => 'blaster',
        #:template_name => 'blast'
    )do |format|
    format.html { render 'new_task.html.slim'}
    format.text { render 'new_task.text.erb'}
    end   
    mail.deliver
  end # contacts.each loop
end











def task_done(project, task)
  @project = project
  @task = task
  @res = @task.responsibles.order("updated_at").last
  @res_username = User.find(@res.user_id).full_name

  if @res.done?
  mail to: @task.user.email, subject: "#{@res_username} Marked as done at task!" unless @task.user.full_name == @res_username
  else
    mail to: @task.user.email, subject: "#{@res_username} Invoked back task done!" unless @task.user.full_name == @res_username
  end  
  
end






def task_reminder(task)
  @tasks = task
  
  #@responsibles = @task.responsibles


@tasks.each do |task|
  @project = Project.find(task.project_id)
  @task = task
  task.responsibles.each do |res|
    if res.done == false
    @res_username = User.find(res.user_id).full_name
    mail = mail(
        :to => "#{User.find(res.user_id).email}",
        #:from => "noreply@foo.org",
        #:return_path => "noreply@foo.org",  
        :subject => "Task reminder: #{@task.name}",
        :body => "Hi #{User.find(res.user_id).full_name}" 
        #:template_path => 'blaster',
        #:template_name => 'blast'
    )do |format|
    format.html { render 'task_reminder.html.slim'}
    #format.text { render 'task_reminder.text.erb'}
    end   
    mail.deliver
  end 
end
end
  
end



def target_reminder(task)
  @tasks = task
  
  #@responsibles = @task.responsibles


@tasks.each do |task|
  @project = Project.find(task.project_id)
  @task = task
  if (task.target_date.to_date - Time.now.to_date).to_i < 2
  task.responsibles.each do |res|
    if res.done == false and res.notified == false
    @res_username = User.find(res.user_id).full_name
    mail = mail(
        :to => "#{User.find(res.user_id).email}",
        #:from => "noreply@foo.org",
        #:return_path => "noreply@foo.org",  
        :subject => "Target Warning: #{@task.name}",
        :body => "Hi #{User.find(res.user_id).full_name}" 
        #:template_path => 'blaster',
        #:template_name => 'blast'
    )do |format|
    format.html { render 'target_reminder.html.slim'}
    #format.text { render 'task_reminder.text.erb'}
    end   
    mail.deliver
    res.notified = true
    res.save!
  end 
end
end # if target date
end
end






end
