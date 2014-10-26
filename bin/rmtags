require 'tag_remover'

input_filename = ARGV[0] || 'input.xml'
output_filename = ARGV[1] || 'output.xml'

tags_to_remove = ARGV[2..-1]

puts "processing #{input_filename} into #{output_filename}"

input_file = File.open input_filename, 'r'
output_file = File.open output_filename, 'w'

TagRemover.process input_file, output_file,
  remove_tags: tags_to_remove, close_streams: true

