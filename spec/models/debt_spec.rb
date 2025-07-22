require 'rails_helper'

RSpec.describe Debt, type: :model do
  describe 'validations' do
    subject { create (:debt) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:governmentId) }
    it { should validate_presence_of(:debtAmount) }
    it { should validate_presence_of(:debtDueDate) }

    it { should validate_numericality_of(:debtAmount).is_greater_than_or_equal_to(0) }
  end
end
