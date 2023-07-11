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
    new_hobby = params[:tour][:hobbies]

    @tour.save
    if new_hobby
      new_hobb = Hobby.create!(name: new_hobby[:name], icon: new_hobby[:icon])
      user_hobby = UserHobby.find_or_initialize_by(user_id: @tour.user.id, hobby_id: new_hobb.id, tour_id: @tour.id)
      if user_hobby.new_record?
        user_hobby.save!
      end
    end
    if params[:tour][:image]
      @tour.image = params[:tour][:image] # Assigner le fichier téléchargé à l'attribut image
    end

    if hobby_ids
      hobby_ids.each do |tour_hobby|
        user_hobby = UserHobby.find_or_initialize_by(user_id: @tour.user.id, hobby_id: tour_hobby, tour_id: @tour.id)
        if user_hobby.new_record?
          user_hobby.save!
          if !Hobby.exists?(tour_hobby)
            name = Hobby.find(tour_hobby) # normaly we dont need this
            Hobby.create!(name: name, icon: "link") # To do add link from the impuut
          end
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

  # va rechercher des tour specifiaue
  def top_match
    @tours = Tour.find(params[:tour_ids])
  end

  def my_tours
    user = current_user
    @tours = Tour.where(user_id: user.id)
  end

  def search
    @tours = Tour.search(params[:hobbies], params[:city], params[:date], params[:num_travelers])
  end

  def tour_params
    params.require(:tour).permit(:hobbies, :name, :description, :image, :price, :number_of_travlers, :user_id, :city, photos: [], hobby_ids: [])
  end

end
