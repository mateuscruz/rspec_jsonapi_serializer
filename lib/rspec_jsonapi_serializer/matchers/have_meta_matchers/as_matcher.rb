# frozen_string_literal: true

require "rspec_jsonapi_serializer/matchers/base"

module RSpecJSONAPISerializer
  module Matchers
    module HaveMetaMatchers
      class AsMatcher < Base
        def initialize(meta, expected)
          super(expected)

          @meta = meta
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

        attr_reader :meta

        def expected_to_string
          value_to_string(expected)
        end

        def actual_message
          "got #{actual.nil? ? 'nil' : actual} instead" if metas.has_key?(meta)
        end

        def value_to_string(value)
          return 'nil' if value.nil?

          value.to_s
        end


        def actual
          metas[meta]
        end

        def metas
          @metas ||= serializable_hash.dig(:data, :meta) || {}
        end
      end
    end
  end
end
