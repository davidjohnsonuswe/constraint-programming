include "globals.mzn";
int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of int: prefs;
array[1..n] of var 1..n: placement;

% Calculate distances between people
array[1..n_prefs] of var int: dists;
constraint forall(i in 1..n_prefs)(
    dists[i] = abs(placement[prefs[i, 1]] - placement[prefs[i, 2]])
);

% Ensure all positions are different
constraint alldifferent(placement);

% Minimise the longest distance
solve minimize max(dists);

output [show(placement), "Max Distance: ", show(max(dists))];
