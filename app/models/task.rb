class Task < ApplicationRecord
    belongs_to :project, optional: true
    belongs_to :user
    has_many :responsibles, dependent: :destroy
    accepts_nested_attributes_for :responsibles, reject_if: :all_blank, allow_destroy: true
    has_many :comments, as: :commentable, dependent: :destroy
end
