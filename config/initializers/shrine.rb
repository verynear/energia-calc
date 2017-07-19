require 'shrine'
require 'shrine/storage/file_system'
# require 'shrine/storage/google_drive_storage'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :default_url
Shrine.plugin :remove_attachment
Shrine.plugin :validation_helpers
Shrine.plugin :processing
Shrine.plugin :versions
Shrine.plugin :determine_mime_type
Shrine.plugin :remote_url, max_size: 20*1024*1024
Shrine.plugin :moving
Shrine.plugin :pretty_location
Shrine.plugin :default_url_options
Shrine.plugin :logging, logger: Rails.logger