class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    check = true
    # raise
    if user == record.tour.user
      check = false
    end
    user.bookings.each do |userbook|
      if record.tour.bookings.include?(userbook)
        return false
      end
    end
    check
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


  def accept_refuse?
    true
  end


  def refuse?
    true
  end
end
