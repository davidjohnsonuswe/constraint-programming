include "globals.mzn";
include "urban_1.dzn";

% row/column lenght
int: n;
% number of commercial lots in the area
int: n_commercial;
% number of residential lots in the area
int: n_residential;
array[1..n+1] of int: point_distribution;
% nxn array where we place the commercial lots = 0 and the residental lots = 1
array[1..n, 1..n] of var 0..1 : grid;
% array to compute points for each row/column
array[1..n*2] of var int : points = [point_distribution[computeSum(i, grid)] | i in 1..n*2];

% define a predicate to compute the sum
function var int: computeSum(int: i, array[1..n, 1..n] of var 0..1: grid) =
  sum(j in 1..n) (if i <= n then grid[i, j] else grid[j, i - n] endif) + 1;

% lex2 is used to break symmetries
constraint lex2(grid);
% make sure that all the lots are filled properly
constraint sum(grid) = n_residential;

solve maximize sum(points);

output["Total point = ", show(sum(points)), "\nGrid = ", show(grid), "\nPoints = ", show(points)];