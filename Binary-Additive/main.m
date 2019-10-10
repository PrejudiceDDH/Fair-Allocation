function [assignment_matrix, value, lied] = main(valuation_matrix, lier)
% Valuatio_matrix is a randomly generated matrix, representing the
% valuation of agents towards the goods.
% lier is a index in [n], representing the person who would lie about his
% valuation.
% We simply index the agents and goods according to the valuation_matrix.
% Remark: ad_matrix(i,j) = 1 indicates i envies j. Assume there does not
% exist good liked by no one, i.e. g = zeros(1,n)

% liked is the goods truly liked by the lier. We do allocation under the 
% new valuation matrix.
[m,n] = size(valuation_matrix);
if lier ~= 0
    liked = valuation_matrix(:,lier);
    valuation_matrix(:,lier) = lying(valuation_matrix(:,lier));
    lied = valuation_matrix(:,lier);
end

value = 0;
layer = ones(n,1);               % Initialize the layer index.
ad_matrix = zeros(n,n);          % Initialize the adjacent matrix.
assignment_matrix = zeros(m,n);  % Initialize the assignment matrix

for k = 1:m
	% è¦??¾ä?ä¸???layer graphä¸???å·?ä¾§ç??ï¼?
	temp = layer .* valuation_matrix(k,:)';
	temp(temp == 0) = nan;
    [~, agent_ind] = min(temp);
    assignment_matrix(k, agent_ind) = 1;
   	layer_0 = layer(agent_ind); 
    bool = judge(layer, ad_matrix, layer_0, agent_ind);
    while bool == false
    	agents_left = layer < layer_0; % Column vector
    	goods_index = find(assignment_matrix(:, agent_ind) == 1);
    	% Notice, code here can be optimize.
        for l = 1:length(goods_index)
    		good = valuation_matrix(goods_index(l), :);
    		good * agents_left;
    		if good * agents_left > 0
    			good_index = goods_index(l);
    			break
    		end
    	end
    	assignment_matrix(good_index, agent_ind) = 0;
    	temp = layer .* valuation_matrix(good_index,:)';
    	temp(temp == 0) = nan;
    	[~, agent_ind] = min(temp);
    	assignment_matrix(good_index, agent_ind) = 1;
    	layer_0 = layer(agent_ind);
    	bool = judge(layer, ad_matrix, layer_0, agent_ind);
    end
    layer(agent_ind) = layer(agent_ind) +1;
    ad_matrix = update(assignment_matrix, valuation_matrix, m,n);
end

if lier ~= 0
	value = assignment_matrix(:,lier)' * liked;
end

end

function ad_matrix = update(assignment_matrix, valuation_matrix, m,n)
    ad_matrix = zeros(n,n);
	for i = 1:n-1
		for j = i+1:n
			bundle_1 = assignment_matrix(:,i);
			bundle_2 = assignment_matrix(:,j);
			value_11 = sum(bundle_1);
			value_22 = sum(bundle_2);
			if value_11 < value_22
				value_12 = bundle_2' * valuation_matrix(:, i);
				if value_12 > value_11
					ad_matrix(i,j) = 1;
				end
			elseif value_11 > value_22
				value_21 = bundle_1' * valuation_matrix(:, j);
				if value_21 > value_22
					ad_matrix(j,i) = 1;
				end
			end
		end
	end
end

function bool = judge(layer, ad_matrix, layer_0, agent_ind) 
% This function is to determine whether the partial allocation remains EFX
% after adding a good to a agent.
% Notice, we don't check the full EFX here, only check those 'possibly
% violated' part.
% layer is the n*1 list. layer_0 is a number.
if layer_0 == 1
    bool = true;
else
    agents = find(layer == layer_0 -1);
    if sum(ad_matrix(agents, agent_ind)) == 0 % no one envies agent_ind
        bool = true;
    else
        bool = false;
    end
end
end

function vector= lying(vector)
% vector = valuation_matrix(:, lier)
prop = rand(1);
for  k = 1:length(vector)
    if vector(k) == 1
        continue
    else
        r = rand(1);
        if r < prop
            vector(k) = 1;
        end
    end
end
end