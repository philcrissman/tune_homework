#!/usr/bin/env ruby

require 'debugger'

sudoku_string = ""

STDIN.read.split("\n").each do |line|
  sudoku_string << (line + "\n") 
end

# we have a string. Let's make... an array of arrays, maybe?

sudoku_array = sudoku_string.split("\n").map{|line| [line.split(',')]}
debugger

puts sudoku_array.join(" ")
