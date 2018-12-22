class TaskMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_mailer.new_task.subject
  # foo = collection.inject([]) {|sum, item| sum << item }
  def new_task(task)
    @task = task
    @responsible = Responsible.find_by_task_id(@task.id)

    @task.responsibles.each do |res|
      @user = User.where(id: res.user_id).full_name
    

    end



    #@user = User.where(email: 'f@example.com')
    @emails = @task.responsibles.map {|res| User.find(res.user_id).email}
    #@user = User.find(@responsible.user_id)
    
    mail(to: @emails, subject: "New Task for you!")

    
      
      
  end
    

end
