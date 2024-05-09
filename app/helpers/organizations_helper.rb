# frozen_string_literal: true

module OrganizationsHelper
  def new_organization_button
    return unless policy(Organization).new?

    link_to(new_label, new_organization_path, class: 'uk-button uk-button-primary uk-button-small')
  end
end
