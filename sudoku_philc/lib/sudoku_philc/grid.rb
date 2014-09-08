module SudokuPhilc
  class Grid
    require 'csv'
    attr_accessor :cells

    def initialize(str)
      @cells = Array.new(81)
      arr = parse(str)
      raise SudokuPhilc::Grid::InsufficientData if arr.count < 81
      raise SudokuPhilc::Grid::SuperfluousData if arr.count > 81
      arr.each_with_index do |value, index|
        @cells[index] = Cell.new(value)
      end
      raise SudokuPhilc::Grid::InvalidPuzzle if !valid?
    end

    def valid?
      validity = (0..8).map do |index|
        this_row = row(index)
        this_column = column(index)
        this_zone = zone(index)
        [
          this_row.map{|n| n.value==false ? 0 : n.value}.inject(&:+) <= 45,
          this_column.map{|n| n.value==false ? 0 : n.value}.inject(&:+) <= 45,
          this_zone.map{|n| n.value==false ? 0 : n.value}.inject(&:+) <= 45,
          this_row.reject{|n| n.value==false}.count == this_row.reject{|n| n.value==false}.uniq.count,
          this_column.reject{|n| n.value==false}.count == this_column.reject{|n| n.value==false}.uniq.count,
          this_zone.reject{|n| n.value==false}.count == this_zone.reject{|n| n.value==false}.uniq.count,
        ]
      end
      validity.flatten.all?{|b| b == true}
    end

    # returns a row; row 0 is the top row, row 8 is the bottom
    def row(index)
      cells.each_with_index.map{|cell,i| cell if i/9==index}.compact
    end

    # returns a column; column 0 is the left-most, column 9 is the 
    # right-most
    def column(index)
      cells.each_with_index.map{|cell,i| cell if i%9==index}.compact
    end

    # returns a zone; a zone is a 3x3 block within the puzzle
    # there are 9 zones.
    # We'll index them from top to bottom, left to right:
    #  0 | 1 | 2
    # -----------
    #  3 | 4 | 5
    # -----------
    #  6 | 7 | 8
    def zone(index)
      root_cell = zone_indices[index]
      cells[root_cell..root_cell+2] + cells[root_cell+9..root_cell+11] + cells[root_cell+18..root_cell+20] 
    end

    # returns the number of 'known values' in the puzzle
    def clues
      cells.select(&:value?).count
    end

    def solve
      progress = true
      tries = 0
      while progress
        starting_clues = clues
        # for each _layer_
        (1..9).each do |layer|
          (0..8).each do |index|
            # examine the rows
            examine_row(index,layer)
            # examine the columns
            examine_column(index,layer)
            # examine the zones
            examine_zone(index,layer)
          end
        end
        # check all cells.
        cells.each{|cell| cell.check }
        progress = clues > starting_clues
        if tries <= 5
          progress = true # pretend we're still making progress
          tries += 1
        end
      end


      if !complete?
        # because this algorithm does no guessing, 
        # it can generate false positives here. See README
        raise SudokuPhilc::Grid::UnsolvablePuzzle
      else
        # solved
        true
      end
    end

    def complete?
      # a puzzle is complete if every cell knows its value
      clues == 81
    end

    def examine_row(index,layer)
      this_row = row(index)
      i = this_row.index{|cell| cell.value==layer}
      if !i.nil?
        (this_row-[this_row[i]]).each do |cell|
          cell.rule_out(layer)
        end
      else
        # is there ONLY one nil in this row? If so, it MUST be the value.
        c = this_row.select{|cell| cell.value == nil}
        if c.count == 1
          c.value = layer
        end
      end
    end

    def examine_column(index,layer)
      this_column = column(index)
      i = this_column.index{|cell| cell.value==layer}
      if !i.nil?
        (this_column-[this_column[i]]).each do |cell|
          cell.rule_out(layer)
        end
      else
        # is there ONLY one nil in this column? If so, it MUST be the value.
        c = this_column.select{|cell| cell.value == nil}
        if c.count == 1
          c.value = layer
        end
      end
    end

    def examine_zone(index,layer)
      this_zone = zone(index)
      i = this_zone.index{|cell| cell.value==layer}
      if !i.nil?
        (this_zone-[this_zone[i]]).each do |cell|
          cell.rule_out(layer)
        end
      else
        # is there ONLY one nil in this zone? If so, it MUST be the value.
        c = this_zone.select{|cell| cell.layer(layer) == nil}
        if c.count == 1
          c.first.value = layer
        end
      end
    end

    def to_csv
      ary_ary = (0..80).step(9).map do |n|
        cells[n..n+8]
      end
      csv_string = CSV.generate do |csv|
        ary_ary.each do |row|
          csv << row.map{|cell| cell.value? ? cell.value : '-'}
        end
      end
      csv_string
    end

    class InsufficientData < Exception
    end

    class SuperfluousData < Exception
    end

    class UnsolvablePuzzle < Exception
    end

    class InvalidPuzzle < Exception
    end

    private

    def parse(str)
      CSV.parse(str).flatten.map{|ch| ch=="-" ? nil : ch.to_i }
    end

    # the 'root index' of each zone
    def zone_indices
      [0,3,6,27,30,33,54,57,60]
    end
  end
end
