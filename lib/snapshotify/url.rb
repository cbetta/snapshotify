module Snapshotify
  # A helper class to parse URLs
  class Url
    attr_accessor :parent, :raw_url, :valid, :uri

    # Take in the raw URL and the page this
    # URL is referenced on
    def initialize raw_url, parent
      # strip the URL
      self.raw_url = raw_url.strip
      # Set the parent
      self.parent = parent
      # By default assume the URL is valid
      self.valid = true

      # Sanitize and parse the URL
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

    # Standardise the URL
    def sanitize_string
      # if the URL starts without a //, add http to the URL
      if raw_url.start_with?('//')
        self.raw_url = "http:#{raw_url}"
      # If the url starts with a single slash, prepend the parent host and scheme
      elsif raw_url.start_with?('/')
        self.raw_url = "#{parent.scheme}://#{parent.host}#{raw_url}"
      end
      # # If the URL does not use the http(s) protocol
      # elsif !(raw_url.start_with?('http://') || raw_url.start_with?('https://'))
      #   if parent
      #     self.raw_url = URI.join(parent.canonical_url, raw_url).to_s
      #   else
      #     self.raw_url = "http://#{raw_url}"
      #   end
      # end
    end

    # Parse the raw URL as a URI object
    def parse_uri
      self.uri = URI.parse(raw_url)
      uri.path = "/" if uri.path.empty?
      uri.fragment = nil
      # if this fails, mark the URL as invalid
    rescue
      self.valid = false
    end
  end
end
