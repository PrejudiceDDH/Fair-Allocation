function bool = judge(assignment_matrix, val_matrix)
% to judge whether a given assignment satisfys the EFX condition.
% assignment_matrix is indexed by: row - item, column - agent.
[m,n] = size(val_matrix);
valuation = zeros(n,n); % (i,j) entry represents the valuation of i on j's goods
for i = 1:n
    for j = 1:n
        valuation(i,j) = sum(assignment_matrix(:,j) .* val_matrix(:,i));
    end
end

for i = 1:n % simply judge whether this assignment worth enumeration.
    [a,b] = max(valuation(i,:)-valuation(i,i));
    if a == 0
        continue
    end
    if a > max(val_matrix(:,i))
        bool = 0;
        return
    end
end

for i = 1 : n % check if i envys j up to any item
    for j = 1 : n
       if i == j || valuation(i,i) >= valuation(i,j)
           continue
       elseif valuation(i,i) < valuation(i,j) - min(assignment_matrix(:,j) .* val_matrix(:,i))
           bool = 0;
           return
       end 
    end
end
bool = 1;
end