class TaskMailer < ApplicationMailer

   def new_task(task)


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



















end
