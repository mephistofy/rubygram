# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post

  validates :comment, presence: true, length: { minimum: 1, maximum: 200 }
  validates :author_id, presence: true
end
