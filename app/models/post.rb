class Post < ApplicationRecord
  include Pageable

  validates :body, presence: true, length: { maximum: 500 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :recent, -> { order(created_at: :desc) }
end
