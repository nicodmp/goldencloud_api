require 'csv'

class DebtImportService

  Result = Struct.new(:success_count, :error_rows)

  def initialize(file)
    @file       = file
    @successes  = 0
    @error_rows = []
  end

  def call
    CSV.foreach(@file.path, headers: true).with_index(2) do |row, line_number|
      if row.to_hash.values.any?(&:blank?)
        @error_rows << { line: line_number, error: 'Dados faltando em alguma coluna' }
        next
      end

      debt = Debt.new(
        name:           row['name'],
        governmentId:  row['governmentId'],
        email:          row['email'],
        debtAmount:    row['debtAmount'],
        debtDueDate:  row['debtDueDate'],
        debtId:        row['debtId']
      )

      if debt.save
        @successes += 1
      else
        @error_rows << { line: line_number, error: debt.errors.full_messages.join(', ') }
      end
    end

    Result.new(@successes, @error_rows)
  end
end
