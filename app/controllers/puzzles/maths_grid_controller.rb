class Puzzles::MathsGridController < ApplicationController
  def show
    @kizzle = MathsGridKizzle.new(create_params)
  end

  private

  def create_params

    transform_values_for_keys(
      params.permit(:rows, :columns, :factors_from, :factors_to, :factors_count_min, :factors_count_max),
      :rows, :columns, :factors_from, :factors_to, :factors_count_min, :factors_count_max,
      &:to_i
    )
  end

  def transform_values_for_keys(p, *keys, &block)
    p.merge(p.slice(*keys).transform_values(&block))
  end
end
