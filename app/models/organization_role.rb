# frozen_string_literal: true

ORGANIZATION_ROLE_ACCESSES =
  %i[show_organization update_organization destroy_organization create_department show_department update_department
     destroy_department show_item create_item update_item destroy_item].freeze

OrganizationRole = Struct.new(*([:name] + ORGANIZATION_ROLE_ACCESSES), keyword_init: true) do
  ORGANIZATION_ROLE_ACCESSES.each do |access|
    alias_method :"#{access}?", access
  end

  def self.all
    @all ||= Rails.configuration.x.roles.organization_roles.map { |role| new(role) }
  end

  def self.roles_with_access(access)
    all.select { |role| role.public_send(access) }.map(&:name)
  end

  def self.find_by_name(name)
    all.find { |role| role.name == name }
  end
end
