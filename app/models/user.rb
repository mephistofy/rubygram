class User < ApplicationRecord
  extend Devise::Models
  include ImageUploader::Attachment(:avatar) 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :post

  def follow(user)
    active_follows.create(followed_id: user.id)
  end

  def unfollow(user)
    active_follows.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end
end
