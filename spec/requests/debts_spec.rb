require "rails_helper"

RSpec.describe "Debts API", type: :request do
  describe "GET /debts" do
    let!(:debt1) { create(:debt, email: "teste1@exemplo.com", name: "Fulano", debt_id: "debt-1-1234") }
    let!(:debt2) { create(:debt, email: "teste2@exemplo.com", name: "Siclano", debt_id: "debt-2-1234") }
    let!(:debt3) { create(:debt, email: "teste3@exemplo.com", name: "Beltrano", debt_id: "debt-3-1234") }

    it "retorna todos os débitos" do
      headers = { "ACCEPT" => "application/json" }
      get "/debts", headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.size).to eq(3)
    end
  end

  describe "GET /debts/:id" do
    let!(:debt) { create(:debt) }

    it "retorna o débito especificado" do
      get debt_path(debt), as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["id"]).to eq(debt.id)
      expect(body["debt_id"]).to eq(debt.debt_id)
      expect(body["email"]).to eq(debt.email)
    end

    it "retorna 404 se não existir" do
      get debt_path(id: "999999"), as: :json

      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body).to eq("error" => "Registro não encontrado por id")
    end
  end

  describe "POST /debts/pay" do
    let!(:debt) { create(:debt, debt_amount: BigDecimal("100.0"), debt_id: "pay-1") }

    context "pagamento parcial" do
      it "diminui o valor e mantém paid_status false" do
        payload = {
          debtId:     debt.debt_id,
          paidAt:     "2025-07-23 12:00:00",
          paidAmount: 30.0,
          paidBy:     "Alice"
        }
        post pay_debts_path, params: payload.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["remaining"]).to eq(70.0)
        expect(json["paid_status"]).to be_falsey
        expect(json["paid_by"]).to eq("Alice")
      end
    end

    context "pagamento total" do
      it "zera valor e marca paid_status true" do
        payload = {
          debtId:     debt.debt_id,
          paidAt:     "2025-07-23 13:00:00",
          paidAmount: 100.0,
          paidBy:     "Bob"
        }
        post pay_debts_path, params: payload.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["remaining"]).to eq(0.0)
        expect(json["paid_status"]).to be_truthy
        expect(json["paid_at"]).to start_with("2025-07-23T13:00") # ISO format
      end
    end

    context "dívida inexistente" do
      it "retorna 404" do
        payload = {
          debtId:     "nao-existe",
          paidAt:     "2025-07-23 14:00:00",
          paidAmount: 50.0,
          paidBy:     "User"
        }
        post pay_debts_path, params: payload.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq("error" => "Registro não encontrado")
      end
    end
  end
end
