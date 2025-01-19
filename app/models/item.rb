# frozen_string_literal: true

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
#  department_id     :integer
#  parent_id         :integer
#
# Indexes
#
#  index_items_on_accountancy_state  (accountancy_state)
#  index_items_on_condition          (condition)
#  index_items_on_department_id      (department_id)
#  index_items_on_status             (status)
#

class Item < ApplicationRecord
  include TranslateEnum
  include Exportable
  extend SearchQuery::Mixin

  enum status: {
    ok:                    'ok',
    waiting_for_repair:    'waiting_for_repair',
    waiting_for_scrapping: 'waiting_for_scrapping',
    scrapped:              'scrapped',
    not_found:             'not_found',
    at_member:             'at_member',
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
  belongs_to :department
  has_many_attached :photos
  has_one_attached :invoice
  belongs_to :parent, class_name: 'Item', optional: true
  has_many :children, class_name: 'Item', foreign_key: :parent_id, inverse_of: :parent, dependent: :nullify
  has_one :organization, through: :department

  has_one :depreciation_details, dependent: :destroy

  validates :name, length: { minimum: 2, too_short: 'Túl rövid név' }
  validates :description, length: { maximum: 300, too_long: 'Túl hosszú leírás' }
  validate :children_from_the_same_department, :parent_from_the_same_department, :purchase_date_not_in_the_future,
           :has_no_grandparent, :has_no_grandchild

  after_create :init_depreciation, if: -> { SystemAttribute.automatic_depreciation }

  def initialize(params = {})
    # save picture to create new Photo after initializing with super
    photo = params&.delete(:photo)
    super(params)
    photos.attach(photo) if photo
  end

  scope :not_a_child, -> { where(parent_id: nil) }
  scope :existing, lambda {
    where('items.status in (?) or items.status is null', %i[ok waiting_for_repair at_member other])
  }

  def child?
    parent.present?
  end

  def parent?
    children.any?
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[accountancy_state at_who comment condition description entry_date entry_price department_id inventory_number
       last_check location name purchase_date serial specific_name status warranty]
  end

  private

  def children_from_the_same_department
    return unless children.where.not(department_id: department_id).exists?

    errors.add(:children, 'has to be in the same department')
  end

  def parent_from_the_same_department
    return if parent.blank? || parent.department_id == department_id

    errors.add(:parent, 'has to be in the same department')
  end

  def purchase_date_not_in_the_future
    return if purchase_date.blank? || purchase_date <= Time.zone.today

    errors.add(:purchase_date, 'cannot be in the future')
  end

  def has_no_grandparent # rubocop:disable Naming/PredicateName
    return if parent.blank? || parent.parent.blank?

    errors.add(:parent, 'has parent, multi level relation is not allowed')
  end

  def has_no_grandchild # rubocop:disable Naming/PredicateName
    children_ids = if persisted?
                     children.pluck(:id)
                   else
                     children.map(&:id)
                   end
    return if children.none? || !self.class.exists?(parent_id: children_ids)

    errors.add(:children, 'have child, multi level relation is not allowed')
  end

  def init_depreciation
    params = {
      salvage_value: SystemAttribute.automatic_depreciation_salvage_value,
      useful_life:   SystemAttribute.automatic_depreciation_useful_life
    }

    Depreciation.init(self, params: params)
  end
end
