class AttendancesController < ApplicationController
  before_action :set_employee, only: [ :index, :create ]
  before_action :set_attendance, only: [ :checkout ]
  def index
    @month = (params[:month] || Date.today.month).to_i
    @year = (params[:year] || Date.today.year).to_i
    @attendances = @employee.attendances.where(work_date: Date.new(@year, @month).all_month).order(work_date: :desc)
    @pending_attendance = @employee.attendances.where(check_out_at: nil).order(work_date: :desc).first
  end

  def create
    check_in_time = params[:check_in_at].presence && Time.zone.parse(params[:check_in_at])
    @attendance = @employee.attendances.build(
      work_date: check_in_time&.to_date,
      check_in_at: check_in_time
    )
    if @attendance.save
      redirect_to employee_attendances_path(@employee)
    else
      @month = (params[:month] || Date.today.month).to_i
      @year = (params[:year] || Date.today.year).to_i
      @attendances = @employee.attendances.where(work_date: Date.new(@year, @month).all_month).order(work_date: :desc)
      @pending_attendance = @employee.attendances.where(check_out_at: nil).order(work_date: :desc).first
      render :index, status: :unprocessable_entity
    end
  end

  def checkout
    check_out_time = Time.zone.parse(params[:check_out_at].presence || "")
    if check_out_time.nil?
      redirect_to employee_attendances_path(@attendance.employee), alert: "Check-out failed"
      return
    end
    if @attendance.update(check_out_at: check_out_time)
      redirect_to employee_attendances_path(@attendance.employee)
    else
      redirect_to employee_attendances_path(@attendance.employee), alert: "Check-out failed"
    end
  end

  private

  def set_employee
    @employee = Employee.find(params[:employee_id])
  end

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end
end
