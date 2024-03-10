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

  def api_group_hash(group)
    { id: group.id, name: group.name }
  end

  def api_item_hash(item)
    attributes = %i[id accountancy_state at_who comment condition description entry_price inventory_number location name
                    number organization serial specific_name status group_id parent_id]

    item.slice(*attributes).merge(
      entry_date:    item.entry_date ? I18n.l(item.entry_date) : nil,
      last_check:    item.last_check ? I18n.l(item.last_check) : nil,
      purchase_date: item.purchase_date ? I18n.l(item.purchase_date) : nil,
      warranty:      item.warranty ? I18n.l(item.warranty) : nil
    ).symbolize_keys
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
