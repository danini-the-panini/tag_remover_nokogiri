require "tag_remover/version"

module TagRemover

  class Worker
    def initialize input, output, opts
      @input = input
      @output = output
      @opts = opts
    end

    def perform
      @tags_to_remove = @opts[:remove_tags] || []

      @in_tag = nil
      @depth = 0

      each_tag do |tag, type|
        process_tag tag, type
      end

      if @opts[:close_streams]
        @input.close
        @output.close
      end
    end

    private
      def process_tag tag, type
        if @in_tag
          in_tag_str = @tags_to_remove[@in_tag]

          if tag =~ opening_tag(in_tag_str)
            @depth += 1
          elsif tag =~ closing_tag(in_tag_str)
            @depth -= 1
            @in_tag = nil if @depth == 0
          end
        else
          found_tag = false
          @tags_to_remove.each_with_index do |tag_str,index|
            if tag =~ opening_tag(tag_str)
              @in_tag = index
              @depth = 1
              found_tag = true
              break
            elsif tag =~ single_tag(tag_str)
              found_tag = true
              break
            end
          end

          @output.write "#{tag}\n" unless found_tag || tag.empty?
        end
      end

      def opening_tag tag
        /<#{tag}(\s|(\s+.+?=(".+?"|'.+?')))*?>/
      end

      def closing_tag tag
        /<\/#{tag}\s*>/
      end

      def single_tag tag
        /<#{tag}(\s|(\s+.+?=(".+?"|'.+?')))*?\/\s*>/
      end

      def each_tag &block
        acc = ""
        type = nil

        @input.each_char do |c|
          case c
          when '<'
            yield acc.strip, type if type == :text
            type = :tag
            acc = c
          when '>'
            acc += c
            yield acc.strip, type
            type = nil
            acc = ""
          else
            type ||= :text
            acc += c
          end
        end

        yield acc.strip, type if type
      end
  end

  def self.process input, output, opts = {}
    Worker.new(input, output, opts).perform
  end

end
