class ChangeDebtDueDateToDate < ActiveRecord::Migration[8.0]
  def up
    remove_column :debts, :debtDueDate, :time

    add_column :debts, :debt_due_date, :date, null: false, default: '1970-01-01'
    change_column_default :debts, :debt_due_date, from: '1970-01-01', to: nil
  end

  def down
    remove_column :debts, :debt_due_date, :date
    add_column    :debts, :debtDueDate,    :time
  end
end
