# app/services/debt_payment_service.rb
class DebtPaymentService
  Result = Struct.new(:success, :payload, :error, keyword_init: true)

  def initialize(debt_id:, paid_amount:, paid_at:, paid_by:)
    @debt_id     = debt_id
    @paid_amount = BigDecimal(paid_amount.to_s)
    @paid_at     = paid_at
    @paid_by     = paid_by
  end

  def call
    debt = Debt.find_by(debt_id: @debt_id)
    return Result.new(success: false, error: "Registro não encontrado") unless debt

    apply_payment(debt)

    if debt.save
      Result.new(
        success: true,
        payload: {
          debtId:      debt.debt_id,
          remaining:   debt.debt_amount.to_f,
          paid_status: debt.paid_status,
          paid_at:     debt.paid_at,
          paid_by:     debt.paid_by
        }
      )
    else
      Result.new(success: false, error: debt.errors.full_messages.join(", "))
    end
  end

  private

  def apply_payment(debt)
    debt.debt_amount -= @paid_amount
    if debt.debt_amount <= 0
      debt.debt_amount = 0
      debt.paid_status = true
    end

    # atualizado sempre, mesmo parcial
    debt.paid_at = parse_datetime(@paid_at)
    debt.paid_by = @paid_by
  end

  def parse_datetime(dt_string)
    DateTime.parse(dt_string)
  rescue ArgumentError, TypeError
    nil
  end
end
