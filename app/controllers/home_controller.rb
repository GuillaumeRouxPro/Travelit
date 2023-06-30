class HomeController < ApplicationController
  def index
    @homes = policy_scope(Home)
  end
end
