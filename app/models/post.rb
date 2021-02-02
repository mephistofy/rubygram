# frozen_string_literal: true

class Post < ApplicationRecord
  include ImageUploader::Attachment(:image)

  validates :image_data, presence: true

  belongs_to :user

  has_many :comment, dependent: :destroy
  has_many :likes, dependent: :destroy
end
