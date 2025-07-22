FactoryBot.define do
  factory :debt do
    name { "Fulano" }
    governmentId { "12345678900" }
    debtAmount { "9.99" }
    debtDueDate { "2025-07-22 07:52:29" }
  end
end
