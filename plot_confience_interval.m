function plot_confience_interval(xs, record, bid, lb, ub, color, alpha)
lower_bound = xs; 
upper_bound = xs;
for t = xs
    lower_bound(t) = quantile(record(:, bid+1, t), lb); 
    upper_bound(t) = quantile(record(:, bid+1, t), ub); 
end
x_fold = [xs, fliplr(xs)]; 
in_between = [lower_bound, fliplr(upper_bound)]; 
h = fill(x_fold, in_between, color); 
set(h, 'FaceAlpha', alpha); 
end
