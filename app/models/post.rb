class Post < ApplicationRecord
  include ImageUploader::Attachment(:image)
 
  validates :image_data, presence: true

  belongs_to :user, required: true

  has_many :comment
  has_many :likes
end
