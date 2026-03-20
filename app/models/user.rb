class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follow_requests_sent, foreign_key: :sender_id, class_name: "FollowRequest", dependent: :destroy
  has_many :active_follows, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy
  has_many :followees, through: :active_follows

  has_many :follow_requests_received, foreign_key: :receiver_id, class_name: "FollowRequest", dependent: :destroy
  has_many :passive_follows, foreign_key: :followee_id, class_name: "Follow", dependent: :destroy
  has_many :followers, through: :passive_follows
end
