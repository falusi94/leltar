# frozen_string_literal: true

module Web
  class StatusController < BaseController
    before_action -> { authorize(current_organization, :show_status?) }

    def index
      @status = Status.new(current_organization)
    end
  end
end
