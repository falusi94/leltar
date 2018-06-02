require 'csv'
class Item < ApplicationRecord
  searchkick
  scope :search_import, -> { includes(:group) }

  VALID_STATUS = ['OK', 'Selejtezésre vár', 'Selejtezve', 'Utána kell járni', 'Elveszett']
  enum state: [ :ok, :waiting_for_repair, :need_as_part, :waiting_for_scrapping,
                :scrapped, :not_found, :at_group_member, :lost ]
  enum organization: [:ska, :svie]

  has_paper_trail
  belongs_to :group
  has_many :photos
  validates :name, length: {minimum: 2, too_short: 'Tul rovid nev'}
  validates :description, length: {maximum: 300, too_long: 'Tul hosszu leiras'}
  validates :group, presence: true, allow_nil: false
  validates :status, inclusion: {in: VALID_STATUS}

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
     self.entry_date, self.last_check, self.status, self.old_number]
  end

  def validate_purchase_date
    if purchase_date.present? && purchase_date > Date.today
      errors.add(:purchase_date, 'Jovobeni beszerzesi datum')
    end
  end

  def picture_path(ix = 0)
    "/items/#{self.id}/photos/#{ix}"
  end

  def self.filter(query)
    qs = query.split
    res = Item.all
    qs.each do |q|
      tok = q.split(':')
      if tok.length==1
        pattern = "%#{tok[0]}%"
        res = res.where('"name" LIKE ? OR "description" LIKE ? ', pattern, pattern)
      elsif tok.length>1
        field = tok[0]
        if %w(group name description status).include?(field)
          res = res.where("\"#{field}\" LIKE ?", "%#{tok[1]}%")
        end
      end
    end
    res
  end

end
