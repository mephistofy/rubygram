class ImageUploader < Shrine
  plugin :default_url
  plugin :determine_mime_type, analyzer: :file

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/jpg image/webp]
  end

  Attacher.default_url do |**options|
    'https://scontent-lga3-2.cdninstagram.com/v/t51.2885-19/44884218_345707102882519_2446069589734326272_n.jpg?_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_ohc=d0j1pWabatQAX91cekv&oh=e3ed292241a73c646971ca14706f2c97&oe=6038598F&ig_cache_key=YW5vbnltb3VzX3Byb2ZpbGVfcGlj.2'
  end
end
