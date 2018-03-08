function [Events Parameters Stimuli_sets Block_Export Trial_Export  Numtrials]=clock_task2(Parameters, Stimuli_sets, Trial, Blocknum, Modeflag, ...
    Events,Block_Export,Trial_Export,Demodata)

load('blockvars');addpath(genpath('util'));

%Paradigm coded by Michael R Hess, March '18

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(Modeflag,'InitializeBlock')
    clear Stimuli_sets
    
    %% Trial Parameters% (Not all. For the rest, scroll down to "The Experiment Display" section.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    s_con = mod(Demodata.s_num,2);
    
    %Total number of trials
    Numtrials = 128 + 1; %Because of the way this block file runs, set Numtrials equal to the amount of trials you want and then add 1
    
    test_mode = 1; %test mode deactivates instructions atm
    load_points_wheel = 1; %load the points wheel?
    type = 2; %paradigm type: 1 = probabilities average(40-60%), 2 = uneven, 3 = gold mine(one:75%,rest:40%)
    turn_bot_off = 0; %turn off bot mode?
    toggle_botbutton = 0; %0 = click wheel during bot mode, 1 = click button
    
    if test_mode
        Numtrials = 18;
    end
    
    %Create segmented wheel
    num_segments = 8; %number of segments
    seg_colors{1} = [0 105 255]; %colors of segments
    seg_colors{2} = seg_colors{1};
    add_wheel_borders = 1;
    
    %Timing variables%
    
    %When the instructions will be displayed from the start of the experiment (Trial 1)
    instruction_display_time = 0;
    reward_time = instruction_display_time+.01;
    
    %When the segment wheel will appear
    seg_wheel_time = instruction_display_time + 2;
    
    %How long the feedback will display on screen at the end of a trial
    total_feedback_time = 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Set up Stimuli
    
    %Create segments on click wheel
    [seg_values scorecolormatrix change_spot num_wheel_boxes] = segment_wheel(num_segments,seg_colors,add_wheel_borders);
    scorecolormatrices{1} = scorecolormatrix;
    rand_seg_rows = randperm(num_segments);
    if s_con == 1
        seg_rows = rand_seg_rows(1:(num_segments/2));
    else
        seg_rows = rand_seg_rows;
    end
    csvwrite('seg_rows.csv',seg_rows);
    
    add_choice = 0;
    for add_seg_row = 1:(num_segments/2)
        for add_seg_val = 1:length(seg_values(1,:))
            add_choice = add_choice + 1;
            possible_bot_choices(add_choice) = seg_values(seg_rows(add_seg_row),add_seg_val);
        end
    end
    
    %Set up the bot's segment choices
    if type ~= 2
        bot_choices = randperm(num_wheel_boxes);
    else
        if s_con==1;crows=8;num_choices=4;else crows=4;num_choices=8;end
        bot_choice_row = 0;
        for crow = 1:crows
            if crow == 1
                bot_choice_row(end:end+num_choices-1) = randperm(num_choices);
            else
                bot_choice_row(end+1:end+num_choices) = randperm(num_choices);
            end
        end
    end
    
    csvwrite('scorecolormatrix.csv',scorecolormatrix);
    scorecolormatrix2 = scorecolormatrix;
    csvwrite('scorecolormatrix2.csv',scorecolormatrix2);
    
    scorecolormatrix3 = scorecolormatrix;
    csvwrite('scorecolormatrix3.csv',scorecolormatrix3);
    scorecolormatrix4 = scorecolormatrix2;
    csvwrite('scorecolormatrix4.csv',scorecolormatrix4);
    
    save('seg_values','seg_values');
    
    %Enables mouse
    Parameters.mouse.enabled = 1;
    
    %Color Wheel 1 (Outer)
    colorWheelRadius1 = 260; %radius of color wheel
    %Cartesian Conversion
    colorWheelLocations1 = [cosd(1:num_wheel_boxes).*colorWheelRadius1 + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*colorWheelRadius1 + Parameters.centery];
    
    %Color Wheel 2 (Mid)
    colorWheelRadius2 = 252; %radius of color wheel
    %Cartesian Conversion
    colorWheelLocations2 = [cosd(1:num_wheel_boxes).*colorWheelRadius2 + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*colorWheelRadius2 + Parameters.centery];
    
    %Color Wheel 3 (Inner)
    colorWheelRadius3 = 244; %radius of color wheel
    %Cartesian Conversion
    colorWheelLocations3 = [cosd(1:num_wheel_boxes).*colorWheelRadius3 + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*colorWheelRadius3+ Parameters.centery];
    
    %Points Wheel 1 (Inner)
    pointsWheelRadius1 = colorWheelRadius1 + 40; %radius of color wheel
    %Cartesian Conversion
    pointsWheelLocations1 = [cosd(1:num_wheel_boxes).*pointsWheelRadius1 + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*pointsWheelRadius1 + Parameters.centery];
    
    % pointswheel1_endnotch = [cosd(360).*pointsWheelRadius1 + Parameters.centerx; ...
    %     sind(360).*pointsWheelRadius1 + Parameters.centery];
    
    pointsWheelLocations1(2,360) = pointsWheelLocations1(2,360) - 0.1;
    
    %Points Wheel 1 (Outer)
    pointsWheelRadius2 = pointsWheelRadius1 + 8; %radius of color wheel
    %Cartesian Conversion
    pointsWheelLocations2 = [cosd(1:num_wheel_boxes).*pointsWheelRadius2 + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*pointsWheelRadius2 + Parameters.centery];
    
    pointswheel2_endnotch = [cosd(360).*pointsWheelRadius2 + Parameters.centerx; ...
        sind(360).*pointsWheelRadius2 + Parameters.centery];
    
    pointsWheelLocations2(2,360) = pointsWheelLocations2(2,360) - 0.1;
    
    
    %Points Wheel 2 (Inner)
    pointsWheel2Radius1 = pointsWheelRadius1 - 19; %radius of color wheel
    %Cartesian Conversion
    pointsWheel2Locations1 = [cosd(1:num_wheel_boxes).*pointsWheel2Radius1 + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*pointsWheel2Radius1 + Parameters.centery];
    
    pointswheel1_endnotch = [cosd(360).*pointsWheelRadius1 + Parameters.centerx; ...
        sind(360).*pointsWheelRadius1 + Parameters.centery];
    
    pointsWheel2Locations1(2,360) = pointsWheel2Locations1(2,360) - 0.1;
    
    %Points Wheel 1 (Outer)
    pointsWheel2Radius2 = pointsWheel2Radius1 + 8; %radius of color wheel
    %Cartesian Conversion
    pointsWheel2Locations2 = [cosd(1:num_wheel_boxes).*pointsWheel2Radius2 + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*pointsWheel2Radius2 + Parameters.centery];
    
    pointswheel2_endnotch = [cosd(360).*pointsWheelRadius2 + Parameters.centerx; ...
        sind(360).*pointsWheelRadius2 + Parameters.centery];
    
    pointsWheel2Locations2(2,360) = pointsWheel2Locations2(2,360) - 0.1;
    
    %Location Wheel
    locationWheelRadius = 260; %radius of color wheel
    %Cartesian Conversion
    locationWheelLocations1 = [cosd(1:num_wheel_boxes).*locationWheelRadius + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*locationWheelRadius + Parameters.centery];
    
    %Location Wheel
    locationWheelRadius = 252; %radius of color wheel
    %Cartesian Conversion
    locationWheelLocations2 = [cosd(1:num_wheel_boxes).*locationWheelRadius + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*locationWheelRadius + Parameters.centery];
    
    %Location Wheel
    locationWheelRadius = 246; %radius of color wheel
    %Cartesian Conversion
    locationWheelLocations3 = [cosd(1:num_wheel_boxes).*locationWheelRadius + Parameters.centerx; ...
        sind(1:num_wheel_boxes).*locationWheelRadius + Parameters.centery];
    
    locationWheelLocations = [locationWheelLocations1 locationWheelLocations2 locationWheelLocations3];
    
    %Used for mouse clicks on color wheel
    for i = 1:num_wheel_boxes
        buttonlocs{i} = [locationWheelLocations(1,i),locationWheelLocations(2,i),30];
    end
    
    loc_off = -2;
    
    % firstpoint1 = pointsWheelLocations1(:,1);
    firstpoint1(1,1) = mean(round(pointsWheelLocations1(1,1)),round(pointsWheelLocations1(1,2)));
    firstpoint1(2,1) = mean(round(pointsWheelLocations1(2,1)),round(pointsWheelLocations1(2,2)))+loc_off;
    % firstpoint1(2,:) = firstpoint1(2,:) - .1;
    % firstpoint2 = pointsWheelLocations2(:,1);
    firstpoint2(1,1) = mean(round(pointsWheelLocations2(1,1)),round(pointsWheelLocations2(1,2)));
    firstpoint2(2,1) = mean(round(pointsWheelLocations2(2,1)),round(pointsWheelLocations2(2,2)))+loc_off;
    % firstpoint2(2,:) = firstpoint2(2,:) - .1;
    firstcolor = scorecolormatrix(360,:);
    
    firstpoint3(1,1) = mean(round(pointsWheel2Locations1(1,1)),round(pointsWheel2Locations1(1,2)));
    firstpoint4(2,1) = mean(round(pointsWheel2Locations1(2,1)),round(pointsWheel2Locations1(2,2)))+loc_off;
    % firstpoint1(2,:) = firstpoint1(2,:) - .1;
    % firstpoint2 = pointsWheelLocations2(:,1);
    firstpoint3(1,1) = mean(round(pointsWheel2Locations2(1,1)),round(pointsWheel2Locations2(1,2)));
    firstpoint4(2,1) = mean(round(pointsWheel2Locations2(2,1)),round(pointsWheel2Locations2(2,2)))+loc_off;
    % firstpoint2(2,:) = firstpoint2(2,:) - .1;
    firstcolor2 = scorecolormatrix2(360,:);
    
    save('colorWheelLocations','colorWheelLocations1','colorWheelLocations2','colorWheelLocations3');
    save('pointsWheelLocations','pointsWheelLocations1','pointsWheelLocations2','pointsWheel2Locations1','pointsWheel2Locations2','firstpoint1','firstpoint2','firstpoint3','firstpoint4','firstcolor','firstcolor2');
    save('pointswheel_endnotches','pointswheel1_endnotch','pointswheel2_endnotch');
    
    locx = Parameters.centerx;
    locy = Parameters.centery;
    
    border_offset = 8;
    
    %Color Wheel 1 Border
    cwb1 = 800;
    stimstruct = CreateStimStruct('shape');
    stimstruct.stimuli = {'FrameOval'};
    stimstruct.xdim = colorWheelRadius1*2+border_offset;
    stimstruct.ydim = colorWheelRadius1*2+border_offset;
    stimstruct.color = [0 0 0];
    Stimuli_sets(cwb1) = Preparestimuli(Parameters,stimstruct);
    
    %Color Wheel 2 Border
    stimstruct = CreateStimStruct('shape');
    for i = 1:2
        cwb2 = 801;
        stimstruct.stimuli = {'FrameOval'};
        stimstruct.xdim = pointsWheelRadius2*2+border_offset;
        stimstruct.ydim = pointsWheelRadius2*2+border_offset;
        stimstruct.color = [0 0 0];
        stimstruct.stimsize = 1;
        if i==2;stimstruct.stimsize = 1.01;end
        Stimuli_sets(cwb2+i-1) = Preparestimuli(Parameters,stimstruct);
    end
    
    %Points Wheel 1 Border
    pwb1 = 802;
    stimstruct = CreateStimStruct('shape');
    stimstruct.stimuli = {'FrameOval'};
    stimstruct.xdim = pointsWheelRadius1*2-border_offset;
    stimstruct.ydim = pointsWheelRadius1*2-border_offset;
    stimstruct.color = [0 0 0];
    Stimuli_sets(pwb1) = Preparestimuli(Parameters,stimstruct);
    
    %Points Wheel 2 Border
    stimstruct = CreateStimStruct('shape');
    for i = 1:2
        pwb2 = 803;
        stimstruct.stimuli = {'FrameOval'};
        stimstruct.xdim = pointsWheelRadius2*2+border_offset;
        stimstruct.ydim = pointsWheelRadius2*2+border_offset;
        stimstruct.color = [0 0 0];
        stimstruct.stimsize = 1;
        if i==2;stimstruct.stimsize = 1.01;end
        Stimuli_sets(pwb2+i-1) = Preparestimuli(Parameters,stimstruct);
    end
    
    %Bot button
    bot_but = 1010;
    stimstruct = CreateStimStruct('shape');
    stimstruct.stimuli = {'FillRect'};
    button_x = 300;
    button_y = 200;
    stimstruct.xdim = button_x;
    stimstruct.ydim = button_y;
    button_color = 225;
    stimstruct.color = [button_color button_color button_color];
    Stimuli_sets(bot_but) = Preparestimuli(Parameters,stimstruct);
    
    %Bot button frame
    bot_but_frame = 1011;
    stimstruct = CreateStimStruct('shape');
    stimstruct.stimuli = {'FrameRect'};
    stimstruct.xdim = button_x;
    stimstruct.ydim = button_y;
    button_color = 0;
    stimstruct.color = [button_color button_color button_color];
    Stimuli_sets(bot_but_frame) = Preparestimuli(Parameters,stimstruct);
    
    %Load face pics
    face_stims = 1;
    face_dir = dir('Stimuli/faces');
    stimstruct = CreateStimStruct('image');
    for f = 3:length(face_dir)
        stimstruct.stimuli{f-2} = sprintf('faces/%s',face_dir(f).name);
    end
    Stimuli_sets(face_stims) = Preparestimuli(Parameters,stimstruct);
    
    %Nickel
    nickel = 500;
    stimstruct = CreateStimStruct('image');
    stimstruct.stimuli = {'nickel_noback.png'};
    stimstruct.stimsize = 1;
    Stimuli_sets(nickel) = Preparestimuli(Parameters,stimstruct);
    
    nickel_diam = 375;
    
    %Golden Nickel Border
    gnb = 1000;
    stimstruct = CreateStimStruct('shape');
    stimstruct.stimuli = {'FrameOval'};
    stimstruct.xdim = nickel_diam-3;
    stimstruct.ydim = nickel_diam;
    stimstruct.color = [255 255 0];
    Stimuli_sets(gnb) = Preparestimuli(Parameters,stimstruct);
    
    %No reward
    no_win = 599;
    stimstruct = CreateStimStruct('image');
    stimstruct.stimuli = {'nowinnickel.png'};
    stimstruct.stimsize = 1;
    Stimuli_sets(no_win) = Preparestimuli(Parameters,stimstruct);
    
    %Red Nickel Border
    rnb = 1001;
    stimstruct = CreateStimStruct('shape');
    stimstruct.stimuli = {'FrameOval'};
    stimstruct.xdim = nickel_diam-3;
    stimstruct.ydim = nickel_diam;
    stimstruct.color = [255 0 0];
    Stimuli_sets(rnb) = Preparestimuli(Parameters,stimstruct);
    
    %% Instructions & Other Text
    
    %Fixation Cross & Questions
    stimstruct = CreateStimStruct('text');
    stimstruct.wrapat = 0;
    stimstruct.stimuli = {'+','Click anywhere on the points wheel to try to score a nickel.'};
    stimstruct.stimsize = 20;
    Stimuli_sets(30) = Preparestimuli(Parameters,stimstruct);
    
    %Instructions (before practice trials)
    stimstruct = CreateStimStruct('text');
    stimstruct.wrapat = 0;
    stimstruct.stimuli = {'On each trial, you will see a "points wheel".','Your task is to click on different parts of this points wheel in','order to figure out which section is more likely to award you more points.','Press any button once you''re ready to begin.'};
    stimstruct.stimsize = 20;
    stimstruct.wrapat = 0;
    stimstruct.vSpacing = 5;
    Stimuli_sets(31) = Preparestimuli(Parameters,stimstruct);
    
    %Bot button text
    bot_but_text = 1110; %click here
    stimstruct = CreateStimStruct('text');
    stimstruct.stimuli = {'Click the colored','segment to continue'};
    stimstruct.stimsize = 22;
    Stimuli_sets(bot_but_text) = Preparestimuli(Parameters,stimstruct);
    
    %Whose turn
    whose_turn = 1111; %turn
    stimstruct = CreateStimStruct('text');
    stimstruct.stimuli = {'Computer''s turn!','Your Turn!'};
    stimstruct.stimsize = 52;
    Stimuli_sets(whose_turn) = Preparestimuli(Parameters,stimstruct);
    
    %Accuracy Feedback
    reward = 300;
    stimstruct = CreateStimStruct('text');
    stimstruct.wrapat = 0;
    stimstruct.stimuli = {'Congrats! You won a nickel!', 'Sorry, no nickel this time.','Congrats! You won another nickel!','Total: '};
    stimstruct.stimsize = 30;
    stimstruct.vSpacing = 5;
    Stimuli_sets(reward) = Preparestimuli(Parameters,stimstruct);
    
    %% Set up wheel blocks & chop up probabilities into quadrants
    
    %Base blocks of the wheel
    setupwheelblocks;
    
    if type == 1 || 2
        probs = [0.4 0.47 0.54 0.6]; %non-gold mine
    elseif type == 3 %gold mine
        probs = [0.4 0.4 0.4 0.75];
    end
    
%     probs=[1 1 1 1]; %%%
    probs = Shuffle(probs);
    prob_count = 1;
    
    for i = 1:360
        if ~mod(i,90) && i < 360
            prob_count = prob_count + 1;
        end
        wheel_probs(i) = probs(prob_count);
    end
    
    score = 0;
    
    bot_mode = 1
    bot_choice_count = 0;
    ready_for_score = 0;
    
elseif strcmp(Modeflag,'InitializeTrial')
    %% Set up other experiment parameters
    Trial
    
    if Trial == 1
        seg_wheel_time = instruction_display_time + .01;
    end
    
    if Trial > 3
        string_trial = num2str(Trial-2);
    else
        string_trial = num2str(Trial);
    end
    
    %1-32=bot,33-64=fc,65-94=bot,95=fc
    if test_mode;change_trial = 5; change_trial2 = 10; change_trial3 = 14;end
    if Trial == change_trial || Trial == change_trial3 || turn_bot_off
        bot_choice_count = 0;
        bot_mode = 0
        if s_con==1;crows=8;num_choices=4;else crows=4;num_choices=8;end
        bot_choice_row = 0;
        for crow = 1:crows
            if crow == 1
                bot_choice_row(end:end+num_choices-1) = randperm(num_choices);
            else
                bot_choice_row(end+1:end+num_choices) = randperm(num_choices);
            end
        end
    end
    
    if Trial == change_trial2 && ~turn_bot_off
        bot_choice_count = 0;
        bot_mode = 1
        if s_con==1;crows=8;num_choices=4;else crows=4;num_choices=8;end
        bot_choice_row = 0;
        for crow = 1:crows
            if crow == 1
                bot_choice_row(end:end+num_choices-1) = randperm(num_choices);
            else
                bot_choice_row(end+1:end+num_choices) = randperm(num_choices);
            end
        end
    end
    
    %Find bot's current choice
    bot_choice_count = bot_choice_count + 1;
    click_choice = bot_choice_row(bot_choice_count);
    
    if bot_mode && ~turn_bot_off
        segment_response = seg_values(seg_rows(click_choice),12);
    end
    
    if Trial == change_trial2 & s_con == 1
        s_con = 0;
    elseif Trial == change_trial2 & s_con == 0
        s_con = 1;
    end
    
    %Center coordinates
    locx = Parameters.centerx;
    locy = Parameters.centery;
    
    %Mouse appears
    Events = newevent_mouse_cursor(Events,instruction_display_time,locx,locy,0);
    
    %Mouse Parameters
    mouseresponse_seg = CreateResponseStruct;
    
    %Responsestruct
    responsestruct = CreateResponseStruct;
    responsestruct.x = locx;
    responsestruct.y = locy;
    
    temp = 0;
    
    %Wheel borders
    Events = newevent_show_stimulus(Events,cwb1,1,locx,locy,instruction_display_time,'screenshot_no','clear_no');
    Events = newevent_show_stimulus(Events,cwb2,1,locx,locy,instruction_display_time,'screenshot_no','clear_no');
    Events = newevent_show_stimulus(Events,cwb2+1,1,locx,locy,instruction_display_time,'screenshot_no','clear_no');
    Events = newevent_show_stimulus(Events,pwb1,1,locx,locy,instruction_display_time,'screenshot_no','clear_no');
    Events = newevent_show_stimulus(Events,pwb2,1,locx,locy,instruction_display_time,'screenshot_no','clear_no');
    Events = newevent_show_stimulus(Events,pwb2+1,1,locx,locy,instruction_display_time,'screenshot_no','clear_no');
    
    clickwheeltime = instruction_display_time;
    
    if ~bot_mode
        full_wheel = 1;
    else
        full_wheel = 0;
    end
    
    %Loads segmented wheel
    loadclickablewheel;
    
    %Loads points wheel
    if load_points_wheel
        points_time = instruction_display_time;
        loadpointswheel2;
    end
    
    %% If bot mode, wait for segment click before continuing
    if bot_mode && ~turn_bot_off
        seg_wheel_time = instruction_display_time;
        if bot_mode
            %Show cursor
            Events = newevent_mouse_cursor(Events,seg_wheel_time,locx,locy,0);
            %Mouse Parameters
            bot_response = CreateResponseStruct;
            %Text
            Events = newevent_show_stimulus(Events,whose_turn,1,locx,locy-400,instruction_display_time,'screenshot_no','clear_no');
            if toggle_botbutton
                %Bot Button
                Events = newevent_show_stimulus(Events,bot_but,1,locx,locy,instruction_display_time,'screenshot_no','clear_no');
                Events = newevent_show_stimulus(Events,bot_but_frame,1,locx,locy,instruction_display_time,'screenshot_no','clear_no');
                %Bot Button Text
                Events = newevent_show_stimulus(Events,bot_but_text,1,locx,locy-25,instruction_display_time,'screenshot_no','clear_no');
                Events = newevent_show_stimulus(Events,bot_but_text,2,locx,locy+25,instruction_display_time,'screenshot_no','clear_no');
                %Mouse Click Windows
                bot_buttonlocs{1}=[locx,locy,200];
                bot_response.spatialwindows = bot_buttonlocs;
                if ~test_mode
                    [Events bot_button_click] = newevent_mouse(Events,instruction_display_time,bot_response);
                end
            else
                %Bot Instructions
                Events = newevent_show_stimulus(Events,bot_but_text,1,locx,locy-25,instruction_display_time,'screenshot_no','clear_no');
                Events = newevent_show_stimulus(Events,bot_but_text,2,locx,locy+25,instruction_display_time,'screenshot_no','clear_no');
            end
        end
        
        %Mouse appears
        Events = newevent_mouse_cursor(Events,instruction_display_time,locx,locy,Parameters.mouse.cursorsize);
        
        %Mouse Click Windows
        mouseresponse_seg.variableInputMapping=[1:360;1:360]';
        mouseresponse_seg.spatialwindows = buttonlocs;
        [Events] = newevent_mouse(Events,instruction_display_time,mouseresponse_seg);
        
    end
    
    %% Instruction Display (before practice trials) %%
    if Trial == 1
        
        if ~test_mode
            Events = newevent_mouse_cursor(Events,0,locx,locy,0);
            Events = newevent_show_stimulus(Events,31,1,locx,locy-100,instruction_display_time,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,31,2,locx,locy,instruction_display_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,31,3,locx,locy+100,instruction_display_time,'screenshot_no','clear_no');
            responsestruct.allowedchars = 0;
            Events = newevent_keyboard(Events,instruction_display_time,responsestruct);
        end
        segment_score = zeros(num_segments,2);
        
    end
    
    %% Feedback %%
    if (Trial > 1 && Trial ~= change_trial && Trial ~= change_trial3) || bot_mode
        
        if Trial == 1
            seg_wheel_time = reward_time + 2;
        elseif Trial == 2
            seg_wheel_time = reward_time + 1.5;
        else
            seg_wheel_time = reward_time + 1;
        end
        
        y_offset = 100;
        rewardtext_locy = locy - 400;
        nickel_locy = locy - 100;
        
        %Find prob of click space
        selected_prob = wheel_probs(segment_response);
        
        %Find selected segment of the wheel
        show_selected_segment;
        
        win = 0; add = 0;
        
        chance = rand(1);
        if chance <= selected_prob
            win = 1;
            
            %Calculate segment score
            segment_score(selected_row,1) = segment_score(selected_row,1) + 1;
            segment_score(selected_row,2) = segment_score(selected_row,2) + 1;
            score = score + 1;
            [add] = show_score(segment_score,add,scorecolormatrix,scorecolormatrix2,win,seg_values,segment_response,change_spot,Trial,num_wheel_boxes,num_segments);
            
            %Wheel borders
            Events = newevent_show_stimulus(Events,cwb1,1,locx,locy,reward_time,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,cwb2,1,locx,locy,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,cwb2+1,1,locx,locy,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb1,1,locx,locy,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb2,1,locx,locy,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb2+1,1,locx,locy,reward_time,'screenshot_no','clear_no');
            
            %Loads segmented wheel
            clickwheeltime = reward_time;
            full_wheel = 0;
            loadclickablewheel;
            
            if score < 2
                Events = newevent_show_stimulus(Events,reward,1,locx,rewardtext_locy+y_offset-100,reward_time,'screenshot_no','clear_no'); %"you won a nickel!'
            else
                Events = newevent_show_stimulus(Events,reward,3,locx,rewardtext_locy+y_offset-100,reward_time,'screenshot_no','clear_no'); %"you won ANOTHER nickel!"
            end
            
            %Loads points wheel
            if load_points_wheel
                points_time = reward_time;
                loadpointswheel;
            end
            
            %Nickel
            Events = newevent_show_stimulus(Events,nickel,1,locx,nickel_locy+y_offset,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,gnb,1,locx,nickel_locy+y_offset+3,reward_time,'screenshot_no','clear_no');
            
        else %Didn't win a nickel :'(
            
            %Calculate segment score
            segment_score(selected_row,2) = segment_score(selected_row,2) + 1;
            scorecolormatrix=csvread('scorecolormatrix.csv');
            [add] = show_score(segment_score,add,scorecolormatrix,scorecolormatrix2,win,seg_values,segment_response,change_spot,Trial,num_wheel_boxes,num_segments);
            
            %Wheel borders
            Events = newevent_show_stimulus(Events,cwb1,1,locx,locy,reward_time,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,cwb2,1,locx,locy,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,cwb2+1,1,locx,locy,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb1,1,locx,locy,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb2,1,locx,locy,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb2+1,1,locx,locy,reward_time,'screenshot_no','clear_no');
            
            %Loads segmented wheel
            clickwheeltime = reward_time;
            full_wheel = 0;
            loadclickablewheel;
            
            %Loads points wheel
            if load_points_wheel
                points_time = reward_time;
                loadpointswheel
            end
            
            %"No reward" test
            Events = newevent_show_stimulus(Events,reward,2,locx,rewardtext_locy+y_offset-100,reward_time,'screenshot_no','clear_no');
            
            %Crossed out nickel
            Events = newevent_show_stimulus(Events,no_win,1,locx,nickel_locy+y_offset,reward_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,rnb,1,locx,nickel_locy+y_offset+3,reward_time,'screenshot_no','clear_no');
            
        end
    end
    
    %% Pariticipant response display %%
    
    if Trial < Numtrials
        
        if ~bot_mode
            
            %Mouse appears
            Events = newevent_mouse_cursor(Events,seg_wheel_time,locx,locy,Parameters.mouse.cursorsize);
            
            %Wheel borders
            Events = newevent_show_stimulus(Events,cwb1,1,locx,locy,seg_wheel_time,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,cwb2,1,locx,locy,seg_wheel_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,cwb2+1,1,locx,locy,seg_wheel_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb1,1,locx,locy,seg_wheel_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb2,1,locx,locy,seg_wheel_time,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,pwb2+1,1,locx,locy,seg_wheel_time,'screenshot_no','clear_no');
            
            %Loads segmented wheel
            clickwheeltime = seg_wheel_time;
            
            full_wheel = 1;
            
            loadclickablewheel;
            
            if load_points_wheel
                points_time = seg_wheel_time;
                loadpointswheel;
            end
            
            if ~toggle_botbutton && Trial ~= change_trial2-1
                %Mouse Click Windows
                mouseresponse_seg.spatialwindows = buttonlocs;
                [Events,segment_response] = newevent_mouse(Events,seg_wheel_time,mouseresponse_seg);
                Events = newevent_show_stimulus(Events,whose_turn,2,locx,locy-400,seg_wheel_time,'screenshot_no','clear_no'); %your turn!
            end
            trial_end_time = seg_wheel_time + .001; %when the trial ends
        else
            trial_end_time = reward_time + 1; %when the trial ends
        end
        
    else
        trial_end_time = total_feedback_time;
    end
    
    %% Ends trial
    Events = newevent_end_trial(Events,trial_end_time);
    
elseif strcmp(Modeflag,'EndTrial')
    %% Record output data in structure & save in .MAT file
    seg_rows=csvread('seg_rows.csv');
    if Trial < Numtrials
        
        if ~bot_mode || turn_bot_off
            if Trial ~= change_trial2-1
                segment_response = (Events.windowclicked{segment_response});
            end
        end
        Trial_Export.bot_mode = bot_mode;
        Trial_Export.condition = s_con;
        if Trial > 1
            Trial_Export.selected_seg = selected_row;
            Trial_Export.selected_prob = selected_prob;
        end
        Trial_Export.seg_probs = probs;
        
    else
        Trial_Export.selected_row = 'feedback trial';
    end
    
elseif strcmp(Modeflag,'EndBlock')
else
    %Something went wrong in Runblock (You should never see this error)
    error('Invalid modeflag');
end
saveblockspace
end