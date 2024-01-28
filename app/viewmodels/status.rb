# frozen_string_literal: true

class Status
  attr_reader :session_start

  def initialize
    @session_start = SystemAttribute.new_session_start
  end

  def all_item_count
    Item.count
  end

  def existing_item_count
    Item.existing.where.not(last_check: nil).count
  end

  def finished_item_count
    Item.existing.where('last_check > ?', session_start).count
  end

  def at_member_item_count
    Item.existing.status_at_group_member.count
  end
end
