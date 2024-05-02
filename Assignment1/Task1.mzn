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

% Maximize the number of satisfied preferences
var int: max_prefs = sum(i in 1..n_prefs)(dists[i] == 1);
solve maximize max_prefs;

output [show(placement), "Max Satisfied Preferences: ", show(max_prefs)];
