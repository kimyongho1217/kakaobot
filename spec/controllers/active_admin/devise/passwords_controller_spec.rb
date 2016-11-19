require 'rails_helper'

RSpec.describe ActiveAdmin::Devise::PasswordsController, type: :controller do
  include Devise::TestHelpers

  describe "#edit" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end
    
    it "redirect to root after resetting password" do
      @user = create(:user)
      token = @user.send_reset_password_instructions
      @random_password = Faker::Internet.password
      put :update, user: { password: @random_password, password_confirmation: @random_password, reset_password_token: token }
      @user.reload
      expect(@user.valid_password?(@random_password)).to be_truthy
      expect(response).to redirect_to(:root)
    end
  end
end
