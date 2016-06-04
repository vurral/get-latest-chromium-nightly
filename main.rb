require 'net/http'
require 'oga'
require 'open-uri'
require 'zip'

PATH_TO_ZIP = './chrome-mac.zip'
PATH_TO_EXTRACTED_FILE = './Chromium.app'
PATH_TO_LOCAL_CHROMIUM = '~/Applications/Chromium.app'
LATEST_CHROMIUM_BUILD_URL = 'https://download-chromium.appspot.com/dl/Mac?type=snapshots'

def clean_up
    FileUtils.remove_dir(PATH_TO_EXTRACTED_FILE) if File.exists?(PATH_TO_EXTRACTED_FILE)
    File.delete(PATH_TO_ZIP) if File.exists?(PATH_TO_ZIP)
end

def extract_zip(file, destination)
  FileUtils.mkdir_p(destination)

  Zip::File.open(file) do |zip_file|
    zip_file.each do |f|
      fpath = File.join(destination, f.name)
      fpath = fpath.gsub("/chrome-mac", "") # Remove the folder inside the zip
      zip_file.extract(f, fpath) unless File.exist?(fpath)
    end
  end
end

# Grab the download url from chromium.woolyss.com, but that is probably taken from https://download-chromium.appspot.com/ as well, so that's not needed
def get_download_url
    html = open('http://chromium.woolyss.com/')
    document = Oga.parse_html(html.read)
    link = document.css('#mac-64-bit-archive strong a.s')

    link.attr('href')[0].value
end

def download_chromium(download_url)
    open(PATH_TO_ZIP, 'w') do |local_file|
        open(download_url) do |remote_file|
            local_file.write(remote_file.read)
        end
    end
end

def remove_installed_chromium
    local_chromium = File.expand_path(PATH_TO_LOCAL_CHROMIUM)
    FileUtils.remove_dir(local_chromium) if File.exists?(local_chromium)
end

def copy_new_version_to_applications_folder
    downloaded_chromium = File.expand_path(PATH_TO_EXTRACTED_FILE)
    FileUtils.cp_r(downloaded_chromium, File.expand_path('~/Applications/'))
end

clean_up

download_chromium(LATEST_CHROMIUM_BUILD_URL)
extract_zip(PATH_TO_ZIP, './')

remove_installed_chromium
copy_new_version_to_applications_folder

clean_up