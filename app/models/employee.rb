class Employee < ApplicationRecord
    validates :name, presence: true
    validates :position, presence: true
    validates :salary, presence: true, numericality: { greater_than: 0 }

    has_many :attendances, dependent: :destroy

    def worked_days(month, year)
        attendances.where(work_date: Date.new(year, month).all_month).where.not(check_out_at: nil).count
    end

    def total_ot_hours(month, year)
        attendances.where(work_date: Date.new(year, month).all_month).where.not(check_out_at: nil).sum(:overtime_hours)
    end

    def ot_pay(month, year)
        total_ot_hours(month, year) * (salary / 30.0 / 8.0)
    end

    def tax
        if salary <= 30_000
            0
        elsif salary <= 50_000
            (salary - 30_000) * 0.05
        else
            (20_000 * 0.05) + ((salary - 50_000) * 0.10)
        end
    end

    def net_pay(month, year)
        salary + ot_pay(month, year) - tax
    end
end
