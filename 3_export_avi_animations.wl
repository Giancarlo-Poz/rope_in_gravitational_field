Get[NotebookDirectory[] <> "dataLightString.mx"]

step = 50;
frameRate = 60;

lData = Length@dataMix;
nSteps = Floor[lData/step];
nStepsTot = If[lData > step*nSteps, nSteps + 1, nSteps];
nDigits = Length@IntegerDigits[nSteps];

j = 22;
now = Now;
Do[
  Print["step ", j, "/", nStepsTot, 
   "   simulation" <> IntegerString[j, 10, nDigits] <> 
    ".avi   data=", {i, i + step - 1}];
  Export[
   NotebookDirectory[] <> "simulation" <> 
    IntegerString[j, 10, nDigits] <> ".avi", 
   dataMix[[i ;; i + step - 1]], FrameRate -> frameRate];
  
  elapsedTime = Now - now;
  remainingTime = (lData/(j*step) - 1)*elapsedTime;
  remainingHours = 
   Floor[QuantityMagnitude[UnitConvert[remainingTime, "Seconds"]]/
     3600];
  remainingMinutes = 
   Floor[1/60 (QuantityMagnitude[
        UnitConvert[remainingTime, "Seconds"]] - 3600*remainingHours)];
  finish = Now + remainingTime;
  
  Print[elapsedTime, " elapsed. Estimated ", remainingHours, "h ", 
   remainingMinutes, "m remaining, finishing at ", finish];
  Print[];
  
  j = j + 1,
  {i, (j - 1)*step + 1, step*nSteps, step}];

If[lData > step*nSteps,
  Print["step ", j, "/", nStepsTot, 
   "   simulation" <> IntegerString[j, 10, nDigits] <> 
    ".avi   data=", {step*nSteps + 1, lData}];
   Export[
   NotebookDirectory[] <> "simulation" <> 
    IntegerString[j, 10, nDigits] <> ".avi", 
   dataMix[[step*nSteps + 1 ;;]], FrameRate -> frameRate] ;
  Print["All done!"]
  ];
