class StatusController < ApplicationController
  before_action :require_admin

  def index
    @status = Status.new
  end
end
