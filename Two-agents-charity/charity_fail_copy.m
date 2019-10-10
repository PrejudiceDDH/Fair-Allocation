function [output, assignment, loop] = charity_fail_copy(m, valuation)
valuation_1 = valuation(:,1)';
valuation_2 = valuation(:,2)';
sum1 = sum(valuation_1);
sum2 = sum(valuation_2);
valuation_ = [valuation_1/sum1 ; valuation_2/sum2]';

bundle_1 = zeros(m,1);
bundle_2 = zeros(m,1);
remaining = ones(m,1);

value_11 = valuation_1 * bundle_1;
value_12 = valuation_1 * bundle_2;
value_21 = valuation_2 * bundle_1;
value_22 = valuation_2 * bundle_2;

loop = 1;
stop = 0;

while loop < 50
%    [bundle_1, bundle_2]   
    loop
    valuation
    valuation_
    partial = [bundle_1, bundle_2]
%     value_11
%     value_12
%     value_21
%     value_22
    if remaining == zeros(m,1)
        break
    end
    % Value for the remaining item.
    value_1x = remaining .* (valuation_1)';
    value_2x = remaining .* (valuation_2)';
    [M1,pos1] = max(value_1x);
    [M2,pos2] = max(value_2x);
    
    if (value_11 >= value_12) && (value_22 >= value_21)
        % both agent 1 and 2 are sources
        [bool1, good1] = efx_feasibility(bundle_1, valuation_2, value_21,...
            value_22, value_1x);
        [bool2, good2] = efx_feasibility(bundle_2, valuation_1, value_12,...
            value_11, value_2x);
        if bool1 * bool2 == 1 % Add the larger.
            if value_11*sum2 < value_22*sum1
                bundle_1(good1) = 1;
                remaining(good1) = 0;
                value_11 = value_11 + valuation_1(good1);
                value_21 = value_21 + valuation_2(good1);
            elseif value_11*sum2 > value_22*sum1
                bundle_2(good2) = 1;
                remaining(good2) = 0;
                value_22 = value_22 + valuation_2(good2);
                value_12 = value_12 + valuation_1(good2);
            else
                [~,pos] = max([M1*sum2,M2*sum1]);
                if pos == 1
                    bundle_1(good1) = 1;
                    remaining(good1) = 0;
                    value_11 = value_11 + valuation_1(good1);
                    value_21 = value_21 + valuation_2(good1);
                else
                    bundle_2(good2) = 1;
                    remaining(good2) = 0;
                    value_22 = value_22 + valuation_2(good2);
                    value_12 = value_12 + valuation_1(good2);
                end
            end
        elseif bool1 == 1 && bool2 == 0 % add good to agent 1
            bundle_1(good1) = 1;
            remaining(good1) = 0;
            value_11 = value_11 + valuation_1(good1);
            value_21 = value_21 + valuation_2(good1);
        elseif bool2 == 1 && bool1 == 0
            bundle_2(good2) = 1;
            remaining(good2) = 0;
            value_22 = value_22 + valuation_2(good2);
            value_12 = value_12 + valuation_1(good2);
        else
            fprintf('Since two agents are both not EFX-Feasible\n')
            num = randi(2)
            if num == 1
                [agent,z, value_new] = most_envy(bundle_1, pos1,...
                    valuation_1, value_11, valuation_2, value_22);
                out = bundle_1 - z;
                out(pos1) = -1;
                remaining = out + remaining;
                if agent == 1 % represent itself
                    bundle_1 = z;
                    value_11 = value_new;
                    value_21 = valuation_2 * bundle_1;
                else
                    bundle_1 = bundle_2;
                    bundle_2 = z;
                    value_11 = value_12;
                    value_21 = value_22;
                    value_22 = value_new;
                    value_12 = valuation_1 * z;
                end
            else
                [agent,z, value_new] = most_envy(bundle_2, pos2,...
                    valuation_2, value_22, valuation_1, value_11);
                out = bundle_2 - z;
                out(pos2) = -1;
                remaining = out + remaining;
                if agent == 1 % represent itself
                    bundle_2 = z;
                    value_22 = value_new;
                    value_12 = valuation_1 * bundle_2;
                else
                    bundle_2 = bundle_1;
                    bundle_1 = z;
                    value_22 = value_21;
                    value_12 = value_11;
                    value_11 = value_new;
                    value_21 = valuation_2 * z;
                end
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
        % Since agent 2 envies agent 1, check whether agent 2 is feasible. 
        [bool, good] = efx_feasibility(bundle_2, valuation_1, value_12,...
            value_11, value_2x);
        if bool == 1
            bundle_2(good) = 1;
            remaining(good) = 0;
            value_22 = value_22 + valuation_2(good);
            value_12 = value_12 + valuation_1(good);
        else
            [agent, z, value_new] =  most_envy(bundle_2, pos2,...
                valuation_2, value_22, valuation_1, value_11);
                out = bundle_2 - z;
                out(pos2) = -1;
                remaining = out + remaining;
                if agent == 1
                    bundle_2 = z;
                    value_22 = value_new;
                    value_12 = valuation_1 * bundle_2;
                else
                    bundle_2 = bundle_1;
                    bundle_1 = z;
                    value_22 = value_21;
                    value_12 = value_11;
                    value_11 = value_new;
                    value_21 = valuation_2 * z;
                end
        end
        
    elseif (value_11 < value_12) && (value_22 >= value_21)
        [bool, good] = efx_feasibility(bundle_1, valuation_2, value_21,...
            value_22, value_1x);
        if bool == 1
            bundle_1(good) = 1;
            remaining(good) = 0;
            value_11 = value_11 + valuation_1(good);
            value_21 = value_21 + valuation_2(good);
        else
            [agent,z, value_new] = most_envy(bundle_1, pos1,...
                valuation_1, value_11, valuation_2, value_22);
            out = bundle_1 - z;
            out(pos1) = -1;
            remaining = out + remaining;
            if agent == 1
                bundle_1 = z;
                value_11 = value_new;
                value_21 = valuation_2 * bundle_1;
            else
                bundle_1 = bundle_2;
                bundle_2 = z;
                value_11 = value_12;
                value_21 = value_22;
                value_22 = value_new;
                value_12 = valuation_1 * z;
            end
        end
    end
loop = loop + 1;    
end

assignment = [bundle_1, bundle_2];
bool1 = check(bundle_1, valuation_1, bundle_2);
bool2 = check(bundle_2, valuation_2, bundle_1);
if bool1*bool2 == 1
    output = 1;
else
    output = 0;
end

end

function [output, good_index] = efx_feasibility(bundle_1, valuation_2, value_21,...
    value_22, value_1x)
% Assume agent 1 is a source, to check whether there is a good can be add
% to bundle_1 and preserve EFX from agent 2 to 1.
l = length(bundle_1);
non_zero = sum(value_1x > 0);
[~, i1] = sort(value_1x, 'descend'); % decreasing order
if bundle_1 == zeros(l,1)
    output = 1;
    good_index = i1(1);
    return
end

valuation_21 = bundle_1 .* (valuation_2)';
valuation_21(valuation_21 == 0) = NaN;
[m,~] = min(valuation_21);

output = 0;
for i = 1:non_zero
    ind = i1(i);
    if value_22 >= value_21 - m + valuation_2(ind)
        output = 1;
        break
    end
end

good_index = 0;
if output ~= 0
    good_index = ind;
end
end
    
function [output, z, value_new] = most_envy(bundle_1, good,...
    valuation_1, value_11, valuation_2, value_22)
% Assume a good is assigned to agent 1, and this function is to determine
% whether 1 or 2 is the most envy agent after adding this good.
% Output = 1 <--> it self envies most
% Output = 2 <--> the other agent envies most
% good is a index.
% value_new is the value of the value of agent who get the bundle z.
m = length(bundle_1);
bundle_1new = bundle_1;
bundle_1new(good) = 1;
valuation_11 = bundle_1new .* (valuation_1)';
[a1,i1] = sort(valuation_11, 'descend');
sum1 = 0;
index1 = 0;

for i = 1:m
    sum1 = sum1 + a1(i);
    if sum1 > value_11
        index1 = i;
        break
    end
end

valuation_21 = bundle_1new .* (valuation_2)';
[a2,i2] = sort(valuation_21, 'descend');
sum2 = 0;
index2 = 0;
for i = 1:m
    sum2 = sum2 + a2(i);
    if sum2 > value_22
        index2 = i;
        break
    end
end

z = zeros(m,1);
if index1 <= index2
    output = 1;
    index_item = i1(1:index1);
    z(index_item) = 1;
    value_new = sum1;
else
    output = 2;
    index_item = i2(1:index2);
    z(index_item) = 1;
    value_new = sum2;
end
end
