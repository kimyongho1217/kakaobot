module Api
  class UsersController < Api::ApplicationController
    skip_before_filter :auth_token, only: [:create, :login, :reset_password]
  
    def create
      @user = User.create(user_params)
      @user.save!
      render json: @user
    end
  
    def update
      user_id = params[:id].respond_to?(:to_i) ? params[:id].to_i : params[:id]
      raise ApplicationError.new("not permitted to update") if current_user.id != user_id and not current_user.admin?
      res = @user.update_attributes(user_params)
      unless res
        messages = @user.errors.messages.map do |k, v|
          "#{k.to_s} #{v[0]}"
        end
        raise ApplicationError.new(messages.join(","))
      end
      render json: @user
    end
  
    def login
      @user = User.find_for_authentication(email: params[:email])
      raise ApplicationError.new("user not found") if @user.nil?
      raise ApplicationError.new("invalid password") unless @user.valid_password?(params[:password])
      raise ApplicationError.new("not confirmed yet") if @user.confirmed_at.nil?
      sign_in @user, store: false
      render json: @user
    end

    def reset_password
      @user = User.find_by(email: params[:email])
      raise ApplicationError.new("user not found") if @user.nil?
      @user.send_reset_password_instructions
      render json: @user
    end
  
    private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
  end
end
