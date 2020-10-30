clc,clear

Non_p = [1 2 3 15];
func_num = 15;
dim = [ones(1,12)*1000 905 905 1000];
Topology = cell(func_num,1);

for i=1:func_num
    file_name = ['f',sprintf('%02d',i),'.mat'];
    S_run = ['load ',file_name];
    eval(S_run);
    if ~isempty(find(i==Non_p))
        Topology{i} = 1:dim;
    else
        Topology{i} = p;
    end
end
save Topology Topology