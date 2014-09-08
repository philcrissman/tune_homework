require './test/test_helper'

describe SudokuPhilc::Grid do
  let :too_short_string do
    File.read('./test/too_short.csv')
  end

  let :too_long_string do
    File.read('./test/too_long.csv')
  end

  let :sudoku_string do
    File.read('./test/sudoku_string.csv')
  end

  let :sudoku_solved do
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 4, 5, 6, 7, 8, 9, 1, 2, 3, 7, 8, 9, 1, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 7, 8, 9, 1, 5, 6, 7, 8, 9, 1, 2, 3, 4, 8, 9, 1, 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7, 8, 9, 1, 2, 6, 7, 8, 9, 1, 2, 3, 4, 5, 9, 1, 2, 3, 4, 5, 6, 7, 8]
  end

  let :sudoku_string_real do
    File.read('./test/sudoku_string_real.csv')
  end

  let :sudoku_real_solved do
    [3, 6, 7, 4, 8, 5, 1, 2, 9, 1, 9, 5, 7, 2, 6, 8, 3, 4, 8, 4, 2, 9, 1, 3, 7, 5, 6, 6, 3, 9, 2, 7, 4, 5, 1, 8, 5, 2, 1, 6, 3, 8, 4, 9, 7, 4, 7, 8, 5, 9, 1, 3, 6, 2, 7, 5, 6, 1, 4, 9, 2, 8, 3, 2, 1, 3, 8, 6, 7, 9, 4, 5, 9, 8, 4, 3, 5, 2, 6, 7, 1]
  end

  let :sudoku_real_solved_string do
    "3,6,7,4,8,5,1,2,9\n1,9,5,7,2,6,8,3,4\n8,4,2,9,1,3,7,5,6\n6,3,9,2,7,4,5,1,8\n5,2,1,6,3,8,4,9,7\n4,7,8,5,9,1,3,6,2\n7,5,6,1,4,9,2,8,3\n2,1,3,8,6,7,9,4,5\n9,8,4,3,5,2,6,7,1\n"
  end

  let :sudoku_board do
    SudokuPhilc::Grid.new(sudoku_string)
  end

  describe "new" do
    it "should initialize a grid from a csv string" do
      grid = SudokuPhilc::Grid.new(sudoku_string)
      grid.is_a?(SudokuPhilc::Grid).must_equal true
    end

    it "should raise an error for insufficient data" do
      assert_raises SudokuPhilc::Grid::InsufficientData do
        SudokuPhilc::Grid.new(too_short_string)
      end
    end

    it "should raise an error for superfluous data" do
      assert_raises SudokuPhilc::Grid::SuperfluousData do
        SudokuPhilc::Grid.new(too_long_string)
      end
    end
  end

  it "should return the correct row of the table for a given row(index)" do
    sudoku_board.row(0).map(&:value).must_equal [1,2,3,false,5,6,7,8,9]
  end

  it "should return the correct column for a given column index" do
    sudoku_board.column(1).map(&:value).must_equal [2,false,8,3,6,9,4,7,1]
  end

  it "should return the correct zone for a given zone index" do
    sudoku_board.zone(2).map(&:value).must_equal [7,8,9,1,2,3,4,5,false]
  end

  it "should return the number of known values as #clues" do
    sudoku_board.clues.must_equal 72
  end

  describe "solve" do
    let :real_sudoku_board do
      SudokuPhilc::Grid.new(sudoku_string_real)
    end

    before do
      sudoku_board.solve
      real_sudoku_board.solve
    end

    it "should solve the puzzle" do
      sudoku_board.cells.map(&:value).must_equal sudoku_solved
      real_sudoku_board.cells.map(&:value).must_equal sudoku_real_solved
    end
  end

  describe 'to_csv' do
    it "should make a csv string of an unsolved board that looks exactly like the input string" do
      sudoku_board.to_csv.must_equal sudoku_string
    end

    it "should return the solved string too okay" do
      s = SudokuPhilc::Grid.new(sudoku_string_real)
      s.solve
      s.to_csv.must_equal sudoku_real_solved_string
    end
  end
end
