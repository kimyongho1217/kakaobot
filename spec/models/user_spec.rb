require 'rails_helper'

RSpec.describe User, type: :model do

  before :each do
    @user = create(:user)
  end

  it "has valid factory" do
    expect(@user).to be_valid
  end

  it "generates api_token when it's created" do
    expect(@user.api_token).to be_truthy
  end

  it "is invalid if email already exists" do
    expect { create(:dup_user) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "failed when password is shorter than 6 charaters" do
    @user.password = "1234"
    @user.password_confirmation = "1234"
    expect(@user.save).to be_falsy
    expect(@user.errors.messages[:password][0]).to eq("is too short (minimum is 6 characters)")
  end

  it "can be found by case insensitive email address" do
    capital_email = @user.email.upcase
    expect(User.find_for_authentication(email: capital_email)).to eq(@user)
  end

end
