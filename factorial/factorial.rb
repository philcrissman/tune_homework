# memoizationing!
# also, completely misusing constants. I can live with it, in 
# this case.
FACTS = [0,1]

def factorial(n)
  raise "Factorial is only defined for nonnegative n" if n < 0
  if !FACTS[n]
    # let's be iterative to avoid stack overflows
    (FACTS.length..n).each do |i|
      FACTS[i] = i * FACTS[i-1]
    end
  end
  return FACTS[n]
end
