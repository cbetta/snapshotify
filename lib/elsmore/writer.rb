module Elsmore
  class Writer
    attr_accessor :document

    DIRNAME = 'site'

    def initialize document
      self.document = document
    end

    def write
      write_file
    end

    private

    def write_file
      ensure_directory full_filename
      File.open(full_filename, 'w') do |file|
        file.write(document.doc.to_xml)
      end
    end

    def full_filename
      @full_filename ||= "#{DIRNAME}/#{host}#{filename}"
    end

    def ensure_directory filename
      dir = File.dirname(filename)
      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    def host
      document.url.uri.host
    end

    def filename
      @filename ||= begin
        path = document.url.uri.path
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
