module Elsmore
  class Writer
    attr_accessor :document

    DIRNAME = 'site'

    def initialize document
      self.document = document
    end

    def write
      write_resources
      write_document
    end

    private

    def write_resources
      write_css
      write_js
      write_images
    end

    def write_css
      document.doc.xpath('//link[rel=stylesheet]').each do |element|
        write_element(element, 'href')
      end
    end

    def write_images
      document.doc.xpath('//img').each do |element|
        write_element(element, 'src')
      end
    end

    def write_js
      document.doc.xpath('//script').each do |element|
        write_element(element, 'src')
      end
    end

    def write_element element, key
      return unless element.attribute(key)
      url = element.attribute(key).value
      resource = Elsmore::Resource.new(url, document.url)
      # resource.write
      element.attribute(key).value = resource.url.canonical_url
    end

    def write_document
      rewrite_links
      write_file
    end

    def rewrite_links
      document.doc.xpath('//a').each do |element|
        return unless element.attribute('href')
        href = element.attribute('href').value
        url = Elsmore::Url.new(href, document.url)
        element.attribute('href').value = url.canonical_url
      end
    end

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
