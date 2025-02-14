# frozen_string_literal: true

module ApiHelpers
  def api_headers(further_headers = {})
    {
      Accept: 'application/vnd.leltar.api-v1+json',
      **further_headers
    }
  end

  def auth_headers(user)
    jwt = user.generate_jwt(user.sessions.first.try(:client_id))

    api_headers('access-token': jwt)
  end

  def json
    JSON.parse(body, symbolize_names: true)
  end

  def api_user_hash(user)
    { id: user.id, email: user.email, name: user.name }
  end

  def api_organization_hash(organization)
    {
      id:                      organization.id,
      name:                    organization.name,
      fiscal_period_starts_at: (I18n.l(organization.fiscal_period_starts_at) if organization.fiscal_period_starts_at),
      fiscal_period_unit:      organization.fiscal_period_unit
    }
  end

  def api_depreciation_config_hash(depreciation_config)
    {
      depreciation_method:                  depreciation_config.depreciation_method,
      depreciation_frequency_value:         depreciation_config.depreciation_frequency_value,
      depreciation_frequency_unit:          depreciation_config.depreciation_frequency_unit,
      automatic_depreciation:               depreciation_config.automatic_depreciation,
      automatic_depreciation_useful_life:   depreciation_config.automatic_depreciation_useful_life,
      automatic_depreciation_salvage_value: depreciation_config.automatic_depreciation_salvage_value
    }
  end

  def api_location_hash(location)
    { id: location.id, name: location.name }
  end

  def api_department_hash(department)
    { id: department.id, name: department.name }
  end

  def api_item_hash(item)
    attributes = %i[id accountancy_state condition description entry_price inventory_number location_id
                    name count serial_number status department_id parent_id]

    item.slice(*attributes).merge(
      entry_date:       item.entry_date ? I18n.l(item.entry_date) : nil,
      last_check:       item.last_check ? I18n.l(item.last_check) : nil,
      acquisition_date: item.acquisition_date ? I18n.l(item.acquisition_date) : nil,
      warranty:         item.warranty_end_at ? I18n.l(item.warranty_end_at) : nil
    ).symbolize_keys
  end

  def api_department_user_hash(department_user)
    {
      id:            department_user.id,
      write:         department_user.write,
      department_id: department_user.department_id,
      user_id:       department_user.user_id
    }
  end

  def api_system_attribute_hash(system_attribute)
    { name: system_attribute.name, value: system_attribute.value }
  end

  def api_attachment_hash(attachment)
    {
      record_type: attachment.record_type,
      record_id:   attachment.record_id,
      url:         include('http://www.example.com/rails/active_storage/blobs/redirect/')
    }
  end

  def api_array_hash(array)
    method_name = :"api_#{array.first.class.to_s.demodulize.underscore}_hash"
    array.map { |entry| public_send(method_name, entry) }
  end
  alias api_active_record_relation_hash api_array_hash
end

RSpec.configure do |config|
  config.include ApiHelpers, :api_request

  config.define_derived_metadata(file_path: %r{/spec/requests/api/}) do |metadata|
    metadata[:api_request] = true
  end
end
