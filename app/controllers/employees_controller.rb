class EmployeesController < ApplicationController
    def index
        @employees = Employee.all
    end

    def show
        @employee = Employee.find(params[:id])
        @month = (params[:month] || Date.today.month).to_i
        @year = (params[:year] || Date.today.year).to_i
    end

    def new
        @employee = Employee.new
    end

    def create
        @employee = Employee.new(employee_params)
        if @employee.save
            redirect_to @employee
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @employee = Employee.find(params[:id])
    end

    def update
        @employee = Employee.find(params[:id])
        if @employee.update(employee_params)
            redirect_to @employee
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @employee = Employee.find(params[:id])
        @employee.destroy
        redirect_to employees_path
    end

    private
    def employee_params 
        params.require(:employee).permit(:name, :position, :salary)
    end
end
