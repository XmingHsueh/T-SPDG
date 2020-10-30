% Author: Xiaoming Xue
% Email: cupseven@163.com
%
% ------------
% Description:
% ------------
% Metric - This function is used to measure the grouping accuracy of given decompositon results.

function [pl,ps,accuracy] = Metric(SepsIdeal,GroupsIdeal,SepsM,GroupsM,D)

IterIdeal = zeros(D,D);
for i=1:length(GroupsIdeal)
    for j=1:length(GroupsIdeal{i})-1
        for k=j+1:length(GroupsIdeal{i})
            IterIdeal(GroupsIdeal{i}(j),GroupsIdeal{i}(k)) = 1;
            IterIdeal(GroupsIdeal{i}(k),GroupsIdeal{i}(j)) = 1;
        end
    end
end
IterIdentify = zeros(D,D);
for i=1:length(GroupsM)
    for j=1:length(GroupsM{i})-1
        for k=j+1:length(GroupsM{i})
            IterIdentify(GroupsM{i}(j),GroupsM{i}(k)) = 1;
            IterIdentify(GroupsM{i}(k),GroupsM{i}(j)) = 1;
        end
    end
end
pl = sum(sum(IterIdeal.*(ones(D,D)-IterIdentify)))/D^2;
ps = sum(sum(IterIdentify.*(ones(D,D)-IterIdeal)))/D^2;
accuracy = (1-pl-ps)*100;