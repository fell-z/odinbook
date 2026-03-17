class Comment < ApplicationRecord
  validates :body, presence: true, length: { in: 3..200 }

  belongs_to :post
  belongs_to :user
end
