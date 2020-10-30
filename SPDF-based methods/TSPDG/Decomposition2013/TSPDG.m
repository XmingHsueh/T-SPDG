% Author: Xiaoming Xue
% Email: cupseven@163.com
%
% ------------
% Description:
% ------------
% TSPDG - This function runs the topology-based single-pool differential
%               grouping procedure to identify the subcomponents in cec'2013
%               benchmark problems.
%
% -------
% Inputs:
% -------
%    fun        : the function suite for which the interaction structure 
%                 is going to be identified in this case benchmark_func 
%                 of cec'2013.
%
%    position    : the topology information of each variable. In this
%                      study, we assumed that the variables are accompanied
%                      with  1-D positional information.
%
%    options    : this variable contains the options such as problem
%                 dimensionality, upper and lower bounds.
%
% --------
% Outputs:
% --------
%    SubcomsOutput       : a cell array containing all non-separable subcomponents.
%    FEs        : the total number of fitness evaluations used.

function [SubcomsOutput, FEs] = TSPDG(fun, position, options)

dim = options.dim;
lb = options.lbound;
ub = options.ubound;
FEs = 0;
Subcoms = cell(1,1);
Subcoms{1}(1) = 1;
detection_pool = 2:dim;
F_base = fun(lb);
FEs = FEs +2;


while ~isempty(detection_pool)
    variable_id = VariableSelection(Subcoms,detection_pool,1:dim);
    index = find(variable_id==detection_pool);
    detection_pool = [detection_pool(1:index-1),detection_pool(index+1:end)];
    x_perv = lb;x_perv(position(variable_id)) = ub(position(variable_id));
    F_VarPer = fun(x_perv);
    FEs = FEs+1;
    Series = 1:length(Subcoms);
    [sub_id, FEsc] = RecursiveIdentification(fun, variable_id, Subcoms, Series, F_base, F_VarPer, position, options, 0);
    FEs = FEs+FEsc;
    if isempty(sub_id)
        subnum = length(Subcoms);
        Subcoms{subnum +1}(1) = variable_id;
    else
        if length(sub_id)==1
            nn = length(Subcoms{sub_id});
            Subcoms{sub_id}(nn+1) = variable_id;
            P=Subcoms{sub_id};
            Subcoms{sub_id} = Subcoms{1};
            Subcoms{1} = P;
        else
            sub_iso = setdiff(1:length(Subcoms),sub_id);
            SubcomsNew = cell(1,1);SubcomsNew{1}=[];
            for i=1:length(sub_id)
                SubcomsNew{1} = [SubcomsNew{1} Subcoms{sub_id(i)}];
            end
            SubcomsNew{1} = [SubcomsNew{1} variable_id];
            for i=1:length(sub_iso)
                SubcomsNew{i+1}=[];
                SubcomsNew{i+1} = [SubcomsNew{i+1} Subcoms{sub_iso(i)}];
            end
            Subcoms = SubcomsNew;
        end
        ii=[];
        for i = 1:length(detection_pool)
            if detection_pool(i)>min(Subcoms{1})&&detection_pool(i)<max(Subcoms{1})
                nn=length(Subcoms{1});
                Subcoms{1}(nn+1) = detection_pool(i);
                ii=[ii, i];
            end
        end
        detection_pool_new = [];
        for i = 1:length(detection_pool)
            if isempty(find(i==ii))
                detection_pool_new = [detection_pool_new detection_pool(i)];
            end
        end
        detection_pool = detection_pool_new;
    end
end
SubcomsOutput = cell(length(Subcoms),1);
for i=1:length(Subcoms)
    SubcomsOutput{i} = position(Subcoms{i});
end