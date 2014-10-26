require "tag_remover/version"

module TagRemover

  def self.process input, output, opts = {}
    tags_to_remove = opts[:remove_tags] || []

    in_tag = nil
    depth = 0

    input.each_line.each do |line|
      if in_tag
        in_tag_str = tags_to_remove[in_tag]

        if line =~ /<#{in_tag_str}\s*>/
          depth += 1
        elsif line =~ /<\/#{in_tag_str}\s*>/
          depth -= 1
          in_tag = nil if depth == 0
        end
      else
        found_tag = false
        tags_to_remove.each_with_index do |tag,index|
          if line =~ /<#{tag}\s*>/
            in_tag = index
            depth = 1
            found_tag = true
            break
          elsif line =~ /<#{tag}\s*\/\s*>/
            found_tag = true
            break
          end
        end
        output.write line unless found_tag
      end
    end

    if opts[:close_streams]
      input.close
      output.close
    end
  end

end
