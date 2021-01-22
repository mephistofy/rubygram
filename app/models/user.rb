class User < ApplicationRecord
  extend Devise::Models
  include ImageUploader::Attachment(:avatar) 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :post
end
