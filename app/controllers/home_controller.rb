class HomeController < ApplicationController
  before_action :set_home, only: %i[search]
  def search
    authorize @search
    @hobbies = Hobby.all
    @tour =
    if params[:city].present? || params[:date].present?
      Tour.where(city: params[:city])
    else
      nil
    end
    if @tour.nil? || @tour.empty?
      #flash.now[:alert] = 'There are no tours that match your search.'
      render 'search' and return
    end
    selected_hobbies = params[:tour][:hobby_ids]
    selected_hobbies.map!(&:to_i)
    tour_hobbies = UserHobby.order(:tour_id)
    tour_hobby_counts = tour_hobbies.each_with_object(Hash.new(0)) do |user_hobby, counts|
      if selected_hobbies.include?(user_hobby.hobby_id)
        counts[user_hobby.tour_id] += 1
      end
    end
    redirect_to top_match_tours_path(tour_ids: tour_hobby_counts.keys)
  end



  private

  def set_home
    @search = current_user
  end

  def tour_params
    params.require(:search).permit(:date, :city, :hobby_ids [], :hobbies [], :num_travelers )
  end
end
