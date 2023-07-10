class ReviewPolicy < ApplicationPolicy
  def index?
    true # Autorise l'accès à la liste des tours
  end

  def new?
    true # Autoriser tous les utilisateurs à créer un nouvel objet Tour
  end

  def create?
    true # Autorise la création d'un tour
  end

  def resolve
    scope.all # Renvoie tous les enregistrements de Tour
  end
end
