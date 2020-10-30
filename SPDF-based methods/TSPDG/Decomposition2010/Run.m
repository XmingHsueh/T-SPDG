% Author: Xiaoming Xue
% Email: cupseven@163.com
%
% ------------
% Description:
% ------------
% This file is the entry point for running the topology-based 
% single-pool differential grouping algorithm on the CEC'2010
 % benchmark functions.

clc,clear;

func = 1:20;

% import the topology information
load Topology

for i = func
    func_num = i;
    
    t1 = [1 4 7 8 9 12 13 14 17 18 19 20];
    t2 = [2 5 10 15];
    t3 = [3 6 11 16];
    
    if (ismember(func_num, t1))
        lb = -100;
        ub = 100;
    elseif (ismember(func_num, t2))
        lb = -5;
        ub = 5;
    elseif (ismember(func_num, t3))
        lb = -32;
        ub = 32;
    end
    
    opts.dim     = 1000;
    opts.lbound  = ones(opts.dim,1)*lb;
    opts.ubound  = ones(opts.dim,1)*ub;
    
    fun = @(x)benchmark_func(x,func_num);
    [Subcomponents, FEs] = TSPDG(fun, Topology(i,:), opts);
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
    
    filename = sprintf('./results2010/F%02d', func_num);
    save (filename, 'Groups', 'Seps', 'FEs');
    
    fprintf('%dth function complete!\n',func_num);
end