class Post < ApplicationRecord
  validates :body, presence: true, length: { maximum: 500 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end
