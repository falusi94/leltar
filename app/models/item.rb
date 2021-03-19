# == Schema Information
#
# Table name: items
#
#  id                :integer          not null, primary key
#  accountancy_state :string
#  at_who            :string
#  comment           :string
#  condition         :string
#  description       :string
#  entry_date        :date
#  entry_price       :integer
#  inventory_number  :string
#  last_check        :date
#  location          :string
#  name              :string
#  number            :integer          default(1)
#  organization      :string
#  purchase_date     :date
#  serial            :string
#  specific_name     :string
#  status            :string
#  warranty          :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  group_id          :integer
#  parent_id         :integer
#
# Indexes
#
#  index_items_on_accountancy_state  (accountancy_state)
#  index_items_on_condition          (condition)
#  index_items_on_group_id           (group_id)
#  index_items_on_status             (status)
#

class Item < ApplicationRecord
  include TranslateEnum
  include Exportable

  searchkick word_middle: %i[name description status specific_name serial
                             location at_who condition inventory_number]
  scope :search_import, -> { includes(:group) }

  enum status: {
    ok:                    'ok',
    waiting_for_repair:    'waiting_for_repair',
    waiting_for_scrapping: 'waiting_for_scrapping',
    scrapped:              'scrapped',
    not_found:             'not_found',
    at_group_member:       'at_group_member',
    other:                 'other'
  }, _prefix: :status
  enum condition: {
    ok:          'ok',
    used:        'used',
    end_of_life: 'end_of_life',
    not_working: 'not_working'
  }, _prefix: :condition
  enum accountancy_state: {
    new:            'new',
    invoice_turned: 'invoice_turned',
    in_register:    'in_register'
  }, _prefix: :accountancy_state

  translate_enum :status
  translate_enum :condition
  translate_enum :accountancy_state

  has_paper_trail
  belongs_to :group
  has_many_attached :photos
  has_one_attached :invoice
  belongs_to :parent, class_name: 'Item', foreign_key: :parent_id, optional: true
  has_many :children, class_name: 'Item', foreign_key: :parent_id, inverse_of: :parent

  validates :name, length: { minimum: 2, too_short: 'Túl rövid név' }
  validates :description, length: { maximum: 300, too_long: 'Túl hosszú leírás' }
  validates :group, presence: true, allow_nil: false
  validate :purchase_date_cannot_be_in_future
  validate :childen_parent_from_the_same_group
  validate :deny_family_higher_than_two

  def search_data
    { name: name, description: description, status: status, serial: serial,
      specific_name: specific_name, location: location, at_who: at_who,
      condition: condition, inventory_number: inventory_number,
      group_name: group.name, group_id: group_id }
  end

  def initialize(params = {})
    # save picture to create new Photo after initializing with super
    photo = params[:photo] if params
    params.delete :photo if photo
    super(params)
    photos.attach(photo) if photo
  end

  def purchase_date_cannot_be_in_future
    return unless purchase_date.present? && purchase_date > Date.today

    errors.add(:purchase_date, 'Jövőbeni beszerzési dátum')
  end

  def childen_parent_from_the_same_group
    errors.add(:parent, 'Eltérő körök!') if child? && parent.group != group
    return unless parent?

    children.each { |child| errors.add(:child, 'Eltérő körök!') if child.group != group }
  end

  def deny_family_higher_than_two
    return unless child? && parent?

    errors.add(:parent, 'Csak két szintű szülő gyerek viszony engedélyezett!')
  end

  def picture_path(ix = 0)
    "/items/#{id}/photos/#{ix}"
  end

  def exists?
    status.in?(%i[ok waiting_for_repair at_group_member other]) || status.nil?
  end

  def child?
    !parent.nil?
  end

  def parent?
    !children.count.zero?
  end
end
