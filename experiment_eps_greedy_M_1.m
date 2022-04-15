global N; global x_show; global styles; 

N = 2;

T = 20000;

x_show = 1:T;
styles = {"-.", ":", "-", "--", "-."}; 

vs = [8 6]; 

sqrt_func = @(i, t) 1 / sqrt(t); 

global alg_name; global eps_name; 
alg_name = "Greedy"; 
eps_name = "eps = 1/\surd t"; 
handle = @() eps_greedy(N, vs, T, sqrt_func); 


TIMES = 100; 

record = {}; 
% structure of record:
%   * record{ which time } { sequence id } { player } = desired sequence
%     - sequence id: 1 = action.  2 = strategy.  3 = frequency
global ID
ID = containers.Map(); 
ID("action") = 1; ID("strategy") = 2;  ID("frequency") = 3;

for i = 1:TIMES
    if mod(i, 10) == 0
        disp(alg_name + " progress: " + num2str(i) + " / " + num2str(TIMES))
    end
    record{end+1} = handle(); 
end

%%%%%%%%%%%%%%%%%%%%  plotting  %%%%%%%%%%%%%%%%%%

bids_1 = [2 3 4 5 6]; 
bids_2 = [2 3 4 5]; 

substring = alg_name + ", " + eps_name + ", v = [" + num2str(vs) + "]"; 

show_result(record, 1, "frequency", bids_1, [5, 6], {'b', 'g'}, "player 1's bid frequency, " + substring);
show_result(record, 1, "strategy", bids_1, [], {}, "player 1's mixed strategy, " + substring); 
show_result(record, 2, "frequency", bids_2, [3, 5], {'y', 'b'}, "player 2's bid frequency, " + substring); 
show_result(record, 2, "strategy", bids_2, [], {}, "player 2's mixed strategy, " + substring); 

function needed = get_record(all_record, player, id)
    n_record = length(all_record); 
    tmp = all_record{1}{id}{player}; 
    needed = zeros(n_record, size(tmp, 1), size(tmp, 2));
    for i = 1:n_record
        needed(i, :, :) = all_record{i}{id}{player}; 
    end
end

function show_result(all_record, player, seq_name, bids, confidence_bids, colors, title_str)
    global x_show; global styles; global alg_name; global ID; 
    figure();
    
    n_record = length(all_record); 
    assert(n_record > 0); 
    seq_id = ID(seq_name); 
    seq = all_record{1}{seq_id}{player}; 
    needed_record = get_record(all_record, player, seq_id); 
    
    plot_sequence(x_show, seq, bids, styles);
    
    legend_str = {}; 
    for b = bids
        legend_str{end+1} = num2str(b);
    end
    
    for i = 1 : length(confidence_bids)
        b = confidence_bids(i); 
        c = colors{i}; 
        plot_confience_interval(x_show, needed_record, b, 0.1, 0.9, c, 0.1); 
        legend_str{end + 1} = "[0.1, 0.9] interval of "+ num2str(b); 
    end
    legend(legend_str, 'Location', 'east'); 
    title(title_str); 
    
    set(gcf,'position',[100, 200, 500, 400]); 
    
    file_name = "tmp_figures/M=1/" + alg_name + "_player_"+ num2str(player) + "_" + seq_name; 
    saveas(gcf, file_name + ".fig");
    saveas(gcf, file_name + ".png");
end
