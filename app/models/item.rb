class Item < ApplicationRecord
  has_paper_trail
  has_attached_file :picture,
    styles: {thumb: '100x100', medium: '500x500'}, 
    default_url: ActionController::Base.helpers.asset_path("no_photo.gif")
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
end
