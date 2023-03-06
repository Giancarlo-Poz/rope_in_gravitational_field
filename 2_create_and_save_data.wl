
(*** CREATE DATA FOR THE ANIMATION ***)

(* read solution and set variables according to previous file *)
Get[NotebookDirectory[] <> "solutionsLightString.mx"]

MapThread[
  Set, {Table[{xs[i], ys[i]}, {i, 1/dim Length[incpf]}], 
   Table[({x[i], y[i]} /. sol)[[1]], {i, 1/dim Length[incpf]}]}];
   
dim = 2;
pt = 300;
timeSimulation = 400;

incpf = Flatten[Table[{x[i], y[i]}, {i, pt}]]; 
MapThread[
  Set, {Table[{xs[i], ys[i]}, {i, 1/dim Length[incpf]}], 
   Table[({x[i], y[i]} /. sol)[[1]], {i, 1/dim Length[incpf]}]}];


xMin = MinValue[{xs[pt][t], 0 < t < timeSimulation}, t];
xMax = MaxValue[{xs[pt][t], 0 < t < timeSimulation}, t];
yMin = MinValue[{ys[pt][t], 0 < t < timeSimulation}, t];
yMax = MaxValue[{ys[pt][t], 0 < t < timeSimulation}, t];

pRangeY = {yMin - Abs[yMin/5], yMax + Abs[yMax/5]};
pRangeX = {-((pRangeY[[2]] - pRangeY[[1]])/2), (pRangeY[[2]] - 
       pRangeY[[1]])/2}*16/9;
pRange = {pRangeX, pRangeY};


frames = 
  Join[Table[t, {t, 0, timeSimulation, 2.5}], 
   Table[t, {t, 0, 27.5, 2.5}], Table[t, {t, 28, 29, 0.5}], 
   Table[t, {t, 29.1, 30, 0.1}], Table[t, {t, 30.04, 31, 0.02}], 
   Table[t, {t, 31.1, 43, 0.1}], Table[t, {t, 43.5, 52.3, 0.8}], 
   Table[t, {t, 52.3, 60.4, 0.3}], Table[t, {t, 60.5, 69.1, 0.1}], 
   Table[t, {t, 70, 76, 0.5}], Table[t, {t, 76.3, 86.5, 0.1}], 
   Table[t, {t, 86.8, 92.8, 0.5}], Table[t, {t, 93.1, 101, 0.1}], 
   Table[t, {t, 101.2, 120.7, 0.5}], Table[t, {t, 121, 133, 0.1}], 
   Table[t, {t, 133.2, 170.7, 0.5}], Table[t, {t, 171, 176, 0.1}], 
   Table[t, {t, 176.3, 244, 0.5}], 
   Table[t, {t, 245.5, timeSimulation, 2.5}]];

frames = DeleteCases[frames, x_ /; x > timeSimulation];

dataMix = Table[ListPlot[
    {{0, 0}, {0, 0}, 
     Table[{i, yMin - Abs[yMin/5]}, {i, pRangeX[[1]], pRangeX[[2]], 
       5}], Table[{xs[i][t], ys[i][t]}, {i, 1/dim Length[incpf]}], 
     Table[{xs[i][t], ys[i][t]}, {i, 1, 1/dim Length[incpf], 3}]},
    PlotStyle -> {{Red, PointSize[0.05]}, {Blue, 
       PointSize[0.01]}, {Brown, PointSize[0.04]}, {Green, 
       PointSize[0.006]}, {Black, PointSize[0.0025]}},
     PlotRange -> pRange, PlotMarkers -> None, AxesOrigin -> {0, -0}, 
    AspectRatio -> 9/16, Axes -> False, ImageSize -> 2560], {t, 
    frames}];

DumpSave[NotebookDirectory[] <> "dataLightString.mx", dataMix];
