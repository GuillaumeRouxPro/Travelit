class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    user != record.tour.user
  end

  def show?
    user == record.tour.user || user == record.user
  end

  def index?
    true
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end


  def accept?
    true
  end


  def refuse?
    true
  end
end
