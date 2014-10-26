require "tag_remover/version"

module TagRemover

  def self.process input, output, opts = {}
    tags_to_remove = opts[:remove_tags] || []

    in_tag = nil

    input.each_line.reduce(0) do |i,line|
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
        output.write line unless found_tag
      end

      i+1
    end
  end

end
