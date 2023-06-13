function [factory] = shoppingPlan(feeling)


if feeling == 1
    factory = 'Louis Vuitton';
elseif feeling == 2
    factory = 'Chanel';
elseif feeling == 3
    factory = 'Apple';
else
    factory = 'Gucci';
end


end