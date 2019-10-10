function [bool, weight, sets_final] = main(m, n, k)
% m goods, n agents
% generate and store their valuations first
w = zeros(k,n);
sets = zeros(k,m);
for i = 1:n
    [a, b] = submodular_func(m,k);
    w(:,i) = a;
    sets(:,:,i) = b;
end

% Then enumerate the assignment matrix
i = 0;
while i <= n^m-1 % All possible allocation ways.
    %creat a assignment matrix, each column correspond to the goods
    %received by the corresponding agent
    brake = 0;
    assignment_matrix = zeros(m,n);
    num_basen = dec2base(i,n); 
    len = length(num_basen);
    for j = 0 : len - 1
        num = num_basen(len-j);
        num_ = str2num(num);
        assignment_matrix(j+1, num_+1) = 1;
    end
    if len < m
        assignment_matrix(len+1:m, 1) = 1;
    end
    
    vector_sum = sum(assignment_matrix);
    if (vector_sum == 0) ~= zeros(1,n)
        i = i + 1;
        continue
    end

    bool = 0;
    for k = 1:n-1
        for j = k+1 : n
            if judge(assignment_matrix(:,[k,j]), w(:,k), sets(:,:,k), ... 
                    w(:,j), sets(:,:,j)) == 1
               continue
            else
                brake = 1;
                break
            end
        end
        if brake == 1
            break
        end
    end
    if brake == 1 % indicates this specific allocation does not work
        i = i+1;
        continue
    else
        % brake == 0, have find an EFX alloaction
        bool = 1;
        weight = 0;
        sets_final = 0;
        return
    end
end
bool = 0;
weight = w;
sets_final = sets;
end