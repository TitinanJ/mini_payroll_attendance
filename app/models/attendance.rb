class Attendance < ApplicationRecord
  belongs_to :employee

  validates :work_date, presence: true
  validates :work_date, uniqueness: { scope: :employee_id }
  validates :check_in_at, presence: true
  validate :checkout_after_checkin

  before_save :calculate_overtime

  private

  def  checkout_after_checkin
    return unless check_in_at && check_out_at
    errors.add(:check_out_at, "must be after check-in time") if check_out_at <= check_in_at
  end

  def calculate_overtime
    return unless check_in_at && check_out_at
    worked_hours = (check_out_at - check_in_at) / 3600.0
    self.overtime_hours = [ worked_hours - 8, 0 ].max
  end
end
