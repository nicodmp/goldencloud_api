class Debt < ApplicationRecord
  validates :name, :governmentId, :email, :debtAmount, :debtDueDate, :debtId, presence: true

  validates :debtAmount, numericality: { greater_than_or_equal_to: 0 }
end
