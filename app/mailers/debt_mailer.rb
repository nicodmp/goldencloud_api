class DebtMailer < ApplicationMailer
    default subject: "Aviso de dívida"

    def reminder(debt)
        @debt = debt
        mail(to: debt.email)
    end
end
