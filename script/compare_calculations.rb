#!/usr/bin/env ruby

# Give this a list of MAT export zip files that contain both SimpleXML and HQMF, this will run through them
# all comparing how the two versions calculate against all the appropriate patients in the DB

tests = passed = failures = errors = everything = nothing = 0

ARGV.each do |file|

  puts "=" * (file.length + 8)
  puts "Testing #{file}\n\n"

  result = `bundle exec rake bonnie:parser_comparison:compare_calculation FILE=#{file}`

  if summary = result.match(/(\d+) tests, (\d+) passed, (\d+) failures, (\d+) errors/)
    tests += summary[1].to_i
    passed += summary[2].to_i
    failures += summary[3].to_i
    errors += summary[4].to_i
    nothing += 1 if summary[1].to_i == 0
    everything += 1 if summary[1].to_i > 0 && summary[1].to_i == summary[2].to_i
  end

  puts result.split("\n").reject { |l| l.match(/no value set/) || l.match(/WARNING: Could not find metadata/) }.join("\n")

end

puts
puts
puts "Final tally: #{tests} tests, #{passed} passed, #{failures} failures, #{errors} errors"
puts "#{everything} measures passed all tests"
puts "#{nothing} measures did not even calculate"
