function plot_sequence(xs, seq, bid_range, styles)
for i = 1:length(bid_range)
    b = bid_range(i);
    plot(xs, seq(b+1, xs), styles{i}, "LineWidth", 1.5)
    hold on
end
end
