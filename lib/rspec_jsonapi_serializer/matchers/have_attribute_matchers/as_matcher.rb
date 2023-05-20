# frozen_string_literal: true

require "rspec_jsonapi_serializer/matchers/base"

module RSpecJSONAPISerializer
  module Matchers
    module HaveAttributeMatchers
      class AsMatcher < Base
        def initialize(attribute, expected)
          super(expected)

          @attribute = attribute
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

        attr_reader :attribute

        def expected_to_string
          value_to_string(expected)
        end

        def actual_message
          "got #{value_to_string(actual)} instead" if attributes.has_key?(attribute)
        end

        def value_to_string(value)
          return 'nil' if value.nil?

          value.to_s
        end

        def actual
          attributes[attribute]
        end

        def attributes
          serializable_hash.dig(:data, :attributes)
        end

        def serializable_hash
          serializer_instance.serializable_hash
        end
      end
    end
  end
end
