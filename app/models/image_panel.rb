class ImagePanel < Panel
  has_attached_file :image

  def image_url
    image.file? ? image.url : unattached_image_url
  end
end