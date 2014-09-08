module SudokuPhilc
  class Cell
    attr_accessor :layers
    private :layers

    def initialize(n=nil)
      # n is the _value_ in the cell
      if !n.nil?
        raise SudokuPhilc::Cell::InvalidValue if (n<1) || (n>9)
        self.value = n
      else
        @layers = Array.new(9){ nil }
      end
    end

    def value
      layers.any?{|n| n.nil?} ? false : layers.index(true)+1
    end

    def value=(v)
      @layers = Array.new(9){false}
      layers[v-1] = true
    end

    def value?
      !!value
    end

    # for 'reasons', we're sure this cell != n
    def rule_out(n)
      layers[n-1]=false
    end

    # we need a way to check a particular layer's value
    def layer(val)
      layers[val-1]
    end

    # clarity returns an int.
    # the higher (9) the less clear it is what this cell should be.
    # A clarity of 0 means we know what this cell's value is.
    # should return the count of nils in the layers
    def clarity
      layers.select{|n| n==nil}.count
    end

    def possible_values
      layers.each_with_index.map{|e,i| i+1 if e==nil}.compact
    end

    def guess
      possible_values.sample
    end

    # check if we can 'know' what value this cell has; 
    # we 'know' if *every layer except one* is false
    def check
      # if there are 8 falses
      if value?
        true # this Cell has a value already
      elsif layers.select{|n| n==false}.count==8
        # the index that is still a nil must be true
        layers[layers.index(nil)] = true
        return true
      else
        # if we failed to find a value, we return false
        false
      end
    end

    class InvalidValue < Exception
    end
  end
end
