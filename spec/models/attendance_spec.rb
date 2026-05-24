require "rails_helper"

RSpec.describe Attendance, type: :model do
  let(:employee) { Employee.create!(name: "Alice", position: "Dev", salary: 50_000) }

  describe "validations about check-in and check-out times" do
    it "is valid with employee, work_date, and check_in_at" do
      check_in_time = Time.zone.parse("#{Date.today} 08:00")
      attendance = Attendance.new(
        employee: employee,
        work_date: Date.today,
        check_in_at: check_in_time
      )
      expect(attendance).to be_valid
      expect(attendance.employee).to be_valid
      expect(attendance.work_date).to eq(check_in_time.to_date)
      expect(attendance.check_in_at).to eq(check_in_time)
      expect(attendance.check_out_at).to be_nil
      expect(attendance.overtime_hours).to be_nil
    end

    it "is invalid without work_date" do
      attendance = Attendance.new(employee: employee, check_in_at: Time.zone.now)
      expect(attendance).not_to be_valid
      expect(attendance.errors[:work_date]).to include("can't be blank")
    end

    it "is invalid without check_in_at" do
      attendance = Attendance.new(employee: employee, work_date: Date.today)
      expect(attendance).not_to be_valid
      expect(attendance.errors[:check_in_at]).to include("can't be blank")
    end

    it "cannot check-in twice on the same day" do
      employee.attendances.create!(
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00")
      )
      duplicate = Attendance.new(
        employee: employee,
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 09:00")
      )
      expect(duplicate).not_to be_valid
    end

    it "is invalid when check_out_at is before check_in_at" do
      attendance = Attendance.new(
        employee: employee,
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 10:00"),
        check_out_at: Time.zone.parse("#{Date.today} 08:00")
      )
      expect(attendance).not_to be_valid
      expect(attendance.errors[:check_out_at]).to include("must be after check-in time")
    end

    it "is invalid when check_out_at equals check_in_at" do
      attendance = Attendance.new(
        employee: employee,
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00"),
        check_out_at: Time.zone.parse("#{Date.today} 08:00")
      )
      expect(attendance).not_to be_valid
      expect(attendance.errors[:check_out_at]).to include("must be after check-in time")
    end
  end

  describe "calculate OT hours" do
    it "calculates 0 OT when working exactly 8 hours" do
      attendance = employee.attendances.create!(
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00"),
        check_out_at: Time.zone.parse("#{Date.today} 16:00")
      )
      expect(attendance.reload.overtime_hours).to eq(0)
    end

    it "calculates correct OT hours when working more than 8 hours" do
      attendance = employee.attendances.create!(
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00"),
        check_out_at: Time.zone.parse("#{Date.today} 18:30")
      )
      expect(attendance.reload.overtime_hours).to eq(2.5)
    end

    it "calculates 0 OT when working less than 8 hours" do
      attendance = employee.attendances.create!(
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00"),
        check_out_at: Time.zone.parse("#{Date.today} 14:00")
      )
      expect(attendance.reload.overtime_hours).to eq(0)
    end
  end
end
