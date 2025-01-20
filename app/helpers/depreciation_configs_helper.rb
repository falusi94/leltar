# frozen_string_literal: true

module DepreciationConfigsHelper
  def edit_depreciation_config_button
    return unless policy(current_organization).update_depreciation_config?

    link_to(edit_label, edit_depreciation_config_path, class: 'uk-button uk-button-primary uk-button-small')
  end
end
