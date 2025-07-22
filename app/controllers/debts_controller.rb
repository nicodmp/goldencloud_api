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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debt
      @debt = Debt.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def debt_params
      params.fetch(:debt, {})
    end
end
