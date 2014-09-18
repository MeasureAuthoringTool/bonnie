measures=Measure.all
for m in measures
   comp = m.complexity
   keys = comp.keys
   agg_comp = 0
   for key in keys
	puts "#{key} : #{comp[key]}"
        agg_comp += comp[key]
   end
   
   puts "aggregate complexity: #{agg_comp}"
   m.update(aggregate_complexity:agg_comp)
end

