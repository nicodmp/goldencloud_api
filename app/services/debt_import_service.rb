require "csv"

class DebtImportService
  Result = Struct.new(:success_count, :error_rows)

  def initialize(file)
    @file       = file
    @successes  = 0
    @error_rows = []
  end

  def call
    batch_size = 1_000
    buffer = []

    CSV.foreach(@file.path, headers: true).with_index(2) do |row, line_number|
      if row.to_hash.values.any?(&:blank?)
        @error_rows << { line: line_number, error: "Dados faltando em alguma coluna" }
        next
      end

      buffer << {
        name:           row["name"],
        government_id:  row["governmentId"],
        email:          row["email"],
        debt_amount:    row["debtAmount"],
        debt_due_date:  row["debtDueDate"],
        debt_id:        row["debtId"],
        created_at:     Time.current,
        updated_at:     Time.current
      }

      if buffer.size >= batch_size
        Debt.insert_all(buffer, unique_by: :debt_id)
        @successes += buffer.size
        buffer.clear
      end
    end

    if buffer.any?
      Debt.insert_all(buffer)
      @successes += buffer.size
    end

    Result.new(@successes, @error_rows)
  end
end
