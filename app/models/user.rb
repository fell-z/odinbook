class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  SENT_OPTS = { foreign_key: :follower_id, inverse_of: :follower, class_name: "Follow", dependent: :destroy }.freeze
  has_many :follow_requests_sent, -> { pending }, **SENT_OPTS
  has_many :accepted_follows_sent, -> { accepted }, **SENT_OPTS
  has_many :followees, through: :accepted_follows_sent

  RECEIVED_OPTS = { foreign_key: :followee_id, inverse_of: :followee, class_name: "Follow", dependent: :destroy }.freeze
  has_many :follow_requests_received, -> { pending }, **RECEIVED_OPTS
  has_many :accepted_follows_received, -> { accepted }, **RECEIVED_OPTS
  has_many :followers, through: :accepted_follows_received
end
