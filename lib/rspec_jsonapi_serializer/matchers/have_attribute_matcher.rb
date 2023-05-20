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
        add_submatcher HaveAttributeMatchers::AsMatcher.new(expected, nil)

        self
      end

      def description
        description = "have attributed #{expected}"

        [description, submatchers.map(&:description)].flatten.join(' ')
      end

      def main_failure_message
        "expected #{expectation}."
      end

      def main_failure_message_when_negated
        "Did not expect #{expectation}."
      end

      private

      def expectation
        "#{serializer_name} to have attribute #{expected}"
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
