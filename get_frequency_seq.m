function f_seq = get_frequency_seq(a_seq, M)
T = size(a_seq, 2); assert(size(a_seq, 1) == 1); 
f_seq = zeros(M, T);
f_seq(a_seq(1), 1) = 1; 
for t = 2:T
    f_seq(:, t) = f_seq(:, t-1); 
    f_seq(a_seq(t), t) = f_seq(a_seq(t), t-1) + 1; 
end
for t = 2:T
    f_seq(:, t) = f_seq(:, t) ./ t; 
end
end
