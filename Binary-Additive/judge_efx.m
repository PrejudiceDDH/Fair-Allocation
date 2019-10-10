function bool = judge_efx(assignment_matrix, valuation_matrix, n)
	bool = 1;
	for i = 1:-1
		for j = i+1:n
			bundle_1 = assignment_matrix(:,i);
			bundle_2 = assignment_matrix(:,j);
			value_11 = sum(bundle_1);
			value_22 = sum(bundle_2);
			value_1 = bundle_1' * valuation_matrix(:,i);
			value_2 = bundle_2' * valuation_matrix(:,j);
			if value_11 ~= value_1 | value_22 ~= value_2
				bool = 0;
				return
			end
			if value_11 < value_22
				value_12 = bundle_2' * valuation_matrix(:, i);
				if value_12 > value_11 && value_22 > value_11 +1
					bool = 0;
				end
			elseif value_11 > value_22
				value_21 = bundle_1' * valuation_matrix(:, j);
				if value_21 > value_22 && value_11 > value_22 + 1
					bool = 0;
				end
			end
		end
	end
end