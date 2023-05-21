# frozen_string_literal: true

module RSpecJSONAPISerializer
  module Matchers
    class Base
      def initialize(expected)
        @expected    = expected
        @submatchers = []
      end

      def matches?(serializer_instance)
        raise NotImplementedError
      end

      def failure_message
        raise NotImplementedError
      end

      def failure_message_when_negated
        raise NotImplementedError
      end

      protected

      attr_reader :expected, :serializer_instance, :submatchers

      def add_submatcher(submatcher)
        submatchers << submatcher
      end

      def submatchers_match?
        submatchers.all? { |submatcher| submatcher.matches?(serializer_instance) }
      end

      def serializable_hash
        serializer_instance.serializable_hash
      end

      def serializer_name
        serializer_instance.class.name
      end

      def failing_submatchers
        @failing_submatchers ||= submatchers.select do |submatcher|
          !submatcher.matches?(serializer_instance)
        end
      end
    end
  end
end
