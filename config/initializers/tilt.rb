# Make it so by defualt no scope protection is added to .coffee transpiling.
require 'tilt'
Tilt::CoffeeScriptTemplate.default_bare = true
