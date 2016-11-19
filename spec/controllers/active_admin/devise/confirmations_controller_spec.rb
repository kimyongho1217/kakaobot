require 'rails_helper'

RSpec.describe ActiveAdmin::Devise::ConfirmationsController, type: :controller do
  include Devise::TestHelpers

  describe "#show" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "redirect to root after confirmation" do
      @user = create(:user_without_confirm)
      get :show, confirmation_token: @user.confirmation_token
      expect(response).to redirect_to(:root)
    end
  end

end
