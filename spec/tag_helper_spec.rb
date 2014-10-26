require 'spec_helper'

describe TagRemover do
  describe ".process" do
    it "removes elements" do
      input = StringIO.new """
      <root>\n
        <remove>\n
          Some contents
        </remove>\n
      </root>\n
      """
      tags_to_remove = ['remove']

      output = StringIO.new

      TagRemover.process input, output, remove_tags: tags_to_remove

      expect(output.string).to be """
      <root>\n
      </root>\n
      """
    end

    it "removes single tags" do
      input = StringIO.new """
      <root>\n
        <remove/>\n
      </root>\n
      """
      tags_to_remove = ['remove']

      output = StringIO.new

      TagRemover.process input, output, remove_tags: tags_to_remove

      expect(output.string).to be """
      <root>\n
      </root>\n
      """
    end

    it "keeps elements" do
      input = StringIO.new """
      <root>\n
        <keep>\n
        </keep>\n
      </root>\n
      """
      tags_to_remove = ['remove']

      output = StringIO.new

      TagRemover.process input, output, remove_tags: tags_to_remove

      expect(output.string).to eq input.string
    end

    it "is ok with doing nothing" do
      input = StringIO.new """
      <root>\n
      </root>\n
      """

      output = StringIO.new

      TagRemover.process input, output

      expect(output.string).to eq input.string
    end
  end
end
