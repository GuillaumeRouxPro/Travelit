class HobbiesController < ApplicationController
  respond_to :html, :js
  skip_before_action :authenticate_user!, only: :index
  def index
    @hobbies = policy_scope(Hobby)
  end

  def new
    @hobby = Hobby.new
    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  private

  def hobby_params
    params.require(:hobby).permit(:name)
  end
end
