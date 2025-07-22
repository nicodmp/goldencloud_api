class CreateDebts < ActiveRecord::Migration[8.0]
  def change
    create_table :debts do |t|
      t.string :name
      t.string :governmentId
      t.string :email
      t.decimal :debtAmount
      t.time :debtDueDate
      t.string :debtId
      t.timestamps
    end
  end
end
