% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "assignment4_1_3.dzn";


int: del_add;
int: del_mul;
int: number_add;
int: number_mul;
int : n; % number of operations
set of int : last;
set of int : add;
set of int : mul;
array[1..n] of set of int : dependencies;

% maximum delay between add and mul
int: del_max = max(del_add, del_mul);
% maximum number of resources used
int: number_max = max(number_add, number_mul);
array[1..n] of int: delay = [ if x in add then del_add else del_mul endif  | x in 1..n];

array[1..n] of var 0..n*del_max: start_time;
array[1..n] of var 1..number_max: resource;
var int : optimal_length;

constraint forall(i in 1..n, j in dependencies[i])(start_time[i] + delay[i] <= start_time[j]);
constraint forall(i in last)(start_time[i] + delay[i] <= optimal_length);

constraint cumulative([start_time[i] | i in add],[del_add | i in add], [1 | i in add], number_add);
constraint cumulative([start_time[i] | i in mul],[del_mul | i in mul], [1 | i in mul], number_mul);

constraint diff2([start_time[i] | i in add], [resource[i] | i in add], [del_add | i in add], [1 | i in add]);
constraint diff2([start_time[i] | i in mul], [resource[i] | i in mul], [del_mul | i in mul], [1 | i in mul]);

solve ::  int_search(start_time, smallest, indomain_min) minimize optimal_length;

output [ "Optimal schedule length = ",show(optimal_length)++ 
"\nmul1: " ++ show(sum([resource[i] | i in mul where resource[i] == 1]))++
"\nmul2: " ++ show(sum([resource[i] | i in mul where resource[i] == 2])) ++ 
"\nmul3: " ++ show(sum([resource[i] | i in mul where resource[i] == 3])) ++
"\nmul4: " ++ show(sum([resource[i] | i in mul where resource[i] == 4])) ++
"\nadder1: " ++ show(sum([resource[i] | i in add where resource[i] == 1])) ++ 
"\nadder2: " ++ show(sum([resource[i] | i in add where resource[i] == 2]))];