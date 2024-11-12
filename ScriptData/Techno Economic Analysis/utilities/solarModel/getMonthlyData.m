function monthlyData = getMonthlyData(data)
    % Check the length of the data vector
    totalHours = length(data);
    
    % Ensure the data is for a non-leap year
    if mod(totalHours, 8760) ~= 0
        error('The data should be for a non-leap year with 8760 hours.');
    end
    
    % Calculate the number of years in the data
    numYears = totalHours / 8760;
    
    % Define the number of days in each month for a non-leap year
    daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    hoursInMonth = daysInMonth * 24; % Convert days to hours
    
    % Initialize the cell array to hold monthly data
    monthlyData = cell(12, numYears);
    
    % Loop over each year
    for yearIdx = 1:numYears
        % Calculate the start and end indices for each month
        startIdx = (yearIdx - 1) * 8760 + 1;
        for month = 1:12
            endIdx = startIdx + hoursInMonth(month) - 1;
            
            % Extract the data for the current month
            monthlyData{month, yearIdx} = data(startIdx:endIdx);
            
            % Update the start index for the next month
            startIdx = endIdx + 1;
        end
    end
end