module Snapshotify
  class Writer
    attr_accessor :resource, :emitter

    def initialize resource
      self.resource = resource
    end

    def write
      write_file
    end

    def canonical_filename
      if host == parent_host
        "#{filename}"
      else
        "/#{host}#{filename}"
      end
    end


    private

    def write_file
      return if File.exist?(full_filename)
      ensure_directory full_filename

      emitter.log("! Saving #{full_filename}")

      File.open(full_filename, 'w') do |file|
        file.write(resource.data)
      end
    end

    def full_filename
      @full_filename ||= begin
        if host == parent_host || !parent_host
          "#{host}#{filename}"
        else
          "#{parent_host}/#{host}#{filename}"
        end
      end
    end

    def filename
      @filename ||= begin
        path = resource.url.uri.path
        if path.end_with?('/')
          return path + 'index.html'
        elsif !path.split('/').last.include?(".")
          return path + '/index.html'
        end
        path
      end
    end

    def ensure_directory filename
      dir = File.dirname(filename)
      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    def host
      resource.url.host
    end

    def parent_host
      resource.url.parent_host
    end


  end
end
