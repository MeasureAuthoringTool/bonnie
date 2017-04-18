# TODO: When the CQL execution engine gets broken out into its own repository 
# and we are able to directly include the Coffeescript we may not need this because 
# rails should be able to uglify the execution engine for us.
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
