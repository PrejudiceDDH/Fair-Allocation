function [valuation, assignment, output, initial, loop] = main(m)
% Generate additive valuation, which is a row vector
valuation_1 = randi(1000, 1, m);
valuation_2 = randi(1000, 1, m);
initial = [valuation_1;valuation_2]';
sum1 = sum(valuation_1);
sum2 = sum(valuation_2);
valuation = [valuation_1/sum1 ; valuation_2/sum2]';

bundle_1 = zeros(m,1);
bundle_2 = zeros(m,1);
remaining = ones(m,1);

% Initialize the value, which is 0 right now.
% Notice that we stop using regularized valuation.
value_11 = valuation_1 * bundle_1;
value_12 = valuation_1 * bundle_2;
value_21 = valuation_2 * bundle_1;
value_22 = valuation_2 * bundle_2;

loop = 0;
stop = 0;

while (stop == 0) && (loop < 1000)
    loop = loop + 1;
    % Value for the remaining item.
    value_1x = remaining .* (valuation_1)';
    value_2x = remaining .* (valuation_2)';
    [M1,pos1] = max(value_1x);
    [M2,pos2] = max(value_2x);
    
    if (value_11 >= value_12) && (value_22 >= value_21)
        if value_11*sum2 < value_22*sum1
            bundle_1(pos1) = 1;
            remaining(pos1) = 0;
            value_11 = value_11 + M1;
            value_21 = value_21 + valuation_2(pos1);
        elseif value_11*sum2 > value_22*sum1
            bundle_2(pos2) = 1;
            remaining(pos2) = 0;
            value_22 = value_22 + M2;
            value_12 = value_12 + valuation_1(pos2);
        else
            [~,pos] = max([M1*sum2,M2*sum1]);
            if pos == 1
                bundle_1(pos1) = 1;
                remaining(pos1) = 0;
                value_11 = value_11 + M1;
                value_21 = value_21 + valuation_2(pos1);
            else
                bundle_2(pos2) = 1;
                remaining(pos2) = 0;
                value_22 = value_22 + M2;
                value_12 = value_12 + valuation_1(pos2);
            end
        end
        
    elseif (value_11 < value_12) && (value_22 < value_21)
        % Exchange their bundles
        bundle = [bundle_1, bundle_2];
        bundle_1 = bundle(:,2);
        bundle_2 = bundle(:,1);
        value = [value_11, value_12; value_21, value_22];
        value_11 = value(1,2);
        value_22 = value(2,1);
        value_12 = value(1,1);
        value_21 = value(2,2);
        
    elseif (value_11 >= value_12) && (value_22 < value_21)
        % Since agent 2 envies agent 1, check whether EFX. Noticed that, if
        % bool == 0, we do not add good to bundle 2.
        bool = check(bundle_2, valuation_2, bundle_1);
        if bool == 1
            bundle_2(pos2) = 1;
            remaining(pos2) = 0;
            value_22  = value_22 + M2;
            value_12 = value_12 + valuation_1(pos2);
        else 
            % Which means EFX is violated, should run the take_out
            [bundle__1, out, value__11, value__21] = take_out(bundle_1, ...
                valuation_1, value_11, value_12, bundle_2, valuation_2,...
                value_21);
            remaining = remaining + out;
            bundle_1 = bundle__1;
            value_11 = value__11;
            value_21 = value__21;
        end
        
    elseif (value_11 < value_12) && (value_22 >= value_21)
        bool = check(bundle_1, valuation_1, bundle_2);
        if bool == 1
            bundle_1(pos1) = 1;
            remaining(pos1) = 0;
            value_11 = value_11 + M1;
            value_21 = value_21 + valuation_2(pos1);
        else
            [bundle__2, out, value__22, value__12] = take_out(bundle_2, ...
                valuation_2, value_22, value_21, bundle_1, valuation_1,...
                value_12);
            remaining = remaining + out;
            bundle_2 = bundle__2;
            value_22 = value__22;
            value_12 = value__12;
        end     
    end
    if sum(remaining) == 0
        bool1 = check(bundle_1, valuation_1, bundle_2);
        bool2 = check(bundle_2, valuation_2, bundle_1);
        if bool1 * bool2 == 1
            stop = 1;
        end
    end 
end

assignment = [bundle_1, bundle_2];
if loop < 100000
    output = 1;
else
    output = 0;
end
end

function [a,b,c,d] = take_out(bundle_1, valuation_1, value_11, value_12,...
    bundle_2, valuation_2, value_21)
% a, b correspond to bundle_1, taken out goods. c,d = value_11, value_21
% The current state is: agent 1 does not envy agent 2, agent 2 envy agent
% 1 up to any item.
valuation_21 = valuation_2 .* (bundle_1)';
envy_12 = 0;
k = length(bundle_1);
out = zeros(k,1);

while envy_12 == 0
    valuation_21 = valuation_2 .* (bundle_1)';
    valuation_21(valuation_21 == 0) = NaN;
    [m, pos] = min(valuation_21);
    bundle_1(pos) = 0;
    out(pos) = 1;
    value_11 = value_11 - valuation_1(pos);
    value_21 = value_21 - m;
    bool = check(bundle_2, valuation_2, bundle_1);
    if bool == 1 % which indicates achieve EFX after taking out this item
        break
    end
    if value_11 < value_12
        envy_12 = 1;
    end
end
% only when EFX is achieved or there exists envy from agent 1 to agent 2
% will the loop be terminated.
a = bundle_1;
b = out;
c = value_11;
d = value_21;
end