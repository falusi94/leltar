# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  decorates_finders
  delegate_all
  decorates_association :rights
end
