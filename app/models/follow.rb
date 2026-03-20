class Follow < ApplicationRecord
  validates :follower_id, uniqueness: { scope: :followee_id, message: "already followed" }
  validate :cannot_follow_self

  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  private

  def cannot_follow_self
    errors.add(:follower_id, "cannot follow yourself") if follower_id == followee_id
  end
end
