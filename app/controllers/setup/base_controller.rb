# frozen_string_literal: true

module Setup
  class BaseController < ApplicationController
    before_action :verify_no_organization

    private

    def verify_no_organization
      redirect_to :root if Organization.any?
    end
  end
end
