class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy
  has_many :carts, dependent: :nullify

  validates :first_name, :last_name, presence: true

  def full_name
    [first_name, last_name].compact.join(" ").strip
  end
end
