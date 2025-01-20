# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id                      :bigint           not null, primary key
#  currency_code           :string           not null
#  fiscal_period_starts_at :date
#  fiscal_period_unit      :string
#  name                    :string           not null
#  slug                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_organizations_on_slug  (slug)
#

class Organization < ApplicationRecord
  validates :name, :slug, :currency_code, presence: true

  has_many :organization_users, dependent: :nullify
  has_many :users, through: :organization_users
  has_many :departments, dependent: :nullify
  has_many :items, through: :departments

  def to_param = slug
end
