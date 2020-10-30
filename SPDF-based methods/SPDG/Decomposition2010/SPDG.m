% Author: Xiaoming Xue
% Email: cupseven@163.com
%
% ------------
% Description:
% ------------
% SPDG - This function runs the single-pool differential grouping procedure
 %            to identify the subcomponents in cec'2010 benchmark problems.
%
% -------
% Inputs:
% -------
%    fun        : the function suite for which the interaction structure 
%                 is going to be identified in this case benchmark_func 
%                 of cec'2010.
%
%    options    : this variable contains the options such as problem
%                 dimensionality, upper and lower bounds.
%
% --------
% Outputs:
% --------
%    Subcoms       : a cell array containing all non-separable subcomponents.
%    FEs        : the total number of fitness evaluations used.

function [Subcoms, FEs] = SPDG(fun, options)

dim = options.dim;
lb = options.lbound;
ub = options.ubound;
FEs = 0;
Subcoms = cell(1,1);
Subcoms{1}(1) = 1;
F_base = fun(lb');
FEs = FEs +2;


for i=2:dim
    x_perv = lb;x_perv(i) = ub(i);
    F_VarPer = fun(x_perv');
    FEs = FEs+1;
    Series = 1:length(Subcoms);
    [SubID, FEsc] = RecursiveIdentification(fun, i, Subcoms, Series, F_base, F_VarPer, options, 0);
    FEs = FEs+FEsc;
    if isempty(SubID)
        SubNum = length(Subcoms);
        Subcoms{SubNum+1}(1) = i;
    else
        SubMerge = i;
        SubNew = cell(1,1);
        t = 1;
        for j = 1:length(Subcoms)
            if find(j == SubID)
                SubMerge = [SubMerge Subcoms{j}];
            else
                SubNew{t} = Subcoms{j};
                t=t+1;
            end
        end
        SubNew{t} = SubMerge;
        Subcoms = SubNew;
        if i~=dim
            FEs = FEs+1;
        end
    end
end