module Snapshotify
  # A helper class for writing a document to file
  class Writer
    attr_accessor :resource, :emitter

    # Initialize with a document or asset to write to file
    def initialize resource
      self.resource = resource
    end

    # Writes a resource to file
    def write
      emitter.log("! Saving #{full_filename}")
      ensure_directory
      write_file
    end

    # def canonical_filename
    #   if host == parent_host
    #     "#{filename}"
    #   else
    #     "/#{host}#{filename}"
    #   end
    # end

    private

    # Ensure the directory for the file exists
    def ensure_directory
      dir = File.dirname(full_filename)
      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    # Write the content of the resource to a file
    def write_file
      File.open(full_filename, 'w') do |file|
        file.write(resource.data)
      end
    end

    # Determine the full file name for the resource
    def full_filename
      # If the resource host is the parent hose
      # just write this file to the same folder
      if resource_host == parent_host || !parent_host
        "snaps/#{resource_host}#{filename}"
      # If the resource host is not the same as the parent host
      # we use a sub folder
      else
        "snaps/#{parent_host}/#{resource_host}#{filename}"
      end
    end

    # The actual name of the file
    def filename
      # Based on the path of the file
      path = resource.url.uri.path
      # It's either an index.html file
      # if the path ends with a slash
      if path.end_with?('/')
        return path + 'index.html'
      # Or it's also an index.html if it ends
      # without a slah yet is not a file with an
      # extension
      elsif !path.split('/').last.include?(".")
        return path + '/index.html'
      end
      # Alternative, the filename is the path as described
      path
    end

    # The host name of the resource
    def resource_host
      resource.url.host
    end

    # The host name of the page it's featured on
    def parent_host
      resource.url.parent_host
    end
  end
end
