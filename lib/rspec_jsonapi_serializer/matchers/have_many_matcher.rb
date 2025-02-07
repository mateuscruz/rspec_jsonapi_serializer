# frozen_string_literal: true

require "rspec_jsonapi_serializer/matchers/association_matcher"

module RSpecJSONAPISerializer
  module Matchers
    class HaveManyMatcher
      def initialize(expected)
        @association_matcher = AssociationMatcher.new(expected, :have_many, :has_many)
      end

      def matches?(serializer_instance)
        association_matcher.matches?(serializer_instance)
      end

      def id_method_name(value)
        association_matcher.id_method_name(value)
      end

      def object_method_name(value)
        association_matcher.object_method_name(value)
      end

      def serializer(value)
        association_matcher.serializer(value)
      end

      def description
        association_matcher.description
      end

      def failure_message
        association_matcher.failure_message
      end

      def failure_message_when_negated
        association_matcher.failure_message_when_negated
      end

      private

      attr_reader :association_matcher
    end
  end
end
