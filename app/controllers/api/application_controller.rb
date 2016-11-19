module Api
  class ApplicationController < ActionController::Base

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session

    around_filter :handle_errors
    before_filter :auth_token
    before_action :set_resource, only: [:show, :update]
    
    #shared exceptions handler
    def handle_errors
      begin
        yield
      rescue Api::ApplicationError => e
        @message = e.message
        render_fail
      rescue ActiveRecord::RecordInvalid => e
        @message = e.record.errors.messages.map {|k, v| "#{k} #{v[0]}" }.join(",")
        render_fail
      rescue ActiveRecord::RecordNotFound => e
        @message = "record not found:[#{e}]"
        render_fail
      rescue => e
        @message = "unexpected exception: contact system admin"
        Rails.logger.error { "[#{e.message}]\n#{e.backtrace.join("\n")}" }
        render_fail
      end
    end
  
    def auth_token
      @user = User.find_by(api_token: params[:token])

      if @user && Devise.secure_compare(@user.api_token, params[:token])
        # User can access
        sign_in @user, store: false
      else
      	raise Api::ApplicationError.new("authentication failed!")
      end
    end
  
    def set_resource
      class_name = controller_name.classify
      object = class_name.constantize.find(params[:id])
      raise Api::ApplicationError.new("resource not found:#{class_name}") if object.nil?
      instance_variable_set("@#{class_name.downcase}", object)
    end
  
    def render_fail
      render json: {
        result: {
          status: "fail",
          message: @message
        }
      }
    end

    def per_page
      params[:per_page] || 25
    end

    def page
      params[:page] || 1
    end
  end
end
