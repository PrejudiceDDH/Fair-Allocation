function [bool_final, assignment, assignment_ly, lier, lied, ma] = ...
	test_truthful(time,m,n)
% This function is to test whether the algorithm is truthful.
bool_final = 1;
for i = 1:time
	ma = valuation_matrix(m,n);
	assignment = main(ma, 0);
	for j = 1:n % Everyone can be lier
		lier = j;
		value_true = assignment(:, j)' * ma(:, j);
		for k = 1:10
			[assignment_ly, value_ly, lied] = main(ma, j);
			if value_ly > value_true
				bool_final = 0;
				return
			end
		end
	end
end
end