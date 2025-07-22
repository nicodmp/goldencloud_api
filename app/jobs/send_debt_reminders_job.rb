class SendDebtRemindersJob < ApplicationJob
  queue_as :default

  def perform
    Debt.where(paid_status: false).find_each do |debt|
      DebtMailer.reminder(debt).deliver_later
    end
  end
end
