require 'rails_helper'

RSpec.describe Debt, type: :model do
  describe 'validations' do
    subject { create (:debt) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:government_id) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:debt_amount) }
    it { should validate_presence_of(:debt_due_date) }
    it { should validate_presence_of(:debt_id) }

    it { should validate_uniqueness_of(:debt_id) }

    it { should validate_numericality_of(:debt_amount).is_greater_than_or_equal_to(0) }
  end
end
