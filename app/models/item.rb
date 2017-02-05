class Item < ApplicationRecord
  has_attached_file :picture, styles: {thumb: '100x100', medium: '500x500'} 
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
end
