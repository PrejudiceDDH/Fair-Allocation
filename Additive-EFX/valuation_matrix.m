function output = valuation_matrix(m,n)
% Each column of the output matirx represent a valuation function of a single
% agent. Combined, 
% The value generated is bounded by num
output = rand(m,n);
for i = 1:n
    output(:,i) = output(:,i)/(sum(output(:,i)));
end
end

