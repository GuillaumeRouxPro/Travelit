require 'date'

class ToursController < ApplicationController
  include Pundit
  skip_before_action :authenticate_user!, only: [:index, :show]

  def show
    @tour = Tour.find(params[:id])
  end

  def create
    @tour = Tour.new(tour_params)
    hobby_ids = params[:tour][:hobby_ids]
    @tour.save
    if params[:tour][:image]
      @tour.image = params[:tour][:image] # Assigner le fichier téléchargé à l'attribut image
    end
    hobby_ids.each do |tour_hobby|
      user_hobby = UserHobby.find_or_initialize_by(user_id: @tour.user.id, hobby_id: tour_hobby, tour_id: @tour.id)
      if user_hobby.new_record?
        user_hobby.save!
        if !Hobby.exists?(tour_hobby)
          name = Hobby.find(tour_hobby)
          Hobby.create!(name: name, icon: "link") # To do add link from the impuut
        end
      end
    end
    redirect_to root_path
  end

  def new
    @tour = Tour.new
    @hobby = Hobby.all
  end

  def index
    @tours = policy_scope(Tour)
  end

  def search
    @tours = Tour.search(params[:hobbies], params[:city], params[:date], params[:num_travelers])
  end

  def tour_params
    params.require(:tour).permit(:name, :description, :image, :price, :number_of_travlers, :user_id, :city, photos: [], hobby_ids: [])
  end

end
