namespace :task do
  desc "Task reminder"
  task task_reminder: :environment do
    @tasks = Task.where(task_done: false)
  TaskMailer.task_reminder(@tasks).deliver
  end

end


