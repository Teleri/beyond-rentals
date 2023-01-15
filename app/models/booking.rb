class Booking < ApplicationRecord
  validates :start_date, :end_date, presence: true
  belongs_to :planet
  belongs_to :user

  def confirmed?
    self.status
  end

  def not_confirmed?
    !self.status
  end
  

  def confirm
    self.update(status: true)
  end
end
