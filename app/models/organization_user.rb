# frozen_string_literal: true

# == Schema Information
#
# Table name: organization_users
#
#  id              :bigint           not null, primary key
#  role_name       :string           default("user"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_organization_users_on_organization_id  (organization_id)
#  index_organization_users_on_role_name        (role_name)
#  index_organization_users_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#

class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  scope :with_access, ->(access) { where(role_name: OrganizationRole.roles_with_access(access)) }

  validates :role_name, inclusion: { in: OrganizationRole.all.map(&:name) }

  delegate(*ORGANIZATION_ROLE_ACCESSES, to: :role)

  private

  def role
    @role ||= OrganizationRole.find_by_name(role_name) # rubocop:disable Rails/DynamicFindBy
  end
end
