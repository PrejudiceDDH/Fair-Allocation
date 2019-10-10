function [output, valuation, assignment, initial, loop] = test_charity(time,m, range)
output = 1;
valuation = zeros(m,2);
assignment = zeros(m,2);
initial = zeros(m,2);
loop = 0;

for i = 1:time
    [a,b,c,d,e] = charity_fail(m, range);
    if loop < e || a == 0
        valuation = c;
        assignment = d;
        initial = b;
        loop = e;
        if a == 0
            output = 0;
            return
        end
    end   
end
end