function batchresults = batchanalysis_blank(which_subs)

%Batchanalysis script written by Mike Hess for an inattentional blindness experiment, October '15

%This code compensates for your operation systems preferences when accessing data files.
if IsOSX    %On a Mac or PC, chooses the right data directory
    datadir='data/';
else
    datadir='data\';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define Data to be analyzed

%Add in the subject numbers of the data files that you wish to   analyze:

% allsubs = [1:29,31:37,39,40,42:54,58:76,78:121];

allsubs = 1:114;

% which_subs = 3; %set to 0 to look at just the subs who didn't see the line, 1 for just subs who did see the line,  3 for all subs

s = 0;

load which_subs

if which_subs == 1
    load listofseeners
    sub_list = 'seeners'
    s = s + 1;
    subnum_list = listofseeners;
elseif which_subs == 3
    sub_list = 'allsubs'
    subnum_list = allsubs;
else
    load listofnonseeners
    sub_list = 'nonseeners'
    subnum_list = listofnonseeners;
end

%Define numsubs as the length of subs in order to avoid hard coding
numsubs = length(subnum_list);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin Analysis

%Subject count, Used because every subject number may not be used
subcount = 0;
seener_list = [];

%loop through all of the subjects data files
for sub = subnum_list(1): length(subnum_list)
    subcount = subcount + 1;  %number of subjects so far
    
    
    %figure out the .mat filename and load it, saved in analysis folder
    fname = sprintf('%sExpSub_compact (%d).mat',datadir,subnum_list(sub));
    load(fname)
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Block #1 Analysis
    
    % Analysis of block #1  (there is only one block in this data file)
    block = 1;
    numtrials = length(Userdata.Blocks(block).Trials);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Block #2 Analysis
    
    % Analysis of block #2  (there is only one block in this data file)
    block = 2;
    numtrials = length(Userdata.Blocks(block).Trials);
    
    trialcounts = zeros(4,1);
    
    duo = 0; %counter for accuracy in line/color (denominator)
    
    sacc = 0; %counter for accuracy in line/color (numerator)
    
    non_duo = 0; %counter for accuracy in color only (denominator)
    
    nsacc = 0; %counter for accuracy in color only (numerator)
    
    pre_acc = 0; %counter for pre-surprise accuracy
    
    post_acc = 0; %counter for post-surprise accuracy
    
    %Set counter variable for those who saw line to 0
    if subcount == 1
        line_seeners = 0;
        non_line_seeners = 0;
    end
    
    % Loop through all of the trials in this block
    for trial = 1:numtrials
        
        %Extract crucial information from this trial
        trial_type = Userdata.Blocks(block).Trials(trial).Trial_Export.trial_type;
        trialcounts(trial_type) = trialcounts(trial_type) + 1;
        
        color_probe = Userdata.Blocks(block).Trials(trial).Trial_Export.color_probe;
        color_response = Userdata.Blocks(block).Trials(trial).Trial_Export.color_response;
        
        line_displayed = Userdata.Blocks(block).Trials(trial).Trial_Export.line_displayed;
        
        see_line_response = Userdata.Blocks(block).Trials(trial).Trial_Export.see_line_response;
        
        color_accuracy = color_probe - color_response;
        
        %Pre-surprise color accuracy
        if trial >= 40
            pre_acc = pre_acc + 1;
            pre_surprise_color_accuracy(pre_acc) = color_accuracy;
        else
            post_acc = post_acc + 1;
            post_surprise_color_accuracy(post_acc) = color_accuracy;
        end
        
        %Surprise trial
        if trial_type == 3
            if see_line_response == 1 && line_displayed == see_line_response
                %if they responded that they saw the line and got the
                %location correct, set them to 1
                seener = 1;
                line_seeners = line_seeners + 1;
            else
                seener = 0;
                non_line_seeners = non_line_seeners + 1;
            end
            seener_list = [seener_list seener];
        end
        
        %Post-surprise color & line accuracy (comparing line/color trials with color-only trials)
        if trial_type == 4
            
            %If a line is displayed, calculate color accuracy, save value in variable
            if line_displayed
                
                duo = duo + 1;
                
                if line_displayed == see_line_response
                    sacc = sacc + 1;
                end
                
                difference = color_response - color_probe;
                
                if(difference > 180)
                    difference = difference - 360;
                end
                if(difference < -180)
                    difference = difference + 360;
                end
                
                duo_color_accuracy(duo) = color_accuracy;
                
                duo_accuracy_counter(duo) = sacc/duo*100;
                
            else
                non_duo = non_duo + 1;
                
                if line_displayed == see_line_response
                    nsacc = nsacc + 1;
                end
                
                difference = color_response - color_probe;
                
                if(difference > 180)
                    difference = difference - 360;
                end
                
                if(difference < -180)
                    difference = difference + 360;
                end
                
                if difference >= abs(180) || difference <= -180
                    sca
                    keyboard
                end
                
                non_duo_color_accuracy(non_duo) = color_accuracy;
                
                non_duo_accuracy_counter(non_duo) = nsacc/non_duo*100;
                
            end
        end
        
        if trial == numtrials %end of the subject's run-through
            
            batchresults.total_number_of_subjects = subcount;
            batchresults.subnum_list = subnum_list;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Color Accuracy%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%IMPORTANT NOTE: COLOR ACCURACY IS MEASURED IN THE AVERAGE COLOR VALUES AWAY THE REPORTED COLOR IS FROM THE DISPLAYED COLOR. THUS, LOWER IS BETTER!                       
            
            batchresults.pre_surprise_color_accuracy_per_sub(subcount) = mean(abs(pre_surprise_color_accuracy));
            batchresults.post_surprise_color_accuracy_per_sub(subcount) = mean(abs(post_surprise_color_accuracy));            
            batchresults.allsubs_pre_surprise_color_accuracy = mean(batchresults.pre_surprise_color_accuracy_per_sub);
            batchresults.allsubs_post_surprise_color_accuracy = mean(batchresults.post_surprise_color_accuracy_per_sub);
            
            batchresults.duo_color_accuracy_per_sub(subcount) = mean(abs(duo_color_accuracy));
            batchresults.non_duo_color_accuracy_per_sub(subcount) = mean(abs(non_duo_color_accuracy));
            batchresults.allsubs_duo_color_accuracy = mean(batchresults.duo_color_accuracy_per_sub);
            batchresults.allsubs_non_duo_color_accuracy = mean(batchresults.non_duo_color_accuracy_per_sub);
            
            allsubs_duo_color_accuracy = batchresults.allsubs_duo_color_accuracy;
            allsubs_non_duo_color_accuracy = batchresults.allsubs_non_duo_color_accuracy;
            
            post_surprise_duo_color_comparison(subcount) = abs(allsubs_non_duo_color_accuracy - allsubs_duo_color_accuracy);
            batchresults.duo_non_duo_color_accuracy_difference = mean(abs(post_surprise_duo_color_comparison)); %difference between non-duo and duo trials with respect to color accuracy
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Line Accuracy%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            duo_trial_line_accuracy = mean(abs(duo_accuracy_counter)); %correcting reporting a line
            non_duo_trial_line_accuracy = mean(abs(non_duo_accuracy_counter));
            
            batchresults.surprise_line_seen_total = line_seeners; %number of participants who reported that they saw something unusual & got the location correct on the surprise trial
            batchresults.surprise_line_missed_total = numsubs - line_seeners; %...and the ones who didn't
            
            batchresults.duo_trial_line_accuracy_per_sub(subcount) = mean(abs(duo_trial_line_accuracy));
            batchresults.non_duo_trial_line_accuracy_per_sub(subcount) = mean(abs(non_duo_trial_line_accuracy));
            
            batchresults.allsubs_duo_line_accuracy = mean(abs(batchresults.duo_trial_line_accuracy_per_sub));
            batchresults.allsubs_non_duo_line_accuracy = mean(abs(batchresults.non_duo_trial_line_accuracy_per_sub));            
            
            post_surprise_duo_line_comparison = abs(batchresults.allsubs_non_duo_line_accuracy - batchresults.allsubs_duo_line_accuracy);
            batchresults.duo_non_duo_line_reporting_difference = mean(abs(post_surprise_duo_line_comparison)); %difference between non-duo and duo trials with respect to line reporting accuracy
        end
    end
end

listofseeners = find(seener_list == 1);
listofnonseeners = find(seener_list == 0);

if which_subs == 3
    save ('listofseeners.mat','listofseeners')
    save ('listofnonseeners.mat','listofnonseeners')
end