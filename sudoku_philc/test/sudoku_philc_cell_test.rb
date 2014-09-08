require './test/test_helper'

describe SudokuPhilc::Cell do

  let :empty_cell do
    SudokuPhilc::Cell.new
  end

  let :cell_with_value do
    SudokuPhilc::Cell.new(5)
  end


  it "should initialize with no value if none provided" do
    empty_cell.value.must_equal false
  end

  it "should initialize with a value if one is provided" do
    cell_with_value.value.must_equal 5
  end

  it "should raise an error if you try to assign a negative integer" do
    assert_raises SudokuPhilc::Cell::InvalidValue do
      SudokuPhilc::Cell.new(-4)
    end
  end

  it "should raise an error if you try to assign an integer greater than 9" do
    assert_raises SudokuPhilc::Cell::InvalidValue do
      SudokuPhilc::Cell.new(12)
    end
  end

  it "should let you set the value" do
    empty_cell.value = 6
    empty_cell.value.must_equal 6
  end

  it "should return false if a cell has no value" do
    empty_cell.value?.must_equal false
  end

  # so: index 0 would indicate a value of 1; etc.
  it "should set a specific 'layer' to false if we rule out that value" do
    empty_cell.rule_out(5)
    empty_cell.send(:layers)[4].must_equal false
  end

  describe "check" do

    let :almost_solved_cell do
      c = SudokuPhilc::Cell.new
      (1..8).each{|n| c.rule_out(n)}
      c
    end

    it "should return true for cells with a value" do
      cell_with_value.check.must_equal true
    end

    it "should return false for cells with an unknown value" do
      empty_cell.rule_out(5)
      empty_cell.check.must_equal false
    end

    it "should return true if checking provided a value" do
      almost_solved_cell.check.must_equal true

    end

    it "should set the value if checking provided a value" do
      almost_solved_cell.check
      almost_solved_cell.value.must_equal 9
    end
  end


end
