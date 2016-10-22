module Elsmore
  class Url
    attr_accessor :parent, :raw_url, :valid, :uri

    def initialize raw_url, parent
      self.raw_url = raw_url
      self.parent = parent
      self.valid = true

      sanitize_string
      parse_uri
    end

    def host
      uri.host
    end

    def scheme
      uri.scheme
    end

    def canonical_url
      uri.to_s
    end

    private

    def sanitize_string
      self.raw_url = "http#{raw_url}" if raw_url.start_with?('//')
      self.raw_url = "#{parent.scheme}://#{parent.host}#{raw_url}" if raw_url.start_with?('/')
      self.raw_url = "http://#{raw_url}" unless raw_url.start_with?('http://') || raw_url.start_with?('https://')
    end

    def parse_uri
      self.uri = URI.parse(raw_url)
      uri.path = "/" if uri.path.empty?
      uri.fragment = nil
    rescue
      self.valid = false
    end
  end
end
