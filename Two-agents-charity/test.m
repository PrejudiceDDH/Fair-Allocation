function [output, valuation, assignment, initial, loop] = test(time,m)
output = 1;
valuation = zeros(m,2);
assignment = zeros(m,2);
initial = zeros(m,2);
loop = 0;
for i = 1:time
    [a,b,c,d,e] = main(m);
    loop = max([e,loop]);
    if loop == e
        valuation = a;
        assignment = b;
        initial = d;
        if e >= 20
            return
        end
    end
    if c == 0
        output = 0;
        valuation = a;
        assignment = b;
        initial = d;
        return
    end
end
end
