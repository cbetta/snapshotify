module Elsmore
  class Rewriter
    attr_accessor :resource

    def initialize resource
      self.resource = resource
    end

    def rewrite
      rewrite_linked_resources
      rewrite_links
    end

    private

    def rewrite_linked_resources
      write_css
      write_js
      write_images
    end

    def write_css
      resource.doc.xpath('//link[rel=stylesheet]').each do |element|
        write_element(element, 'href')
      end
    end

    def write_images
      resource.doc.xpath('//img').each do |element|
        write_element(element, 'src')
      end
    end

    def write_js
      resource.doc.xpath('//script').each do |element|
        write_element(element, 'src')
      end
    end

    def write_element element, key
      return unless element.attribute(key)
      url = element.attribute(key).value
      _resource = Elsmore::Resource.new(url, resource.url)
      # resource.write!
      element.attribute(key).value = _resource.url.canonical_url
    end

    def rewrite_links
      resource.doc.xpath('//a').each do |element|
        return unless element.attribute('href')
        href = element.attribute('href').value
        url = Elsmore::Url.new(href, resource.url)
        element.attribute('href').value = url.absolute_path_or_external_url
      end
    end
  end
end
