function [bool, weight, sets_final] = test(time,m,n,k)
for i = 1:time
    [bool0, weight0, sets_final0] = main(m,n,k);
    if bool0 == 0
        bool = 0;
        weight = weight0;
        sets_final = sets_final0;
        return
    end
end
bool = 1;
weight = 0;
sets_final = 0;
end
