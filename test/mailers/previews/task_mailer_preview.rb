# Preview all emails at http://localhost:3000/rails/mailers/task_mailer
class TaskMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/new_task
  def new_task
    task = Task.last
    TaskMailer.new_task(task)
  end

end
