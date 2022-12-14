class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :events
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one_attached :avatar

  before_validation :set_name, on: :create
  validates :name, presence: true, length: {maximum: 35}

  after_commit :link_subscriptions, on: :create

  private

  def set_name
    self.name = "Кое-кто №#{rand(777)}" if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
                .update_all(user_id: self.id)
  end
end
