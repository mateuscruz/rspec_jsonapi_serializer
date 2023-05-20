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

      def description
        association_matcher.description
      end

      def failure_message
        association_matcher.failure_message
      end

      private

      attr_reader :association_matcher
    end
  end
end
