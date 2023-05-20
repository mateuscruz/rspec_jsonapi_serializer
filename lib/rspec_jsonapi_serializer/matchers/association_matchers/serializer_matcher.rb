# frozen_string_literal: true

require "rspec_jsonapi_serializer/metadata/relationships"

module RSpecJSONAPISerializer
  module Matchers
    module AssociationMatchers
      class SerializerMatcher < Base
        def initialize(value, relationship_target)
          super(value)

          @relationship_target  = relationship_target
        end

        def matches?(serializer_instance)
          @serializer_instance = serializer_instance

          actual == expected
        end

        def main_failure_message
          [expected_message, actual_message].compact.join(", ")
        end

        def main_failure_message_when_negated
          [expected_message(expectation: "not to"), actual_message].compact.join(", ")
        end

        private

        attr_reader :relationship_target

        def expected_message(expectation: "to")
          "expected #{serializer_name} #{expectation} use #{expected} as serializer for #{relationship_target}"
        end

        def actual_message
          actual != expected ? "got #{actual} instead" : nil
        end

        def actual
          metadata.relationship(relationship_target).serializer
        end

        def metadata
          Metadata::Relationships.new(serializer_instance)
        end
      end
    end
  end
end
