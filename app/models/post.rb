class Post < ApplicationRecord
  include ImageUploader::Attachment(:image) 
  belongs_to :user
  has_many :comment
end
