class Debt < ApplicationRecord
  validates :name, :government_id, :email, :debt_amount, :debt_due_date, :debt_id, presence: true
  validates_uniqueness_of :debt_id

  validates :debt_amount, numericality: { greater_than_or_equal_to: 0 }
end
