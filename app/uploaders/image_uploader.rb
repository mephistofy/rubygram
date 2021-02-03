class ImageUploader < Shrine
  plugin :default_url
  plugin :determine_mime_type, analyzer: :file

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/jpg image/webp]
  end

  Attacher.default_url do |**options|
    "cat_meme.webp"
  end
end
