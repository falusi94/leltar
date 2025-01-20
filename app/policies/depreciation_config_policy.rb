# frozen_string_literal: true

class DepreciationConfigPolicy < ApplicationPolicy
  def show?
    OrganizationPolicy.new(auth_scope, organization).show_depreciation_config?
  end

  def update?
    OrganizationPolicy.new(auth_scope, organization).update_depreciation_config?
  end

  def permitted_attributes
    %i[depreciation_method depreciation_frequency_value depreciation_frequency_unit automatic_depreciation
       automatic_depreciation_useful_life automatic_depreciation_salvage_value]
  end
end
