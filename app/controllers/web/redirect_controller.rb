# frozen_string_literal: true

module Web
  class RedirectController < BaseController
    skip_after_action :verify_authorized

    def show
      redirect_url = RedirectUrl.generate(current_user)

      if redirect_url
        redirect_to redirect_url
      else
        unauthorized_page
      end
    end
  end
end
