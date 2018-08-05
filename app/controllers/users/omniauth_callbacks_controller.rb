class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :steam

  def google_oauth2
    signin_from(:google_oauth2, "Google")
  end

  def steam
    signin_from(:steam)
  end

  private

  def signin_from provider, provider_label=nil
    provider_label ||= provider.to_s.capitalize
    @user = User.from_omniauth(request.env["omniauth.auth"])
Rails.logger.info "==== @user: #{@user.inspect} ===="
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_label) if is_navigational_format?
    else
      user_info = request.env["omniauth.auth"]
      user_info = user_info.except(:extra) if provider == :steam
      session["devise.#{provider.to_s}_data"] = user_info
      redirect_to new_user_registration_url
    end
  end
end
