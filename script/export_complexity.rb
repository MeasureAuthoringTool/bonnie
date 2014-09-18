measures=Measure.all
open('complexity.csv','w') do |f1|
  f1.puts "Title, CMS_ID, ComplexityScore \n"
  for m in measures
  	f1.puts "#{m.title}, #{m.cms_id}, #{m.aggregate_complexity}\n" 
  end
end
