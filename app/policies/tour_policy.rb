class TourPolicy < ApplicationPolicy
  class Scope < Scope
    def index?
      true # Autorise l'accès à la liste des tours
    end

    def resolve
      scope.all # Renvoie tous les enregistrements de Tour
    end

    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
