require 'date'

class ToursController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_flat, only: [:show, :edit, :update, :destroy]

  def index
    @tours = policy_scope(Tour)
  end

  def search
    @tours = Tour.search(params[:hobbies], params[:city], params[:date], params[:num_travelers])
  end

end
