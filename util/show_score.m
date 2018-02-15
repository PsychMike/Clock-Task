function [add] = show_score(segment_score,add,scorecolormatrix,win,seg_values,segment_response,change_spot,Trial,num_wheel_boxes,num_segments)

if ~add
    
    if Trial == 1
        clear seg_scorekeeper
    end
    
    persistent seg_scorekeeper firstslotcolor
    
    csvwrite('segment_score',segment_score);
    load('seg_values','seg_values');
    [selected_row,w,x]=find(seg_values==segment_response);
    
    seg_score_startingpoint = change_spot(selected_row) - 1;
    
    current_seg_score = segment_score(selected_row,2);
    
    if current_seg_score == 1
        seg_score_currentpoint = seg_score_startingpoint +  current_seg_score - num_wheel_boxes/num_segments;
    else
        seg_score_currentpoint = seg_score_startingpoint +  current_seg_score - num_wheel_boxes/num_segments + current_seg_score - 1;
    end
    
    seg_scorekeeper(seg_score_currentpoint) = win + 1;
    
    csvwrite('seg_scorekeeper',seg_scorekeeper);
    
    win_color_value = 145;
    
    for i = 1:length(seg_scorekeeper)
        if seg_scorekeeper(i) > 0
            [score_row,w,x] = find(seg_values==i);
            for wheel = 1:360
                [current_row,w,x]=find(seg_values==wheel);
                if current_row == score_row
                    if seg_scorekeeper(i) == 2
                        scorecolormatrix(i,:) = repmat(win_color_value,1,3);
                    else
                        scorecolormatrix(i,:) = [240 0 0];
                    end
                    if score_row == 1 && segment_score(selected_row,2) ==1
                        scorecolormatrix(360,:) = scorecolormatrix(i,:);
                        firstslotcolor = scorecolormatrix(360,:);
%                     elseif score_row == 1 && segment_score(selected_row,2) > 1
%                         scorecolormatrix(i,:) = scorecolormatrix(i,:);
                    else
                        scorecolormatrix(i+1,:) = scorecolormatrix(i,:);
                    end
                end
            end
        end
    end
    
    try
        scorecolormatrix(360,:) = firstslotcolor;
    end
    
    csvwrite('scorecolormatrix.csv',scorecolormatrix);
    
    add=1;
    
end