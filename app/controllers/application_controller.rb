# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  protect_from_forgery with: :exception
end
