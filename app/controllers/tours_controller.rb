require 'date'

class ToursController < ApplicationController
  include Pundit
  skip_before_action :authenticate_user!, only: [:index, :show]

  def show
    @tour = Tour.find(params[:id])
  end

  def create
    @tour = Tour.new(tour_params)
    @tour.image = params[:tour][:image] # Assigner le fichier téléchargé à l'attribut image

    # Le reste du code pour enregistrer le tour
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
    params.require(:tour).permit(:title, :description, :image)
  end

end
