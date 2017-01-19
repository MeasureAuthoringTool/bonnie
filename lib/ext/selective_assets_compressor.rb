require 'uglifier'

class SelectiveAssetsCompressor < Uglifier
 def initialize(options = {})
   super(options)
 end

 def compress(string)
   # Do not compress assets that contain the string 'no_asset_compression'
   if string =~ /no_asset_compression/
     string
   else
     super(string)
   end
 end
end
