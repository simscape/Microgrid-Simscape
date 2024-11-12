function optimizationVariable = createOptimizationVariable(name,varLength,type,lowerBound,upperBound)
    
    % Copyright 2024 The MathWorks, Inc.
    
    % This function creates optimization variable for grid and creates the
    % necessary constraints for this optimization variable
    optimizationVariable = optimvar(name,varLength);
    optimizationVariable.Type = type;
    optimizationVariable.LowerBound = lowerBound;
    optimizationVariable.UpperBound = upperBound;
 end