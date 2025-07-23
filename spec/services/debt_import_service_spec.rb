require 'rails_helper'
require 'tempfile'

RSpec.describe DebtImportService, type: :service do
  describe '#call' do
    let(:headers) { %w[name governmentId email debtAmount debtDueDate debtId] }
    let(:valid_row) do
      [ 'Fulano de Tal', '12345678900', 'fulano@example.com', '150.50', '2025-08-08', 'debt-1-1234' ]
    end
    let(:valid_row_2) do
      [ 'Siclano de Tal', '12345678901', 'siclano@example.com', '150.50', '2025-08-08', 'debt-2-1234' ]
    end

    context 'quando todas as linhas são válidas' do
      it 'importa todos os registros sem erros' do
        file = Tempfile.new([ 'valid', '.csv' ])
        csv_content = CSV.generate do |csv|
          csv << headers
          csv << valid_row
          csv << valid_row_2
        end
        file.write(csv_content)
        file.rewind

        result = DebtImportService.new(file).call

        expect(result.success_count).to eq(2)
        expect(result.error_rows).to be_empty
        expect(Debt.count).to eq(2)
        expect(Debt.pluck(:debt_id)).to match_array(%w[debt-1-1234 debt-2-1234])

        file.close
        file.unlink
      end
    end

    context 'quando há linhas com dados faltando' do
      it 'registra erro para as linhas incompletas e continua' do
        file = Tempfile.new([ 'missing', '.csv' ])
        csv_content = CSV.generate do |csv|
          csv << headers
          csv << valid_row
          csv << valid_row.tap { |r| r[2] = '' }
          csv << valid_row_2
        end
        file.write(csv_content)
        file.rewind

        result = DebtImportService.new(file).call

        expect(result.success_count).to eq(2)
        expect(result.error_rows.size).to eq(1)
        expect(result.error_rows.first[:line]).to eq(3)
        expect(result.error_rows.first[:error]).to eq('Dados faltando em alguma coluna')
        expect(Debt.count).to eq(2)

        file.close
        file.unlink
      end
    end
  end
end
