# frozen_string_literal: true

module Authorization
  Scope = Struct.new(:user, :organization, keyword_init: true)
end
