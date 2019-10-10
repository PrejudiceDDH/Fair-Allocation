function bool = check(bundle_1, valuation_1, bundle_2)
% To check whether a (partila) allocation is actually EFX
% Notice, we only check whether agent1 envies agent2 up to any good.
% Bool == 1 <-> agent 1 does not envy agent 2 up to any good.
value_11 = valuation_1 * bundle_1;
value_12 = valuation_1 * bundle_2;
if value_11 >= value_12
    bool = 1;
else
    valuation__1 = valuation_1 .* bundle_2';
    if value_11 + 10^(-8) >= value_12 - min(valuation__1(valuation__1>0))
        bool = 1;
    else
        bool = 0;
    end
end
end