# frozen_string_literal: true

module Web
  module DefaultOrganizationUrlOptions
    extend ActiveSupport::Concern

    def default_url_options
      { organization_slug: params[:organization_slug], **super }
    end
  end
end
