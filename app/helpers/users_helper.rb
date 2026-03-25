module UsersHelper
  def avatar_with_fallback(user)
    if user.avatar.attached?
      image_tag user.avatar, alt: "user avatar", size: 48
    else
      image_tag "default-user.svg", alt: "user avatar", size: 48
    end
  end
end
