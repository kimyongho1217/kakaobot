require 'rails_helper'

RSpec.describe Food, type: :model do
  it_behaves_like "a wit client" do
    let(:wit_client_class) { create(:food) }
  end
end
