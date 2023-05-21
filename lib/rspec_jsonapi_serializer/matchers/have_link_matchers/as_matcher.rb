# frozen_string_literal: true

require "rspec_jsonapi_serializer/matchers/base"

module RSpecJSONAPISerializer
  module Matchers
    module HaveLinkMatchers
      class AsMatcher < Base
        def initialize(link, expected)
          super(expected)

          @link = link
        end

        def matches?(serializer_instance)
          @serializer_instance = serializer_instance

          actual == expected
        end

        def description
          "as #{expected_to_string}"
        end

        def expectation
          [ "as #{expected_to_string}", actual_message ].compact.join(", ")
        end

        private

        attr_reader :link

        def expected_to_string
          value_to_string(expected)
        end

        def actual_message
          "got #{value_to_string(actual)} instead" if links.has_key?(link)
        end

        def value_to_string(value)
          return 'nil' if value.nil?

          value.to_s
        end

        def actual
          links[link]
        end

        def links
          serializable_hash.dig(:data, :links)
        end

        def serializable_hash
          serializer_instance.serializable_hash
        end
      end
    end
  end
end
