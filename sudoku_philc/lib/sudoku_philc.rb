require 'csv'
require "sudoku_philc/version"
require 'sudoku_philc/cell'
require 'sudoku_philc/grid'

module SudokuPhilc

  class << self
    attr_accessor :sudoku_arrays

    # should convert our csv into an array of arrays
    def parse(str)
      arrays = CSV.parse(str)
      arrays.each do |row|
        row.map!{|n| n.to_i}
      end
    end

  end
end

