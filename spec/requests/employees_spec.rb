require "rails_helper"

RSpec.describe "Employees", type: :request do
  let(:valid_params) { { employee: { name: "Alice", position: "Dev", salary: 50_000 } } }
  let(:invalid_params) { { employee: { name: "", position: "Dev", salary: 50_000 } } }
  let(:employee) { Employee.create!(name: "Alice", position: "Dev", salary: 50_000) }

  describe "GET /employees" do
    it "returns http success" do
      get employees_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /employees/:id" do
    it "returns http success" do
      get employee_path(employee)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /employees/new" do
    it "returns http success" do
      get new_employee_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /employees" do
    it "creates employee and redirects" do
      post employees_path, params: valid_params
      expect(response).to have_http_status(:redirect)
    end

    it "does not create employee with invalid params" do
      post employees_path, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /employees/:id/edit" do
    it "returns http success" do
      get edit_employee_path(employee)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /employees/:id" do
    it "updates employee and redirects" do
      patch employee_path(employee), params: { employee: { name: "Bob", position: "Dev", salary: 60_000 } }
      expect(response).to have_http_status(:redirect)
    end

    it "does not update employee with invalid params" do
      patch employee_path(employee), params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /employees/:id" do
    it "destroys employee and redirects" do
      delete employee_path(employee)
      expect(response).to have_http_status(:redirect)
    end
  end
end
