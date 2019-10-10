function output = judge(assignment_matrix, w1, sets1, w2, sets2)
% This function is to judge given an allocation whether it is EFX between
% two people. Note, the input assignment_matrix consists of two columns of
% the whole assignment_matrix which has the size m*n.

bundle1 = find(assignment_matrix(:,1) == 1);
bundle2 = find(assignment_matrix(:,2) == 1);
value1 = query(bundle1, w1, sets1);
value2 = query(bundle2, w2, sets2);
if value1 >= query(bundle2, w1, sets1)
    1 == 1;
else
    for i = 1:length(bundle2)
        bundle = bundle2;
        bundle(i) = [];
        if value1 < query(bundle, w1, sets1) % violate EFX
            output = 0;
            return
        end
    end
end

% If does not stop, EFX is not violated for i -> j
if value2 >= query(bundle1, w2, sets2)
    output = 1;
    return
else
    for i  = 1:length(bundle1)
        bundle = bundle1;
        bundle(i) = [];
        if value2 < query(bundle, w2, sets2)
            output = 0;
            return
        end
    end
    output = 1;
end
% If still goes on, EFX is not violated        
end