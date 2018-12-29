class CommentMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comment_mailer.new_comment.subject
  #
  def new_comment(comment)
    @comment = comment
    @commentable_type = @comment.commentable_type
    @task = Task.find(comment.commentable_id)
    @project = Project.find(@task.project_id)
    

    mail to: @comment.commentable.user.email, subject: "You have a new Comment!" unless @comment.commentable.user == @comment.user
    #mail to: @task.user.email, subject: "New Comment on your task!" unless @task.user == @comment.user
    




    # @commentable = @comment.commentable
    # @comments = @commentable.comments
    # # with variables set, let's create the loop to do its magic 
    # @comments.each do |com|
    #   @com_username = com.user.full_name
    #   if com.commentable.type == "Comment"
    #     mail to: @commentable.user.email, subject: "New Reply Comment on your task"
    #   else
    #     mail to: @commentable.user.email, subject: "New Comment on your task"
    #   end
    #   mail = mail(
    #       :to => "#{com.user.email}",
    #       #:from => "noreply@foo.org",
    #       #:return_path => "noreply@foo.org",  
    #       :subject => "New Comment on: #{@task.name}",
    #       :body => "Hi #{com.user.full_name}" 
    #       #:template_path => 'blaster',
    #       #:template_name => 'blast'
    #   )do |format|
    #   format.html { render 'new_comment.html.slim'}
    #   format.text { render 'new_comment.text.erb'}
    #   end   
    #   #mail.deliver
    # end # contacts.each loop
  end



  
end
