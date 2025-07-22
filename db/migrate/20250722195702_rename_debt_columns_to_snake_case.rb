class RenameDebtColumnsToSnakeCase < ActiveRecord::Migration[8.0]
  def change
    rename_column :debts, :governmentId, :government_id
    rename_column :debts, :debtAmount, :debt_amount
    rename_column :debts, :debtId, :debt_id
  end
end
