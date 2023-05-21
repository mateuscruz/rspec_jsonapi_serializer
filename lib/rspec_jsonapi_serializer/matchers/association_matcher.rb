# frozen_string_literal: true

require "rspec_jsonapi_serializer/matchers/base"
require "rspec_jsonapi_serializer/matchers/association_matchers/serializer_matcher"
require "rspec_jsonapi_serializer/matchers/association_matchers/id_method_name_matcher"
require "rspec_jsonapi_serializer/matchers/association_matchers/object_method_name_matcher"
require "rspec_jsonapi_serializer/metadata/relationships"

module RSpecJSONAPISerializer
  module Matchers
    class AssociationMatcher < Base
      def initialize(expected, relationship_matcher, relationship_type)
        super(expected)

        @relationship_matcher = relationship_matcher
        @relationship_type    = relationship_type
      end

      def matches?(serializer_instance)
        @serializer_instance = serializer_instance

        relationship_matches? && submatchers_match?
      end

      def serializer(value)
        add_submatcher AssociationMatchers::SerializerMatcher.new(value, expected)

        self
      end

      def id_method_name(value)
        add_submatcher AssociationMatchers::IdMethodNameMatcher.new(value, expected)

        self
      end

      def object_method_name(value)
        add_submatcher AssociationMatchers::ObjectMethodNameMatcher.new(value, expected)

        self
      end

      def description
        description = "#{association_message} #{expected}"

        [description, submatchers.map(&:description)].flatten.join(' ')
      end

      def failure_message
        "Expected #{expectation}"
      end

      def failure_message_when_negated
        "Did not expect #{expectation}"
      end

      private

      attr_reader :relationship_matcher, :relationship_type

      def expectation
        expectation = "#{serializer_name} to #{association_message} #{expected}"

        submatchers_expectations = failing_submatchers.map do |submatcher|
          "(#{submatcher.expectation})"
        end.compact.join(", ")

        [expectation, submatchers_expectations].reject(&:nil?).reject(&:empty?).join(" ")
      end

      def relationship_matches?
        actual.present? && actual_relationship_type == relationship_type &&
        actual_rendered?
      end

      def association_message
        relationship_matcher.to_s.split("_").join(" ")
      end

      def actual_rendered?
        relationships = serializable_hash.dig(:data, :relationships)

        relationships.key?(expected) || relationships.key?(expected.to_s)
      end

      def actual_relationship_type
        actual.relationship_type
      end

      def actual
        metadata.relationship(expected)
      end

      def relationships
        metadata.relationships
      end

      def metadata
        Metadata::Relationships.new(serializer_instance)
      end
    end
  end
end
