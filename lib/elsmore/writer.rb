module Elsmore
  class Writer
    attr_accessor :url

    DIRNAME = 'site'

    def initialize url
      self.url = url
    end

    def write
      write_resources
      write_file
    end

    private

    def write_resources
      write_css
      write_js
      write_images
    end

    def write_css
      url.doc.xpath('//link[rel=stylesheet]').each do |element|
        # ap element.attribute('href').value
      end
    end

    def write_js
    end

    def write_images
    end

    def write_file
      ensure_directory full_filename
      File.open(full_filename, 'w') do |file|
        file.write(url.doc.to_xml)
      end
    end

    def full_filename
      @full_filename ||= "#{DIRNAME}#{filename}"
    end

    def ensure_directory filename
      dir = File.dirname(filename)
      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    def filename
      @filename ||= begin
        path = url.url.uri.path
        if path.end_with?('/')
          return path + 'index.html'
        elsif !path.split('/').last.include?(".")
          return path + '/index.html'
        end
        path
      end
    end
  end
end
