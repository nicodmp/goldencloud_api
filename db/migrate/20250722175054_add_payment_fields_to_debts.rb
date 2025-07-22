class AddPaymentFieldsToDebts < ActiveRecord::Migration[8.0]
  def change
    add_column :debts, :paid_status, :boolean, default: false, null: false
    add_column :debts, :paid_at, :datetime
    add_column :debts, :paid_by, :string
  end
end
