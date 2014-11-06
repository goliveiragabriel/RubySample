CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Yetting.aws_access_key_id,
    :aws_secret_access_key  => Yetting.aws_secret_access_key,
    :region                 => 'sa-east-1' #'us-east-1'
  }
  config.delete_tmp_file_after_storage = false
  config.fog_host = ''
  config.fog_attributes = {'Cache-Control'=>'max-age=31536000'}
  config.fog_public = true
end