class Item < ApplicationRecord
  has_paper_trail
  has_attached_file :picture,
    styles: {thumb: '100x100', medium: '500x500'}, 
    default_url: ActionController::Base.helpers.asset_path("no_photo.gif")
  belongs_to :group
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  validates :name, length: {minimum: 5, too_short: 'Tul rovid nev'}
  validates :description, length: {maximum: 300, too_long: 'Tul hosszu leiras'}
  validates :group, presence: true, allow_nil: false

  def initialize(params = {})
    params[:group] = Group.by_name(params[:group])
    super(params)
  end

  def to_a
    [self.id, self.name, self.description, self.group, self.purchase_date, 
     self.entry_date, self.last_check, self.status, self.old_number]
  end

  def validate_purchase_date
    if purchase_date.present? && purchase_date > Date.today
      errors.add(:purchase_date, 'Jovobeni beszerzesi datum')
    end
  end

  def update(data)
    if data[:group]
      group = Group.by_name(data[:group])
      data[:group] = group
    end
    super
  end

  def self.filter(query)
    qs = query.split
    res = Item.all
    qs.each do |q|
      tok = q.split(':')
      if tok.length==1
        pattern = "%#{tok[0]}%"
        res = res.where('"name" LIKE ? OR "description" LIKE ? OR "group" LIKE ?',  pattern, pattern, pattern)
      elsif tok.length>1
        field = tok[0]
        if %w(group name description).include?(field)
          res = res.where("\"#{field}\" LIKE ?", "%#{tok[1]}%")
        end
      end
    end
    res
  end
  
  def self.groups
    Item.select('group').group('group').map { |x| x.group }
  end
end
