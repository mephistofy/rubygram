class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", required: true
  belongs_to :followed, class_name: "User", required: true

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
