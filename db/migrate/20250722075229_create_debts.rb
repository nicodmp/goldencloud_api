class CreateDebts < ActiveRecord::Migration[8.0]
  def change
    create_table :debts do |t|
      t.string :name
      t.string :governmentId
      t.decimal :debtAmount
      t.time :debtDueDate
      t.timestamps
    end
  end
end
