class Status
  attr_reader :session_start

  def initialize
    @session_start = SystemAttribute.new_session_start
  end

  def all_item_count
    Item.all.count
  end

  def existing_item_count
    Item.select { |i| i.last_check && i.exists? }.count
  end

  def finished_item_count
    Item.select { |i| i.exists? && i.last_check && i.last_check > @session_start }.count
  end

  def at_member_item_count
    Item.select { |i| i.status_at_group_member? && i.exists? }.count
  end
end
