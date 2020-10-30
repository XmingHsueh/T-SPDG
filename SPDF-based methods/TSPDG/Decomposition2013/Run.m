% Author: Xiaoming Xue
% Email: cupseven@163.com
%
% ------------
% Description:
% ------------
% This file is the entry point for running the topology-based 
% single-pool differential grouping algorithm on the CEC'2013
 % benchmark functions.

clc,clear;

func = 1:15;
load Topology

for i = func
    func_num = i;
    
    t1 = [13 14];
    t2 = [1 4 7 8 11 12 15];
    t3 = [2 5 9];

    if (ismember(func_num, t1))
        D=905;
        lb = -100;
        ub = 100;
    elseif (ismember(func_num, t2))
        D=1000;
        lb = -100;
        ub = 100;
    elseif (ismember(func_num, t3))
        D=1000;
        lb = -5;
        ub = 5;
    else
        D=1000;
        lb = -32;
        ub = 32;
    end

    opts.dim     = D;
    opts.lbound  = ones(opts.dim,1)*lb;
    opts.ubound  = ones(opts.dim,1)*ub;
    
    fun = @(x)benchmark_func(x,func_num);
    [Subcomponents, FEs] = TSPDG(fun, Topology{i}, opts);
    Groups = cell(1,1);
    Seps = [];
    t = 1;
    for j = 1:length(Subcomponents)
        if length(Subcomponents{j}) == 1
            Seps = [Seps, Subcomponents{j}];
        else
            Groups{t} = Subcomponents{j};
            t = t+1;
        end
    end
    
    filename = sprintf('./results2013/F%02d', func_num);
    save (filename, 'Groups', 'Seps', 'FEs');
    
    fprintf('%dth function complete!\n',func_num);
end