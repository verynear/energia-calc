module Features
  module DownloadSupport
    extend ActiveSupport::Concern

    TIMEOUT = 15

    def clear_downloads
      wait_for_download if downloading?
      FileUtils.rm_f(downloads)
    end

    def download
      downloads.first
    end

    def download_content
      wait_for_download
      File.read(download)
    end

    def downloaded?
      !downloading? && downloads.any? && File.size(download) > 0
    end

    def downloading?
      downloads.grep(/\.part/).any?
    end

    def downloads
      Dir["#{RetrocalcSpecs::DOWNLOAD_PATH}/*"]
    end

    def wait_for_download
      Timeout.timeout(TIMEOUT) do
        sleep 0.01 until downloaded?
      end
    end

    included do
      after(:each) do
        clear_downloads
      end
    end
  end
end
