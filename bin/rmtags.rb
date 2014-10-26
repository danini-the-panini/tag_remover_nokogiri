input_filename = ARGV[0] || 'input.xml'
output_filename = ARGV[1] || 'output.xml'

tags_to_remove = [
  'EnqCC_ACTIVITIES',
  'EnqCC_ADDRESS',
  'EnqCC_ADVERSE',
  'EnqCC_BRANCHES',
  'EnqCC_CPA_ACCOUNTS',
  'EnqCC_DEBT_RESTRUCT',
  'EnqCC_DISPUTE',
  'EnqCC_Deeds_DATA',
  'EnqCC_Directors_DATA',
  'EnqCC_EMPLOYER',
  'EnqCC_ENQ_COUNTS',
  'EnqCC_Fraud',
  'EnqCC_LOANS',
  'EnqCC_NLR_ACCOUNTS',
  'EnqCC_PMATCHES',
  'EnqCC_PREVENQ',
  'EnqCC_STATS',
  'EnqCC_TELEPHONE',
  'EnqCC_TRACE'
]

puts "processing #{input_filename} into #{output_filename}"

input_file = File.open input_filename, 'r'
output_file = File.open output_filename, 'w'

in_tag = nil

input_file.each_line.reduce(0) do |i,line|
  puts i if i % 10_000 == 0

  if in_tag
    in_tag_str = tags_to_remove[in_tag]
    in_tag = nil if line =~ /<\/#{in_tag_str}>/
  else
    found_tag = false
    tags_to_remove.each_with_index do |tag,index|
      if line =~ /<#{tag}>/
        in_tag = index
        found_tag = true
        break
      elsif line =~ /<#{tag}\/>/
        found_tag = true
        break
      end
    end
    output_file.write line unless found_tag
  end

  i+1
end

puts "done"

input_file.close
output_file.close
