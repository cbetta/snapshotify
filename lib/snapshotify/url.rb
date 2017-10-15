module Snapshotify
  class Url
    attr_accessor :parent, :raw_url, :valid, :uri

    def initialize raw_url, parent
      self.raw_url = raw_url.strip
      self.parent = parent
      self.valid = true

      sanitize_string
      parse_uri
    end

    def host
      uri.host
    end

    def parent_host
      return unless parent
      parent.host
    end

    def scheme
      uri.scheme
    end

    def canonical_url
      uri.to_s
    end

    def absolute_path_or_external_url
      if parent && parent.host == host
        uri.path
      else
        canonical_url
      end
    end

    def resource_path
      if parent && parent.host == host
        uri.path
      else
        canonical_url.gsub('http:/', '').gsub('https:/', '')
      end
    end

    private

    def sanitize_string
      if raw_url.start_with?('//')
        self.raw_url = "http:#{raw_url}"
      elsif raw_url.start_with?('/')
        self.raw_url = "#{parent.scheme}://#{parent.host}#{raw_url}"
      elsif !(raw_url.start_with?('http://') || raw_url.start_with?('https://'))
        if parent
          self.raw_url = URI.join(parent.canonical_url, raw_url).to_s
        else
          self.raw_url = "http://#{raw_url}"
        end
      end
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
