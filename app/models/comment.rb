class Comment < ApplicationRecord
  belongs_to :post, required: true

  validates :comment, presence: true, length: {minimum:1, maximum:200}
  validates :author_id, presence: true
end
