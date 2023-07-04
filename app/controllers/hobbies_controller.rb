class HobbiesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    @hobbies = policy_scope(Hobby)
  end
end
