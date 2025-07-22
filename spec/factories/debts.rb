FactoryBot.define do
  factory :debt do
    name { "Fulano" }
    government_id { "12345678900" }
    email { "fulano@email.com" }
    debt_amount { "9.99" }
    debt_due_date { "2025-07-22 07:52:29" }
    debt_id { "debt-12345" }
  end
end
