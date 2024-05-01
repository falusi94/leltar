# frozen_string_literal: true

module Scopeable
  # https://thoughtbot.com/blog/a-case-for-query-objects-in-rails
  def scope(name, body)
    define_method name do |*args, **kwargs|
      relation = instance_exec(*args, **kwargs, &body)
      relation || self
    end
  end
end
