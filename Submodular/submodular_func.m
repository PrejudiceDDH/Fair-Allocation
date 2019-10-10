function [w, sets] = submodular_func(m,k)
% Generate weighted coverage function, and use query to get the function
% value. k is the size of the 'universe', k should be large
% First, generate a weight function.
w = randi(1000,k,1)/1000;
% This sets matrix is used to generate the m sets.
sets = zeros(k,m); 
% Use a loop to generate m arbitrary sets used in coverage function
for i = 1:m
    % First, choose a n that is not usually large
    n1 = randi([1,round(k/2)]);
    n2 = randi([round(k/2),k]);
    if rand(1) < 1/m
        n = n2;
    else
        n = n1;
    end
   % Choose a subset whose size is n in expectation
   n = n/k;
    for j = 1:k
        if rand(1) < n
            sets(j,i) = 1;
        end
    end
end
end
