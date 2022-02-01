class StatusController < ApplicationController
  before_action -> { authorize(Status) }

  def index
    @status = Status.new
  end
end
