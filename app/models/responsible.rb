class Responsible < ApplicationRecord
  belongs_to :task
  #delegate :full_name, to: :user, prefix: true
  
end
