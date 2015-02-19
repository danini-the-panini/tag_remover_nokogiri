require "tag_remover/version"
require "nokogiri"

module TagRemover

  class Worker
    def initialize input, output, opts
      @input = input
      @output = output
      @opts = opts
    end

    def perform
      @tags_to_remove = @opts[:remove_tags] || []

      @reader = Nokogiri::XML::Reader @input

      @in_tag = nil
      @depth = 0

      @reader.each do |node|
        process_node node
      end

      if @opts[:close_streams]
        @input.close
        @output.close
      end
    end

    private
      def process_node node
        if @in_tag
          in_tag_str = @tags_to_remove[@in_tag]

          if opening_tag? node, in_tag_str
            @depth += 1
          elsif closing_tag? node, in_tag_str
            @depth -= 1
            @in_tag = nil if @depth == 0
          end
        else
          found_tag = false
          @tags_to_remove.each_with_index do |tag_str,index|
            if opening_tag? node, tag_str
              @in_tag = index
              @depth = 1
              found_tag = true
            elsif single_tag? node, tag_str
              found_tag = true
            end
            break if found_tag
          end
          @output.write stringify(node) unless found_tag
        end
      end

      def opening_tag? tag, match = nil
        return (tag.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT) && !tag.self_closing? && match?(tag, match)
      end

      def closing_tag? tag, match = nil
        return (tag.node_type == Nokogiri::XML::Reader::TYPE_END_ELEMENT) && match?(tag, match)
      end

      def single_tag? tag, match = nil
        return tag.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT && tag.self_closing? && match?(tag, match)
      end

      def match? tag, match = nil
        (match.nil? || tag.name == match)
      end

      def stringify tag
        if opening_tag? tag
          "<#{tag.name}>\n"
        elsif closing_tag? tag
          "</#{tag.name}>\n"
        elsif single_tag? tag
          "<#{tag.name}/>\n"
        elsif tag.value?
          s = tag.value.strip
          s.empty? ? "" : "#{s}\n"
        else
          "#{tag.to_s}\n"
        end
      end

      def stringify_attributes tag

      end

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
  end

  def self.process input, output, opts = {}
    Worker.new(input, output, opts).perform
  end

end
