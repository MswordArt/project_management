json.extract! task, :id, :name, :description, :completed, :target_date, :created_at, :updated_at
json.url task_url(task, format: :json)
