function output = valuation_matrix(m,n)
% Each column of the output matirx represent a valuation function of a single
% agent. Combined, 
% The value generated is bounded by num
output = randi(0:1,m,n);
while ismember(0, sum(output, 2))
    output = randi(0:1, m,n);
end
end