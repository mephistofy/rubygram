class Comment < ApplicationRecord
  belongs_to :post

  validates :comment, presence: true, length: {minimum:1, maximum:200}
end
