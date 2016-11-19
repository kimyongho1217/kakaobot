class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_secure_token :api_token
  validates :email, uniqueness: true
  validates :password, confirmation: true
  validates_confirmation_of :password

  before_save do
    self.email.downcase! if self.email
  end

  def self.find_for_authentication(conditions)
    conditions[:email].downcase!
    super(conditions)
  end
end
