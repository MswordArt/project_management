namespace :target do
  desc "Target Reminder"
  task target_reminder: :environment do
    @tasks = Task.where(task_done: false)
    TaskMailer.target_reminder(@tasks).deliver
  end

end
