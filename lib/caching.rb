require 'fileutils'
 
helpers do 
  def cache(text)
   # requests to / should be cached as index.html
   uri = request.env["REQUEST_URI"] == "/" ? 'index' : request.env["REQUEST_URI"]
 
   # Don't cache pages with query strings.
   unless uri =~ /\?/
      uri << '.html'
      # put all cached files in public/
      path = File.join(File.dirname(__FILE__), '..', 'public', uri)
 
      # Write the text passed to the path
      File.open(path, 'w') { |f| f.write( text ) }
    end
    return text
  end
end