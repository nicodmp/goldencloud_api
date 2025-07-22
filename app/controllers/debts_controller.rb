class DebtsController < ApplicationController
  before_action :set_debt, only: %i[ show destroy ]

  # GET /debts or /debts.json
  def index
    @debts = Debt.all
  end

  # GET /debts/1 or /debts/1.json
  def show
    render json: @debt
  end

  # DELETE /debts/1 or /debts/1.json
  def destroy
    @debt.destroy
    head :no_content
  end

  # POST /debts/pay
  def pay
    debt = Debt.find_by(debtId: pay_params[:debtId])

      return render json: { error: 'Registro não encontrado' }, status: :not_found if debt.nil?

      paid_amount = BigDecimal(pay_params[:paidAmount].to_s)
      paid_at = DateTime.parse(pay_params[:paidAt]) rescue nil
      paid_by = pay_params[:paidBy]

      debt.debtAmount -= paid_amount

      if debt.debt_amount <= 0
        debt.paid_status = true
        debt.debt_amount = 0
      end

      debt.paid_at = paid_at
      debt.paid_by = paid_by

      if debt.save
        render json: {
          debtId: debt.debtId
          remaining: debt.debtAmount.to_f,
          paid_status: debt.paid_status,
          paid_at: debt.paid_at,
          paid_by: debt.paid_by
        }, status: :ok
      else
        render json: { error: debt.errors.full_messages }, status: :unprocessable_entity
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debt
      @debt = Debt.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def debt_params
      params.fetch(:debt, {})
    end

    def pay_params
      params.permit(:debtId, :paidAt, :paidAmount, :paidBy)
    end
end
