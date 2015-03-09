# encoding: utf-8
class AuthenticationsController < Devise::OmniauthCallbacksController #ApplicationController
  layout "application"
  
  def facebook
    #raise request.env["omniauth.auth"].to_yaml
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      authentication.user.remember_me = true
      flash[:notice] = "Login efetuado com sucesso!"
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Sua conta está agora ligada com o Facebook!"
      redirect_to authentications_url
    else
      existing_user = User.find_by_email(omniauth['info']['email'])
      user = existing_user ? existing_user : User.new
      user.apply_omniauth(omniauth)
      user.set_referrer(cookies['referrer-id']) if cookies['referrer-id']
      #if user.save
      if user.save(:validate => false)
        user.remember_me = true
        user.set_default_user_merits
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        flash[:notice] = "Complete as informações abaixo para vincular sua conta ao Facebook"
        %w[work education hometown location].each do |key|
          omniauth['extra']['raw_info'].delete(key)
        end
        session["devise.omniauth"] = omniauth
        redirect_to new_user_registration_url
      end
    end
  end

  def failure
    flash[:alert] = "Para se logar via Facebook é necessário que você autorize a nossa App."
    redirect_to root_url
    #super
  end
  
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
