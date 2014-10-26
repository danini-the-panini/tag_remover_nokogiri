require "tag_remover/version"

module TagRemover

  def self.process input, output, opts = {}
    tags_to_remove = opts[:remove_tags] || []

    in_tag = nil
    depth = 0

    input.each_line.reduce(0) do |i,line|
      if in_tag
        in_tag_str = tags_to_remove[in_tag]

        if line =~ /<#{in_tag_str}>/
          depth += 1
        elsif line =~ /<\/#{in_tag_str}>/
          depth -= 1
          in_tag = nil if depth == 0
        end
      else
        found_tag = false
        tags_to_remove.each_with_index do |tag,index|
          if line =~ /<#{tag}>/
            in_tag = index
            depth = 1
            found_tag = true
            break
          elsif line =~ /<#{tag}\/>/
            found_tag = true
            break
          end
        end
        output.write line unless found_tag
      end
    end
  end

end
