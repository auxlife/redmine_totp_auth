require_dependency 'application_controller'

module TotpAuth
  module ApplicationControllerPatch
    extend ActiveSupport::Concern
    unloadable

    included do
      unloadable

      before_action :check_totp_auth

      def check_totp_auth
        return true if controller_name == 'account'
        return true if session[:pwd].present?

        if session[:totp]
          if User.current.enabled_totp_auth?
            redirect_to controller: 'totp_auths', action: 'login'
          else
            session.delete(:totp)
          end
        end
      end

    end

  end
end

TotpAuth::ApplicationControllerPatch.tap do |mod|
  ApplicationController.send :include, mod unless ApplicationController.include?(mod)
end
