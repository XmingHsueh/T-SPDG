clc,clear

S = {'o','o','o','opm','opm','opm','op','op','opm','opm','opm','op','op','opm','opm','opm','op','op','o','o'};
Non_p = [1 2 3 19 20];
func_num = 20;
dim = 1000;
Topology = zeros(func_num,dim);

for i=1:func_num
    file_name = ['f',sprintf('%02d',i),'_',S{i},'.mat'];
    S_run = ['load ',file_name];
    eval(S_run);
    if ~isempty(find(i==Non_p))
        Topology(i,:) = 1:dim;
    else
        Topology(i,:) = p;
    end
end
save Topology Topology