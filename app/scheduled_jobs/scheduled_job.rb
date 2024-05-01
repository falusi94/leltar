# frozen_string_literal: true

class ScheduledJob
  def self.perform
    new.perform
  end
end
