% Author: Xiaoming Xue
% Email: cupseven@163.com
%
% ------------
% Description:
% ------------
% RecursiveIdentification - This function is used to identify the interacted subcomponents
%                    for given variable.

function [SubID_Inter, FEsc] = RecursiveIdentification(fun, VarID, Subcoms, Series, F_base, F_VarPer, options, FEsc)
SubID_Inter = [];
dim = options.dim;
lb = options.lbound;
ub = options.ubound;

SubID = [];
for i=1:length(Series)
    SubID = [SubID Subcoms{Series(i)}];
end
x_pers = lb;
x_pers(SubID) = ub(SubID);
F_SubPer = fun(x_pers');
x_peru = lb;
x_peru([VarID,SubID]) = ub([VarID,SubID]);
F_UnionPer = fun(x_peru');
if length(Series)==1
    FEsc = FEsc+1;
else
    FEsc = FEsc+2;
end

xi = IsInter(F_base,F_UnionPer,F_VarPer,F_SubPer,dim);

if xi > 1
    if length(Series) == 1
        SubID_Inter = [SubID_Inter Series];
    else
        k = floor(length(Series)/2);
        Series_1 = Series(1:k);
        Series_2 = Series(k+1:end);
        [SubID_Inter_1,FEsc] = RecursiveIdentification(fun, VarID, Subcoms, Series_1, F_base, F_VarPer, options, FEsc);
        [SubID_Inter_2,FEsc] = RecursiveIdentification(fun, VarID, Subcoms, Series_2, F_base, F_VarPer, options, FEsc);
        SubID_Inter = [SubID_Inter_1 SubID_Inter_2];
    end
end