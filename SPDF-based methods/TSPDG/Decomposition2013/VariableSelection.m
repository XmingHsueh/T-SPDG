function variable_id = VariableSelection(subs,detection_pool,location)

num_subs = length(subs);
center = zeros(num_subs,1);
for i=1:num_subs
    center(i) = mean(subs{i});
end

distance = zeros(1,length(detection_pool));
for i=1:length(distance)
    distance(i) = min(abs((location(detection_pool(i))-center)));
end
[~,index] = find(max(distance)==distance);
variable_id = detection_pool(index(1));