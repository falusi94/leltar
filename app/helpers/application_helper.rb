# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  Link = Struct.new(:translation_key, :href, :accessible?)

  def admin_navigation_links # rubocop:disable Metrics/AbcSize
    @admin_navigation_links ||= [
      Link.new('navigation.users', users_path, policy(User).index?),
      Link.new('navigation.organizations', organizations_path, policy(Organization).index?),
      Link.new('navigation.depreciation_config', depreciation_config_path,
               policy(current_organization).show_depreciation_config?),
      Link.new('navigation.search', search_index_path, policy(current_organization).search_item?),
      Link.new('navigation.status', status_index_path, policy(current_organization).show_status?),
      Link.new('navigation.locations', locations_path, policy(current_organization).index_location?),
      Link.new('navigation.system_attributes', edit_system_attributes_path, policy(SystemAttribute).edit?)
    ]
  end

  def back_label
    create_label('arrow-left', t('form.actions.back'))
  end

  def list_label
    create_label('menu', t('form.actions.list_all'))
  end

  def edit_label
    create_label('pencil', t('form.actions.edit'))
  end

  def new_label
    create_label('plus', t('form.actions.add'))
  end

  def delete_label
    create_label('trash', t('form.actions.delete'))
  end

  def back_button(**options)
    content_tag(:span, data: { controller: 'navigation' }) do
      button_tag(back_label, data: { action: 'navigation#back' }, **options)
    end
  end

  private

  def create_label(icon_name, label_text)
    to_medium_tag = content_tag(:span, '', class: 'uk-hidden@m', 'uk-icon': icon_name)
    from_medium_tag = content_tag(:span, label_text, class: 'uk-visible@m')
    "#{to_medium_tag}#{from_medium_tag}".html_safe # rubocop:disable Rails/OutputSafety
  end
end
