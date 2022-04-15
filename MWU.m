function res = MWU(N, vs, T, func)
assert(N == length(vs));

sum_reward = cell(1, N);
action_seq = cell(1, N); 
strategy_seq = cell(1, N); 
for i = 1:N
    sum_reward{i} = zeros(vs(i), 1); 
    action_seq{i} = zeros(1, T); 
    strategy_seq{i} = zeros(vs(i), T); 
end 

for t = 1:T
    as = zeros(1, N); 
    for i = 1:N
        M = vs(i);
        eps = func(i, t); 
        prop = exp(eps * sum_reward{i});
        prop = prop / sum(prop); 
        as(i) = randsample(M, 1, true, prop);
        strategy_seq{i}(:, t) = prop; 
        action_seq{i}(t) = as(i); 
    end
    
    for i = 1:N
        for j = 1 : vs(i)
            b_tmp = as - 1;
            b_tmp(i) = j-1; 
            us = utilities(vs, b_tmp); 
            sum_reward{i}(j) = sum_reward{i}(j) + us(i); 
        end
    end
end

frequency_seq = strategy_seq; 
for i = 1:N
    frequency_seq{i} = get_frequency_seq(action_seq{i}, vs(i)); 
end

res = {action_seq, strategy_seq, frequency_seq}; 
end
