class Item < ApplicationRecord
  include TranslateEnum

  searchkick word_middle: %i[name description status specific_name serial
                             location at_who condition inventory_number]
  scope :search_import, -> { includes(:group) }

  enum status: %i[ok waiting_for_repair waiting_for_scrapping scrapped
                  not_found at_group_member other], _prefix: :status
  enum condition: %i[ok used end_of_life not_working], _prefix: :condition
  enum organization: %i[ska svie other], _prefix: :organization
  enum accountancy_state: %i[new invoice_turned in_register], _prefix: :accountancy_state

  translate_enum :status
  translate_enum :condition
  translate_enum :accountancy_state

  has_paper_trail
  belongs_to :group
  has_many :photos

  validates :name, length: { minimum: 2, too_short: 'Túl rövid név' }
  validates :description, length: { maximum: 300, too_long: 'Túl hosszú leírás' }
  validates :group, presence: true, allow_nil: false
  validate :purchase_date_cannot_be_in_future

  def search_data
    { name: name, description: description, status: status, serial: serial,
      specific_name: specific_name, location: location, at_who: at_who,
      condition: condition, inventory_number: inventory_number,
      group_name: group.name, group_id: group_id }
  end

  def initialize(params = {})
    # save picture to create new Photo after initializing with super
    pic = params[:picture]
    params.delete :picture
    super(params)
    self.photos = [Photo.new(file: pic)] if pic
  end

  def purchase_date_cannot_be_in_future
    return unless purchase_date.present? && purchase_date > Date.today

    errors.add(:purchase_date, 'Jövőbeni beszerzési dátum')
  end

  def picture_path(ix = 0)
    "/items/#{id}/photos/#{ix}"
  end
end
