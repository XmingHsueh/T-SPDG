% Author: Xiaoming Xue
% Email: cupseven@163.com
%
% ------------
% Description:
% ------------
% IsInter - This function is used to determine if there is interaction between 
%              the given variable and subcomponent.

function inter=IsInter(F_top,F_union,F_var,F_group,dim)
Fmax_inf = max(abs(F_top)+abs(F_union),abs(F_var)+abs(F_group));
Fmax = max([abs(F_top),abs(F_union),abs(F_var),abs(F_group)]);
muM = eps / 2;
gamma = @(n)((n.*muM)./(1-n.*muM));
errlb = gamma(2) * Fmax_inf;
errub = gamma(dim^0.5) * Fmax;
p = abs(F_top+F_union-F_var-F_group);
if abs(p-errlb) < abs(p-errub)
    inter=0;
else
    inter=2;
end