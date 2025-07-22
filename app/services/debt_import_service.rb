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
    buffer_line_map = []

    CSV.foreach(@file.path, headers: true).with_index(2) do |row, line_number|
      row_hash = row.to_hash

      if row_hash.values.any?(&:blank?)
        @error_rows << { line: line_number, error: "Dados faltando em alguma coluna" }
        next
      end

      buffer << {
        name:           row_hash["name"],
        government_id:  row_hash["governmentId"],
        email:          row_hash["email"],
        debt_amount:    row_hash["debtAmount"],
        debt_due_date:  row_hash["debtDueDate"],
        debt_id:        row_hash["debtId"],
        created_at:     Time.current,
        updated_at:     Time.current
      }
      buffer_line_map << line_number

      if buffer.size >= batch_size
        process_batch!(buffer, buffer_line_map)
        buffer.clear
        buffer_line_map.clear
      end
    end

    process_batch!(buffer, buffer_line_map) if buffer.any?

    Result.new(@successes, @error_rows)
  end

  private
    def process_batch!(buffer, line_map)
      return if buffer.empty?

      debt_ids = buffer.map { |h| h[:debt_id] }

      existing = Debt.where(debt_id: debt_ids).pluck(:debt_id).to_set

      to_insert        = []
      insert_line_map  = []

      buffer.each_with_index do |attrs, idx|
        ln = line_map[idx]
        if existing.include?(attrs[:debt_id])
          @error_rows << { line: ln, error: "Debt ID #{attrs[:debt_id]} já existe" }
        else
          to_insert   << attrs
          insert_line_map << ln
        end
      end

      if to_insert.any?
        Debt.insert_all(to_insert, unique_by: :debt_id)
        @successes += to_insert.size
      end
    end
end
