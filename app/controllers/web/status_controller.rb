# frozen_string_literal: true

module Web
  class StatusController < BaseController
    before_action -> { authorize(Status) }

    def index
      @status = Status.new
    end
  end
end
