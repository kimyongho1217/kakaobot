require 'rails_helper'

RSpec.describe FoodUnit, type: :model do
  it_behaves_like "a wit client" do
    let(:wit_client_class) { create(:food_unit) }
  end
end
