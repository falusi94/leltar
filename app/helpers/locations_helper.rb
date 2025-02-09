# frozen_string_literal: true

module LocationsHelper
  def new_location_button
    return unless policy(current_organization).create_location?

    link_to(new_label, new_location_path, class: 'uk-button uk-button-primary uk-button-small')
  end
end
