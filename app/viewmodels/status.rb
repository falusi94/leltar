# frozen_string_literal: true

class Status
  attr_reader :session_start, :organization

  def initialize(organization)
    @organization  = organization
    @session_start = SystemAttribute.new_session_start
  end

  def all_item_count
    organization.items.count
  end

  def existing_item_count
    organization.items.existing.where.not(last_check: nil).count
  end

  def finished_item_count
    organization.items.existing.where('last_check > ?', session_start).count
  end
end
