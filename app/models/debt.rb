class Debt < ApplicationRecord
  validates :name, :governmentId, :debtAmount, :debtDueDate, presence: true

  validates :debtAmount, numericality: { greater_than_or_equal_to: 0 }
end
