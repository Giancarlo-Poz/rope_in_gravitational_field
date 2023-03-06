(* set parameters *)

dim = 2;
pt = 300;
timeSimulation = 400;

k = 10000;
g = 1;

Table[m[i], {i, 1/dim Length[variablesFunc]}];
Set[#, 1] & /@ %;


variablesFunc = 
  Flatten[Table[{x[i], y[i]}, {i, 
     pt}]]; (* pure function unknowns incognite *)
variables = 
  Apply[#, {t}] & /@ variablesFunc; (* unknowns depending on time *)


(* functions *)
distq[a_, b_] := (a[[1]] - b[[1]])^2 + (a[[2]] - b[[2]])^2
dist[a_, b_] := Sqrt[(a[[1]] - b[[1]])^2 + (a[[2]] - b[[2]])^2]

(* kinetic energy *)
T = 1/2 Sum[
    m[i] (D[x[i][t], t]^2 + D[y[i][t], t]^2), {i, 
     1/dim Length[variablesFunc]}];

(* potential energy *)
U = 1/2 k (dist[{x[1][t], y[1][t]}, {0, 0}] - 
      1)^2 +(*elastic potential first point*)
  1/2 k Sum[(dist[{x[i + 1][t], y[i + 1][t]}, {x[i][t], y[i][t]}] - 
       1)^2, {i, 
     1/dim Length[variablesFunc] - 
      1}] +(*elastic potential all other points*)
  50 k Sum[(Sqrt[(-x[i][t] + x[1 + i][t])^2 + (-y[i][t] + 
            y[1 + i][t])^2] - 
       Sqrt[(-x[i][t] + x[2 + i][t])^2 + (-y[i][t] + y[2 + i][t])^2] +
        Sqrt[(-x[1 + i][t] + x[2 + i][t])^2 + (-y[1 + i][t] + 
            y[2 + i][t])^2])^2, {i, 
     1/dim Length[variablesFunc] - 
      2}] +(*simple potential against bending:
  3 consecutive points tent to be aligned as in a flat triangle:d1+d2~
  d3*)Sum[m[i] g y[i][t], {i, 
    1/dim Length[variablesFunc]}];(*gravitational potential*)L = T - U;

(* add friction: potential given by a non conservative force that depends on the \
speed *)
R1 = 1/300 Sum[(x[i]'[t])^2 + (y[i]'[t])^2, {i, 
     1/dim Length[variablesFunc]}];
R2 = 1/4 Sum[(x[i]'[t] - x[i + 1]'[t])^2 + (y[i]'[t] - 
        y[i + 1]'[t])^2, {i, 
     1/dim Length[variablesFunc] - 
      1}];(*speeds of points next to each other tend to be similar*)
R = R1 + R2;

(* Euler-Lagrange equations *without* non-conservative forces
eq = D[D[L, D[#, t]], t] - D[L, #] == 0 & /@ variables *)

(* Euler-Lagrange equations *with* non-conservative forces *)
eq = D[D[L, D[#, t]], t] - D[L, #] + D[R, D[#, t]] == 0 & /@ variables;


(* add velocity unknows x'[t], y'[t] *)
D[#, t] & /@ variables;
var = Join[variables, %];


(* note: since the distance between poins is 1, the coefficient respect \
Sqrt[(1/2)^2+(Sqrt[3]/2)^2]= 1 *)
condiz = 
  Thread[(var /. t -> 0) == 
    Join[Riffle[1/2 Range[pt], Sqrt[3]/2 Range[pt]], 
     ConstantArray[0, 2 pt]]];


equaz = Join[eq, condiz];

AbsoluteTiming[
 sol = NDSolve[equaz, variablesFunc, {t, 0, timeSimulation}, 
    MaxSteps -> \[Infinity]];]
Beep[]

DumpSave[NotebookDirectory[] <> "solutionsLightString.mx", sol];
