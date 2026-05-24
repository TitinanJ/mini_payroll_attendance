require "rails_helper"

RSpec.describe Employee, type: :model do
  describe "validations about employee attributes" do
    it "is valid with name, position, and salary" do
      employee = Employee.new(name: "Alice", position: "Dev", salary: 50_000)
      expect(employee).to be_valid
      expect(employee.name).to eq("Alice")
      expect(employee.position).to eq("Dev")
      expect(employee.salary).to eq(50_000)
    end

    it "is invalid without name" do
      employee = Employee.new(position: "Dev", salary: 50_000)
      expect(employee).not_to be_valid
      expect(employee.errors[:name]).to be_present
    end

    it "is invalid without position" do
      employee = Employee.new(name: "Alice", salary: 50_000)
      expect(employee).not_to be_valid
      expect(employee.errors[:position]).to be_present
    end

    it "is invalid without salary" do
      employee = Employee.new(name: "Alice", position: "Dev")
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to be_present
    end

    it "is invalid when salary is 0" do
      employee = Employee.new(name: "Alice", position: "Dev", salary: 0)
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to be_present
    end

    it "is invalid when salary is negative" do
      employee = Employee.new(name: "Alice", position: "Dev", salary: -1000)
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to be_present
    end
  end

  describe "worked days count" do
    let(:employee) { Employee.create!(name: "Alice", position: "Dev", salary: 54_000) }

    it "returns 0 when no completed attendances" do
      expect(employee.worked_days(Date.today.month, Date.today.year)).to eq(0)
    end

    it "does not count attendance without checkout" do
      employee.attendances.create!(
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00")
      )
      expect(employee.worked_days(Date.today.month, Date.today.year)).to eq(0)
    end

    it "counts only completed attendances in the given month" do
      employee.attendances.create!(
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00"),
        check_out_at: Time.zone.parse("#{Date.today} 17:00")
      )
      expect(employee.worked_days(Date.today.month, Date.today.year)).to eq(1)
    end
  end

  describe "payroll calculations" do
    let(:employee) { Employee.create!(name: "Alice", position: "Dev", salary: 54_000) }

    describe "calculate tax" do
      it "returns 0 when salary <= 30,000" do
        employee.salary = 29_999
        expect(employee.tax).to eq(0)
      end

      it "returns 0 when salary is at the boundary of 30,000" do
        employee.salary = 30_000
        expect(employee.tax).to eq(0)
      end

      it "starts taxing at 5% when salary is 30,001" do
        employee.salary = 30_001
        expect(employee.tax).to eq(0.05)
      end

      it "returns 5% of amount over 30,000 when salary <= 50,000" do
        employee.salary = 40_000
        expect(employee.tax).to eq(500)
      end

      it "returns correct tax at upper boundary of 5% bracket (50,000)" do
        employee.salary = 50_000
        expect(employee.tax).to eq(1_000)
      end

      it "starts taxing at 10% for amount over 50,000 when salary is 50,001" do
        employee.salary = 50_001
        expect(employee.tax).to eq(1_000.1)
      end

      it "returns correct tax with two brackets when salary > 50,000" do
        employee.salary = 54_000
        expect(employee.tax).to eq(1_400)
      end
    end

    describe "calculate OT pay" do
      it "returns 0 when no OT hours" do
        expect(employee.ot_pay(Date.today.month, Date.today.year)).to eq(0)
      end

      it "calculates OT pay correctly" do
        employee.attendances.create!(
          work_date: Date.today,
          check_in_at: Time.zone.parse("#{Date.today} 08:00"),
          check_out_at: Time.zone.parse("#{Date.today} 18:00")
        )
        expected = 2 * (54_000.0 / 30 / 8)
        expect(employee.ot_pay(Date.today.month, Date.today.year)).to eq(expected)
      end
    end

    describe "calculate net pay" do
      it "calculates net pay as salary + OT pay - tax" do
        expect(employee.net_pay(Date.today.month, Date.today.year)).to eq(
          54_000 + 0 - 1_400
        )
      end

      it "calculates net pay with OT" do
        employee.attendances.create!(
          work_date: Date.today,
          check_in_at: Time.zone.parse("#{Date.today} 08:00"),
          check_out_at: Time.zone.parse("#{Date.today} 18:00"),
          overtime_hours: 2
        )
        ot = 2 * (54_000.0 / 30 / 8)
        expect(employee.net_pay(Date.today.month, Date.today.year)).to eq(
          54_000 + ot - 1_400
        )
      end
    end
  end
end
