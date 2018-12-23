class TaskMailer < ApplicationMailer

  #old method
   def new_task(task)
  #   @task = task
  #   @responsible = Responsible.find_by_task_id(@task.id)

  #   @task.responsibles.each do |res|
  #     @user = User.where(id: res.user_id).full_name
    

  #   end

  #   #@user = User.where(email: 'f@example.com')
  #   @emails = @task.responsibles.map {|res| User.find(res.user_id).email}
  #   #@user = User.find(@responsible.user_id)
    
  #   mail(to: @emails, subject: "New Task: #{@task.name}")

  # end
    

  @task = task
  @responsibles = @task.responsibles

  # with variables set, let's create the loop to do its magic 
  @responsibles.each do |res|
    mail = mail(
        to: "#{User.find(res.user_id).email}",
        #:from => "noreply@foo.org",
        #:return_path => "noreply@foo.org",  
        subject: "New Task: #{@task.name}",
        #body: "Hi #{User.find(res.user_id).full_name}" 
        #:template_path => 'blaster',
        #:template_name => 'blast'
    )
    do |format|
        format.html { render 'blast.html.erb'}
        format.text { render 'blast.text.erb'}
        end   
    mail.deliver
  end # contacts.each loop
end



















end
