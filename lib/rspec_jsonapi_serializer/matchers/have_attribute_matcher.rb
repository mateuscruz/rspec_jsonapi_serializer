# frozen_string_literal: true

require "rspec_jsonapi_serializer/matchers/base"
require "rspec_jsonapi_serializer/matchers/have_attribute_matchers/as_matcher"

module RSpecJSONAPISerializer
  module Matchers
    class HaveAttributeMatcher < Base
      def matches?(serializer_instance)
        @serializer_instance = serializer_instance

        has_attribute? && submatchers_match?
      end

      def as(value)
        add_submatcher HaveAttributeMatchers::AsMatcher.new(expected, value)

        self
      end

      def as_nil
        as(nil)
      end

      def description
        description = "have attribute #{expected}"

        [description, submatchers.map(&:description)].flatten.join(' ')
      end

      def failure_message
        "Expected #{expectation}."
      end

      def failure_message_when_negated
        "Did not expect #{expectation}."
      end

      private

      def expectation
        expectation = "#{serializer_name} to have attribute #{expected}"

        submatchers_expectations = failing_submatchers.map do |submatcher|
          "(#{submatcher.expectation})"
        end.compact.join(", ")

        [expectation, submatchers_expectations].reject(&:nil?).reject(&:empty?).join(" ")
      end

      def attributes
        @attributes ||= serializer_instance.class.try(:attributes_to_serialize) || {}
      end

      def has_attribute?
        attributes.has_key?(expected)
      end
    end
  end
end
