function [reward ] = playrewards(offer)



if offer < 10
    disp('Sorry you have not made the minimum bet');
    reward = 0; 
    return
else
    reward = offer * 10; %10 points per bet offer 
end