class AddMissingFieldsToDebts < ActiveRecord::Migration[8.0]
  def change
    add_column :debts, :email, :string
    add_column :debts, :debtId, :string
  end
end
