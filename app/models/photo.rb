class Photo < ApplicationRecord
  has_attached_file :file, styles: { thumb: '100x100', medium: '500x500' },
                           default_url: ActionController::Base.helpers.asset_path('no_photo.gif')
  validates_attachment_content_type :file, content_type: %r{/\Aimage\/.*\z/}
  belongs_to :item

  def url(size = nil)
    file.url(size) if size

    file.url
  end
end
