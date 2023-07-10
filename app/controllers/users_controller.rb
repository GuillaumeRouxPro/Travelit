class UsersController < ApplicationController
  def become_guide
    current_user.update(is_a_guide: true)
    redirect_to root_path
  end
end
