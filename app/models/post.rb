class Post < ApplicationRecord
  include ImageUploader::Attachment(:image)
 
  belongs_to :user
  has_many :comment
  has_many :likes
end
