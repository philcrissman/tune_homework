# SudokuPhilc

So, it will solve sudoku's.

## Installation

Though this is setup like a gem, I didn't push it to Rubygems; so you can't `gem install sudoku_philc`. :-(

You may need to build and install locally: this can be done with:

```
be rake build
be rake install
```


## Usage

Per the spec, the executable will read from STDIN. On a `*nix`-like system, that means you should be able to either:

```
cat your_sample_sudoku.csv | ./bin/sudoku
```
or

```
./bin/sudoku < your_sample_sudoku.csv
```
.

### The Algorithm

I got the basic idea from [this article](http://plus.maths.org/content/chaos-sudoku)[^1]. 

The idea is to imagine each cell as an array of 9 elements, each of which is true or false. A new Cell is initialized with all `nil` elements; each time a value is ruled out for a cell, the corresponding index is set to `false`. If we ever discover that a cell *must* be a certain value, the corresponding index is set to `true`. This allows for an algorithm without any backtracking, simply iterating over the puzzle to find new clues. 

If at any point we stop making 'progress' (no new clues can be found), then the puzzle is either solved, or, if it is still incomplete, unsolveable. We exit the loop and either raise an unsolveable exception, or return `true` if the puzzle is solved.

[^1]: Though I didn't implement anything like the chaos/spin which was discussed; only used the same basic data structure.

### Performance

Solving Sudoku puzzles is an NP problem; how long this algorithm takes will be based mainly on `n`, where `n` is the number of _blank squares in the puzzle_. Related, but harder to quantify, is how many clues there are at the beginning; that is, how many cells the algorithm can decide upon in the first iteration. The more it fills in, the quicker it ought to be able to fill in the rest of the puzzle, as the more cells that are decided, the more clues we have to rule out values and/or decide other values.

Specifically looking at the `solve` method: it will do _at least_ 81 comparisons/actions, multiplied by some constant, and again by how many iterations of this it needs to do before it stops making progress. Since Big-O tosses out constants, I feel like this is still close-ish to O(n), `n` being the number of empty spaces, and some function of how few 'clues' exist to decide the empty squares.

### Problems

At the eleventh hour, I decided to try this algorithm against a problem that http://websudoku.com categorizes as "evil" (see test/sudoku_evil.csv). The algorithm fails to find a solutions, categorizing this problem as "unsolveable" because it's unable to make progress. This is clearly a significant problem with this algorithm. Right now, I'm going to leave the algorithm as it is and instead discuss why I believe this happens and how the algorithm would need to change to meet this.

This is happening, I believe, because I approached the suduku solving problem in the same way I approach the puzzles manually; deterministically, trying not to make any "guesses". So this algorithm will fly on any puzzle of medium to maybe hard difficulty, where each step is 100% deterministic, without requiring any guessing or backtracking. In order to solve the harder puzzles, I would need to introduce some sort of guessing/backtracking, or dig deeper into what algorithm they were using (which seems to be based on differential equations). Despite the problems this will have with the hardest sudoku puzzles, I'm still pretty happy with the performance and the general algorithm. In testing, it solves up to "hard" puzzles in under a second.
