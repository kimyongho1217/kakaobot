require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  include Devise::TestHelpers

  describe "#create" do
    before :each do
      @user = build(:user) #build doesn't save instance to database
    end

    it "creates new user" do
      post :create, email: @user.email, password: @user.password, password_confirmation: @user.password
      expect(User.where(email: @user.email)).to exist
    end

    it "returns correct json" do
      post :create, email: @user.email, password: @user.password, password_confirmation: @user.password
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("success")
      expect(json_body["result"]["message"]).to eq("")
      expect(json_body["user"]["api_token"]).to be_truthy
      expect(json_body["user"]["email"]).to eq(@user.email)
      expect(json_body["user"]["id"]).to be_truthy
    end

    it "returns failed response when user already exists" do
      @user.save
      post :create, email: @user.email, password: @user.password, password_confirmation: @user.password
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("email has already been taken")
    end

    it "returns failed response when password_confirmation is not match" do
      post :create, email: @user.email, password: @user.password, password_confirmation: @user.password + "-"
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("password_confirmation doesn't match Password")
    end
  end

  describe "#update" do
    before :each do
      @user = create(:user)
      @another_user = create(:another_user)
      @random_password = Faker::Internet.password
    end

    it "updates password" do
      put :update, id: @user, password: @random_password, password_confirmation: @random_password, token: @user.api_token
      @user.reload
      expect(@user.valid_password?(@random_password)).to be_truthy
    end

    it "return failed response when password is too short" do
      put :update, id: @user, password: @random_password[0..4], password_confirmation: @random_password[0..4], token: @user.api_token
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("password is too short (minimum is 6 characters)")
    end

    it "return failed response when password_confirmation is not correct" do
      put :update, id: @user, password: @random_password, password_confirmation: @user.password, token: @user.api_token
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("password_confirmation doesn't match Password")
    end

    it "returns failed response when it's invalid user" do
      put :update, id: @another_user, password: @random_password, password_confirmation: @random_password, token: @user.api_token
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("not permitted to update")
    end
  end

  describe "#login" do
    before :each do
      @user = create(:user)
      @user_without_confirm = create(:user_without_confirm)
    end

    it "returns correct json" do
      post :login, email: @user.email, password: @user.password
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("success")
      expect(json_body["result"]["message"]).to eq("")
      expect(json_body["user"]["api_token"]).to be_truthy
      expect(json_body["user"]["email"]).to eq(@user.email)
      expect(json_body["user"]["id"]).to be_truthy
    end

    it "returns failed response when user is not found" do
      post :login, email: Faker::Internet.email, password: @user.password
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("user not found")
    end

    it "returns failed response when password is invalid" do
      post :login, email: @user.email, password: Faker::Internet.password
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("invalid password")
    end

    it "returns failed response when user is not confirmed yet" do
      post :login, email: @user_without_confirm.email, password: @user_without_confirm.password
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("not confirmed yet")
    end
  end

  describe "#reset_password" do
    before :each do
      @user = create(:user)
    end

    it "must update reset_password_token and reset_password_sent_at" do
      expect(@user.reset_password_sent_at).to be_falsy
      expect(@user.reset_password_token).to be_falsy
      post :reset_password, email: @user.email
      @user.reload
      expect(@user.reset_password_sent_at).to be_truthy
      expect(@user.reset_password_token).to be_truthy
    end

    it "returns failed response if there is no user having the email" do
      post :reset_password, email: Faker::Internet.email
      json_body = JSON.parse(response.body)
      expect(json_body["result"]["status"]).to eq("fail")
      expect(json_body["result"]["message"]).to eq("user not found")
    end
  end
end
