% Solution by Johan Åkerman (jo3460ak-s@student.lu.se). FYI: On my computer the code runs the fastsest by using Gecode :)

include "globals.mzn";
include "urban_1.dzn";

% Import data
par int: n; 
par int: n_commercial; 
par int: n_residential; 
array[1..n+1] of int: point_distribution; % FYI: index is # of residential lots in the row/column which can be between 0 and n, hence 1..n+1. 


% Generate a 2d array to represent lots. A lot can be commercial (1) or residential (2).
array[1..n, 1..n] of var 1..2: lots; 


% Calculates the number of commercial and residential lots, and constraint that they equal n_commercial and n_residential. 
var int: numberOfCommercial = sum(row in 1..n)(sum(col in 1..n)(lots[row,col] == 1));
var int: numberOfResidential = sum(row in 1..n)(sum(col in 1..n)(lots[row,col] == 2));
constraint numberOfCommercial == n_commercial /\ numberOfResidential == n_residential;


% Count # of residentials in each row/column and calculate their score based on the point_distribution.
var int: row_points = sum(row in 1..n)(point_distribution[1 + sum(col in 1..n where lots[row, col] == 2)(1)]);
var int: col_points = sum(col in 1..n)(point_distribution[1 + sum(row in 1..n where lots[row, col] == 2)(1)]);
var int: max_points = row_points + col_points;


% Break symmetry by utilizing lexicorgraphical order to define a total order on solutions.
constraint lex2(lots);


% Solve problem and maximize max_points.
solve maximize max_points;


% Output prints
output["Generated lots: " ++ "\n"];
output [if col == n+1 then "\n" else show(lots[row, col]) ++ " " endif | row in 1..n, col in 1..n+1] ++ ["\n"];
output["Max points: " ++ show(max_points) ++ "\n"];