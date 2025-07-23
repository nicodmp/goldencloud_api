require "rails_helper"

RSpec.describe DebtMailer, type: :mailer do
  describe "remind" do
    let(:debt) { create(:debt, email: "teste@exemplo.com", name: "Zina") }
    let(:mail) { DebtMailer.reminder(debt) }

    it "renders the headers" do
      expect(mail.subject). to eq("Aviso de dívida")
      expect(mail.to).to eq([ debt.email ])
    end

    it "renders the body with debt details" do
      html = mail.body.encoded

      expect(html).to include("Olá,")
      expect(html).to include("Zina")
      expect(html).to include(debt.debt_amount.to_s)
      expect(html).to include(debt.debt_due_date.strftime("%d/%m/%Y"))
    end
  end
end
