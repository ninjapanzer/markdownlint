# Modified version of the kramdown parser to add in features/changes
# appropriate for markdownlint, but which don't make sense to try to put
# upstream.
require 'kramdown/parser/gfm'
require 'kramdown/parser/automation'


module Kramdown
  module Parser
    # modified parser class - see comment above
    class MarkdownLint < Kramdown::Parser::Kramdown

      Kramdown::Parser::Automation.load_extension(
        :codeblock_automation,
        {
          start: Kramdown::Parser::GFM::FENCED_CODEBLOCK_START
        }
      )

      def initialize(source, options)
        super
        i = @block_parsers.index(:codeblock_fenced)
        @block_parsers.delete(:codeblock_fenced)
        @block_parsers.insert(i, :codeblock_fenced_gfm)
        @block_parsers.unshift(:codeblock_automation)
      end

      Kramdown::Parser::Automation::REGISTRY.each do |parser|
        define_method("parse_#{parser}".to_sym) do
          Kramdown::Parser::Automation.send("parse_#{parser}".to_sym, self, @src, @tree)
        end
      end

      def new_block_el(*args)
        super
      end

      # Regular kramdown parser, but with GFM style fenced code blocks
      FENCED_CODEBLOCK_MATCH = Kramdown::Parser::GFM::FENCED_CODEBLOCK_MATCH
    end
  end
end
