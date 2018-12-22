class User < ApplicationRecord
  has_many :tasks
  has_many :comments, dependent: :destroy
  #has_many :responsibles, through: :tasks
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
