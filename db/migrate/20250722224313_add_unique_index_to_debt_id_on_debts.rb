class AddUniqueIndexToDebtIdOnDebts < ActiveRecord::Migration[8.0]
  def change
    add_index :debts, :debt_id, unique: true
  end
end
