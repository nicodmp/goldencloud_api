class DebtsController < ApplicationController
  before_action :set_debt, only: %i[ show ]
  protect_from_forgery unless: -> { request.format.json? }

  # GET /debts or /debts.json
  def index
    debts =
      if params[:debt_id].present?
        Debt.where(debt_id: params[:debt_id])
      else
        Debt.all
      end

    if debts.empty?
      render json: { error: "Nenhum registro encontrado" }, status: :not_found
    else
      render json: debts, status: :ok
    end
  end

  # GET /debts/1 or /debts/1.json
  def show
    render json: @debt
  end

  # POST /debts/import
  def import
    unless params[:file].present?
      return render json: { error: "Por favor, envie um arquivo CSV." }, status: :bad_request
    end

    service = DebtImportService.new(params[:file])
    result = service.call

    payload = {
      imported_count: result.success_count,
      errors:         result.error_rows
    }

    status_code = result.error_rows.empty? ? :ok : :multi_status
    render json: payload, status: status_code
  end

  # POST /debts/pay
  def pay
    result = DebtPaymentService.new(
      debt_id:     pay_params[:debtId],
      paid_amount: pay_params[:paidAmount],
      paid_at:     pay_params[:paidAt],
      paid_by:     pay_params[:paidBy]
    ).call

    if result.success
      render json: result.payload, status: :ok
    else
      status = result.error == "Registro não encontrado" ? :not_found : :unprocessable_entity
      render json: { error: result.error }, status: status
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debt
      @debt = Debt.find_by(id: params[:id])
      return if @debt

      render json: { error: "Registro não encontrado por id" }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def debt_params
      params.fetch(:debt, {})
    end

    def pay_params
      params.permit(:debtId, :paidAt, :paidAmount, :paidBy)
    end
end
