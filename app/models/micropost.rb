class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order created_at: :desc}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.maximum_length}
end
