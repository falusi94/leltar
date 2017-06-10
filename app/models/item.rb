require 'csv'
class Item < ApplicationRecord
  VALID_STATUS = ['OK', 'Selejtezésre vár', 'Selejtezve', 'Utána kell járni', 'Elveszett']

  has_paper_trail
  belongs_to :group
  has_many :photos
  validates :name, length: {minimum: 5, too_short: 'Tul rovid nev'}
  validates :description, length: {maximum: 300, too_long: 'Tul hosszu leiras'}
  validates :group, presence: true, allow_nil: false
  validates :status, inclusion: {in: VALID_STATUS}

  def initialize(params = {})
    params[:group] = Group.by_name(params[:group])
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

  def update(data)
    if data[:group]
      group = Group.by_name(data[:group])
      data[:group] = group
    elsif data['group']
      group = Group.by_name(data['group'])
      data['group'] = group
    end
    super
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

  def self.csv_update(text)
    rows = CSV.parse text
    header = rows[0]
    Rails.logger.debug "headers: "+ header.inspect
    id_col = header.find_index('id')
    attributes = Item.new.attributes
    rows.drop(1).each do |row|
      doc = Hash.new
      Rails.logger.debug "row: #{row.inspect}"
      row.each_index do |i|
        if header[i] != 'id' && (attributes.include?(header[i]) || header[i] == 'group')
          doc.store(header[i], row[i])
          Rails.logger.debug "stored #{header[i]}: #{row[i].inspect}"
        end
      end
      Rails.logger.debug "item: #{doc.inspect}"
      
      begin
        id = id_col && Integer(row[id_col])
      rescue
        id = nil
      end
      item = nil
      if id
        item = Item.find_by_id(id)
      end
      if !item || !id
        item = Item.new
      end

      item.update(doc)
      item.valid?
      Rails.logger.debug "Errors: #{item.errors.full_messages.inspect}"
      item.save
    end
  end
end
