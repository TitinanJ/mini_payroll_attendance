require "rails_helper"

RSpec.describe "Attendances", type: :request do
  let(:employee) { Employee.create!(name: "Alice", position: "Dev", salary: 50_000) }

  describe "GET /employees/:employee_id/attendances" do
    it "returns http success" do
      get employee_attendances_path(employee)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /employees/:employee_id/attendances" do
    it "creates attendance and redirects" do
      post employee_attendances_path(employee), params: {
        check_in_at: "#{Date.today}T08:00"
      }
      expect(response).to have_http_status(:redirect)
    end

    it "does not create duplicate attendance on same day" do
      employee.attendances.create!(
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00")
      )
      post employee_attendances_path(employee), params: {
        check_in_at: "#{Date.today}T09:00"
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /attendances/:id/checkout" do
    let(:attendance) do
      employee.attendances.create!(
        work_date: Date.today,
        check_in_at: Time.zone.parse("#{Date.today} 08:00")
      )
    end

    it "updates check_out_at and redirects" do
      patch checkout_attendance_path(attendance), params: {
        check_out_at: "#{Date.today}T17:00"
      }
      expect(response).to have_http_status(:redirect)
    end

    it "redirects with alert when check_out_at is before check_in_at" do
      patch checkout_attendance_path(attendance), params: {
        check_out_at: "#{Date.today}T07:00"
      }
      expect(response).to have_http_status(:redirect)
    end
  end
end
