class FollowRequest < ApplicationRecord
  validates :sender_id, uniqueness: { scope: :receiver_id, message: "already sent a follow request" }
  validate :cannot_request_self

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  private

  def cannot_request_self
    errors.add(:sender_id, "cannot request yourself") if sender_id == receiver_id
  end
end
