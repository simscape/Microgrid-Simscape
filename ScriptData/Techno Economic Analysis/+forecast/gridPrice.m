function priceGrid = gridPrice(years)
% Copyright 2024 The MathWorks, Inc.

% This function calculates the grid price

load gridPriceData.mat;
priceGrid = priceData;
priceGrid = repmat(priceGrid,years,1);
end

