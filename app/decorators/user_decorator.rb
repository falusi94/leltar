# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  decorates_finders
  decorates_association :department_users
end
