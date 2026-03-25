class User < ApplicationRecord
  include Pageable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[ github ]

  validates :name, presence: true

  has_one_attached :avatar

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

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      image_url = URI.parse(auth.info.image)
      image = image_url.open
      filename = File.basename(image_url.path)
      filetype = image.content_type.split("/")[1]
      user.avatar.attach(io: image, filename: "#{filename}.#{filetype}", content_type: image.content_type)
    end
  end
end
