class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User

  has_many :victories

  validates :nickname, presence: true, uniqueness: true
end