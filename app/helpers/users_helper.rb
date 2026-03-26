module UsersHelper
  def avatar_with_fallback(user, size: 32)
    link_to user_profile_path(user) do
      if user.avatar.attached?
        image_tag user.avatar, alt: "user avatar", size:
      else
        image_tag "default-user.svg", alt: "user avatar", size:
      end
    end
  end
end
