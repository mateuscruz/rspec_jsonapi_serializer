# frozen_string_literal: true

require "rspec_jsonapi_serializer/matchers/base"
require "rspec_jsonapi_serializer/matchers/have_meta_matchers/as_matcher"

module RSpecJSONAPISerializer
  module Matchers
    class HaveMetaMatcher < Base
      def matches?(serializer_instance)
        @serializer_instance = serializer_instance

        has_meta? && submatchers_match?
      end

      def as(value)
        add_submatcher HaveMetaMatchers::AsMatcher.new(expected, value)

        self
      end

      def as_nil
        as(nil)
      end

      def description
        description = "serialize meta #{expected}"

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
        expectation = "#{serializer_name} to serialize meta #{expected}"

        submatchers_expectations = failing_submatchers.map do |submatcher|
          "(#{submatcher.expectation})"
        end.compact.join(", ")

        [expectation, submatchers_expectations].reject(&:nil?).reject(&:empty?).join(" ")
      end

      def metas
        @metas ||= serializable_hash.dig(:data, :meta) || {}
      end

      def has_meta?
        metas.has_key?(expected)
      end
    end
  end
end
