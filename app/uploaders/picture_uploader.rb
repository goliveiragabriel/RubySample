# encoding: utf-8
class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def fog_directory
    "bemcasados-site"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "/images/" + [version_name, "default_profile.gif"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  
  version :normal do
    process :resize_to_limit  => [100, 100]
  end

  version :thumb do
    process :resize_to_fill => [50, 50]
  end

  version :small do
    process :resize_to_limit  => [100, 35]
  end
  # Task para recriar as imagens
  # User.all.each do |user|
  #   user.avatar.recreate_versions!
  # end
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  #def filename
  #  "#{model.name}#{File.extname(original_filename).downcase}" if original_filename
  #end


end
