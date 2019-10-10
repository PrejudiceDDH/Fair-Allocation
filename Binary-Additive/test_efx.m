function [bool_final, assignment, ma] = test_efx(time,m,n)
bool_final = 1;
for i = 1:time
	ma = valuation_matrix(m,n);
	assignment = main(ma, 0);
	bool = judge_efx(assignment, ma, n);
	if bool == 0
		bool_final = bool;
		return
	end
end
assignment = zeros(m,n);
ma = zeros(m,n);
end