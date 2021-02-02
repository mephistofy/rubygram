class Like < ApplicationRecord
  belongs_to :post, required: true
  belongs_to :user, required: true
end
