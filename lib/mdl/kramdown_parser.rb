# Modified version of the kramdown parser to add in features/changes
# appropriate for markdownlint, but which don't make sense to try to put
# upstream.
require 'kramdown/parser/gfm'
require_relative 'config'

module Kramdown
  module Parser
    # modified parser class - see comment above
    class MarkdownLint < Kramdown::Parser::Kramdown

      attr_reader :src, :tree

      def initialize(source, options)
        super
        i = @block_parsers.index(:codeblock_fenced)
        @block_parsers.delete(:codeblock_fenced)
        @block_parsers.insert(i, :codeblock_fenced_gfm)
        prepare_plugins
        # Kramdown::Parser::GFM::FENCED_CODEBLOCK_START
      end

      def prepare_plugins
        ::MarkdownLint::Config[:plugins].first['plugins'].each do |p|
          p.map do |type, parser|
            parsers = instance_variable_get("@#{type}".to_sym)
            parsers.unshift(parser.to_sym)
          end
        end
      end

      # Regular kramdown parser, but with GFM style fenced code blocks
      FENCED_CODEBLOCK_MATCH = Kramdown::Parser::GFM::FENCED_CODEBLOCK_MATCH
    end
  end
end
