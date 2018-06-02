require 'csv'
class Item < ApplicationRecord
  searchkick
  scope :search_import, -> { includes(:group) }

  # This is deprecated, but for info, keep the original values
  # VALID_STATUS = ['OK', 'Selejtezésre vár', 'Selejtezve', 'Utána kell járni', 'Elveszett']
  enum state: [ :ok, :waiting_for_repair, :need_as_part, :waiting_for_scrapping,
                :scrapped, :not_found, :at_group_member, :lost ]
  enum organization: [:ska, :svie]

  has_paper_trail
  belongs_to :group
  has_many :photos
  validates :name, length: {minimum: 2, too_short: 'Túl rövid név'}
  validates :description, length: {maximum: 300, too_long: 'Túl hosszú leírás'}
  validates :group, presence: true, allow_nil: false

  def search_data
    {
      name: name,
      description: description,
      state: state,
      old_number: old_number,
      group_name: group.name,
      group_id: group_id
    }
  end

  def initialize(params = {})
    #save picture to create new Photo after initializing with super
    pic = params[:picture]
    params.delete :picture
    super(params)
    if pic
      self.photos = [Photo.new(file: pic)]
    end
  end

  def to_a
    [self.id, self.name, self.description, self.group.name, self.purchase_date,
     self.entry_date, self.last_check, self.state, self.old_number]
  end

  def validate_purchase_date
    if purchase_date.present? && purchase_date > Date.today
      errors.add(:purchase_date, 'Jövőbeni beszerzési dátum')
    end
  end

  def picture_path(ix = 0)
    "/items/#{self.id}/photos/#{ix}"
  end

end
