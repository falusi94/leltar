# frozen_string_literal: true

# == Schema Information
#
# Table name: system_attributes
#
#  id    :integer          not null, primary key
#  name  :string
#  value :string
#

class SystemAttribute < ApplicationRecord
  def self.new_session_start
    value = find_by!(name: 'new_session_start').value
    Date.parse(value)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
