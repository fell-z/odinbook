class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follow_requests_received, -> { pending }, foreign_key: :followee_id, class_name: "Follow", dependent: :destroy
  has_many :follow_requests_sent, -> { pending }, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy

  has_many :active_follows, -> { accepted }, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy

  has_many :followees, through: :active_follows

  def follows?(user)
    active_follows.exists?(followee: user)
  end

  def requested_follow?(user)
    follow_requests_sent.exists?(followee: user)
  end

  def find_follow(user)
    active_follows.find_by(followee: user)
  end

  def find_follow_request(user)
    follow_requests_sent.find_by(followee: user)
  end
end
