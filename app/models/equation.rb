class Equation
  include ActiveModel::API
  include ActiveModel::Attributes
  include AdditionEquationGeneratorConcern
  include SubtractionEquationGeneratorConcern
  include MultiplicationEquationGeneratorConcern
  include DivisionEquationGeneratorConcern

  attribute :type
  attribute :numbers
  attribute :result

  def initialize(attributes = {})
    super

    self.result ||= result
  end

  def to_h
    { numbers:, result:, type: }
  end

  def result
    # if type.to_s == "division"
    #   numbers.map(&:to_f).inject(operator)
    # else
      numbers.reduce(operator)
    # end
  end

  def operator
    {
      "addition" => :+,
      "subtraction" => :-,
      "multiplication" => :*,
      "division" => :/
    }[
      type.to_s
    ]
  end

  class << self
    def from_h(hash)
      new(**hash.slice("numbers", "result", "type"))
    end

    def generate(type:, **config)
      numbers =
        case type
        when :addition
          generate_addition_numbers(**config)
        when :subtraction
          generate_subtraction_numbers(**config)
        when :multiplication
          generate_multiplication_numbers(**config)
        when :division
          generate_division_numbers(**config)
        else
          raise ArgumentError, "Unknown equation type: #{type}"
        end
      new(type:, numbers:)
    end
  end
end
