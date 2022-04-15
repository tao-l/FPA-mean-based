global N; global x_show; global styles; 

N = 2;

T = 2000;

x_show = 1:min(T, 500);
styles = {"-.", ":", "-", "--", "-."}; 

v = 4; 
vs = [4 4]; 
bids = [0 1 2 3]; 

sqrt_func = @(i, t) 1 / sqrt(t); 

global alg_name; global eps_name; global file_path
alg_name = "MWU"; 
eps_name = "eps = 1/\surd t"; 
file_path = "tmp_figures/M=2/"; 

handle = @() MWU(N, vs, T, sqrt_func); 


TIMES = 1000; 

first = 0;  % first is the v1 - 2 equilibrium
second = 0; % second is the v1 - 1 equilibrium 
other = 0;  

record_first = {};
record_second = {}; 
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
    res = handle(); 
    
    % get player 1's frequencies in the last round (T)
    f = res{ID("frequency")}{1}(:, T);  
    
    if f(v) > 0.9
        second = second + 1; 
        record_second{second} = res;
    else
        if f(v-1) > 0.9
            first = first + 1;
            record_first{first} = res;
        else
            other = other + 1;
        end
    end
end

counts = [first, second, other]

%%%%%%%%%%%%%%%%%%%%  plotting  %%%%%%%%%%%%%%%%%%

%%%%  for the v1 - 2 equilibrium 
if (first > 0) 
    substring = alg_name + ", " + eps_name + ", v = [" + num2str(vs) + "], to " + num2str(v-2); 

    file_name = file_path + alg_name + "_v1-2_"; 
    show_result(record_first, 1, "frequency", bids, [2, 3], {'y', 'b'}, "player 1's bid frequency, " + substring);
    save_figure(file_name + "player-1_frequency"); 
    show_result(record_first, 2, "frequency", bids, [2, 3], {'y', 'b'}, "player 2's bid frequency, " + substring); 
    save_figure(file_name + "player-2_frequency"); 
    show_result(record_first, 1, "strategy", bids, [2, 3], {'y', 'b'}, "player 1's mixed strategy, " + substring); 
    save_figure(file_name + "player-1_strategy"); 
    show_result(record_first, 2, "strategy", bids, [2, 3], {'y', 'b'}, "player 2's mixed strategy, " + substring); 
    save_figure(file_name + "player_2_strategy");
else
    disp("No v1 - 2 equilibrium !")
end

%%%%  for the v1 - 1 equilibrium 
substring = alg_name + ", " + eps_name + ", v = [" + num2str(vs) + "], to " + num2str(v-1); 

file_name = file_path + alg_name + "_v1-1_"; 
show_result(record_second, 1, "frequency", bids, [2, 3], {'y', 'b'}, "player 1's bid frequency, " + substring);
save_figure(file_name + "player-1_frequency"); 
show_result(record_second, 2, "frequency", bids, [2, 3], {'y', 'b'}, "player 2's bid frequency, " + substring); 
save_figure(file_name + "player-2_frequency"); 
show_result(record_second, 1, "strategy", bids, [2, 3], {'y', 'b'}, "player 1's mixed strategy, " + substring); 
save_figure(file_name + "player-1_strategy"); 
show_result(record_second, 2, "strategy", bids, [2, 3], {'y', 'b'}, "player 2's mixed strategy, " + substring); 
save_figure(file_name + "player_2_strategy"); 


function needed = get_record(all_record, player, id)
    n_record = length(all_record); 
    tmp = all_record{1}{id}{player}; 
    needed = zeros(n_record, size(tmp, 1), size(tmp, 2));
    for i = 1:n_record
        needed(i, :, :) = all_record{i}{id}{player}; 
    end
end

function show_result(all_record, player, seq_name, bids, confidence_bids, colors, title_str)
    global x_show; global styles; global ID; 
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
end

function save_figure(file_name)
    saveas(gcf, file_name + ".fig");
    saveas(gcf, file_name + ".png");
end
