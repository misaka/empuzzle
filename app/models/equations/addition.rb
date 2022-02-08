module Equations
  class Addition
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :count_min
    attribute :count_max
    attribute :from
    attribute :to
    attribute :total_max
    attribute :numbers
    attribute :result
    attribute :random

    def initialize(attributes = {})
      super

      initialize_numbers
    end

    def type
      :addition
    end

    def result
      numbers.reduce(&:+)
    end

    private

    def initialize_numbers
      loop do
        number_count = random_in_range(count_min, count_max, random: random)
        self.numbers = number_count.times.map do
          random_in_range(from, to, random: random)
        end

        self.result = numbers.inject(:+)

        break if total_max.nil? || result <= total_max
      end
    end
  end
end
