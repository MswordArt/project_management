class Task < ApplicationRecord
    has_many :responsibles
    accepts_nested_attributes_for :responsibles
end
