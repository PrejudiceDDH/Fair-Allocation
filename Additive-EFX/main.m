function bool_final = main(m, n)
valuation = valuation_matrix(m,n);
% Then enumerate the assignment matrix
i = 0;
while i <= n^m-1
    assignment_matrix = zeros(m,n);
    num_basen = dec2base(i,n); 
    len = length(num_basen);
    for j = 0 : m-1
        if j <= len - 1
            assignment_matrix(j+1, num_basen(len-j)+1) = 1;
        else
            assignment_matrix(j+1, 1) = 1;
        end
    end
    bool = judge(assignment_matrix, valuation);
    if bool == 1
        bool_final = bool;
        return
    else
        continue
    end
    i = i+1
end
bool_final = 0;
end