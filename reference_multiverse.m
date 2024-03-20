% fsp = face-related factor of C latency in easy tasks
% facc = face-related factor of C latency in difficult tasks 

%% Preparing data & preprocessing of data
clear all; clc;

% add eeglab path 
% add eeglab path 
cd C:\Users\zollner\Desktop\Practical_project % change directory
addpath(genpath('C:\Users\zollner\Desktop\Practical_project')) % add directory with all subfolders to the path
eeglabpath = fileparts(which('eeglab.m')); % create variable storing a path to eeglab toolbox
eeglab;

% DEFINE FOLDERS

path_facedata = 'Z:\face'; % where face data is located
addpath(genpath('Z:\face')); 
path_housedata = 'Z:\house';% where house data is located
addpath(genpath('Z:\house')); 
mainpath = 'C:\Users\zollner\Desktop\Practical_project'; % main path
path_preprocessed = 'D:\PreprocessedData'; % where pre-processed data is saved

% CREATE INDIVIDUAL FOLDERS FOR FORKING PATHS

% Create individual folders
cd(path_preprocessed)
mkdir('average_reference');
mkdir('mastoid_reference');
mkdir('REST_reference');
mkdir('CSD_reference');


% Create  list of files
cd(path_facedata)
files_face = dir('**/*.set');

cd(path_housedata)
files_house = dir('**/*.set'); %% DONT FORGET HOUSE DATA

files = [files_face; files_house];

% Preparation for Second multiverse step: 4 electrode groups
% (1) Cz, CPz,Pz; (2) Pz, Fz, Cz; (3) Cz; (4 )Pz
channels_group1 = [18, 28];
channels_group2 = [8, 18, 28];
channels_group3 = 18;
channels_group4 = 28; 
channels = {channels_group1, channels_group2, channels_group3, channels_group4};

% string of all different stimuli
str = ["S 22", "S 23", "S 24", "S 25", "S 26", "S 27", "S 28", "S 29", "S 42", "S 43", "S 44", "S 45", "S 46", "S 47", "S 48", "S 49" ]


%create in each reference folder 4 different folders for each electrode group that we want to investigate 
average_path = fullfile(path_preprocessed, 'average_reference');
csd_path = fullfile(path_preprocessed, 'CSD_reference');
mastoid_path = fullfile(path_preprocessed, 'mastoid_reference');
REST_path = fullfile(path_preprocessed, 'REST_reference');
folders = {average_path; mastoid_path; REST_path; csd_path}
% loop to create folders
for i = 1 : 4
    for j = 1:4
    foldername = fullfile(folders{i}, sprintf('elec_group_%d', j));
    mkdir(foldername)
    end
end


%% Multiverse pipeline for 4 different reference methods and 4 different groups of electrodes
% offline rereference preprocessed data to 4 different reference schemes
for eeg_file = 1:length(files)
    
    cd(eeglabpath); 
    close all; clc; 
    eeglab; % start eeglab (and restart it after every iteration of the loop)

    % Import data:
    EEG = pop_loadset(files(eeg_file).name);
    % Caluclate reaction times for each participant
    j=0; %counter
    k=[]
    for i=2:length(EEG.event)
        if contains(EEG.event(i-1).type, str)==1
            if EEG.event(i).type == 'S251'  | EEG.event(i).type == 'S254'
                rt = EEG.event(i).latency-EEG.event(i-1).latency;
                j = j+1;
                EEG.reaction_time(j)=rt;
                if size(EEG.data,3)>1
                    k = [k, EEG.event(i).epoch];
                end
            end
        end
    end
        if size(EEG.data,3)>1
        k = unique(k);
        EEG = pop_select(EEG, 'trial', k);
        end
    


    % Add information to EEG structure
    EEG.subject = EEG.filename(1:6);
    EEG.stimulus = EEG.filename(8);
    if EEG.filename(9)=='a'
        EEG.difficulty = 'difficult';
    elseif EEG.filename(9)=='s'
        EEG.difficulty = 'easy';
    end

    if contains(EEG.filename, 'UPUF')
        EEG.condition = 'UPUF';
    elseif contains(EEG.filename, 'UPF')
        EEG.condition = 'UPF';
    elseif contains(EEG.filename, 'PUF')
        EEG.condition = 'PUF';
    else
        EEG.condition = 'PF';
    end

    % create dummy variables
    EEG2 = EEG;
    EEG3 = EEG;
    EEG4 = EEG;

    % save all 4 different EEG files in one cell
    allEEG={EEG; EEG2; EEG3; EEG4};

    % save data in average_reference folder, because at the moment common-average is reference 
    allEEG{1} = pop_editset(allEEG{1}, 'setname', sprintf('CAR_%s',allEEG{1}.setname));
    allEEG{1}.reference = 'average';
    %allEEG{1} = pop_saveset(allEEG{1}, 'filename', allEEG{1}.setname, 'filepath', 'Y:\Rosina\PreprocessedData\average_reference\');

    % re-reference to linked mastoid & save
    % do I need to interpolate?? A1 & A2 wont be relevant for analysis-->no
    allEEG{2} = pop_reref(allEEG{2}, [40 41]) %A1 and A2 are mastoids
    allEEG{2} = pop_editset(allEEG{2}, 'setname', sprintf('LM_%s',allEEG{2}.setname));
    allEEG{2}.reference = 'linkedMastoids';
    %allEEG{2} = pop_saveset(allEEG{2}, 'filename', allEEG{2}.setname, 'filepath', 'Y:\Rosina\PreprocessedData\mastoid_reference\');

    % re-reference to REST reference & save
    % download REST extension for eeglab
    % https://www.neuro.uestc.edu.cn/name/shopwap/do/index/content/96
    %pop_REST_reref(EEG3)
    % oder rest_reref()
    allEEG{3}.data = allEEG{3}.data(1:39,:,:);%exclude auxillary electrodes for rest
    allEEG{3}.chanlocs = allEEG{3}.chanlocs(1:39);
    allEEG{3}.nbchan=39;
    allEEG{3} = ref_infinity(allEEG{3});
    allEEG{3} = pop_editset(allEEG{3}, 'setname', sprintf('REST_%s',allEEG{3}.setname));
    allEEG{3}.reference = 'REST';

    %allEEG{3} = pop_saveset(allEEG{3}, 'filename', allEEG{3}.setname, 'filepath', 'Y:\Rosina\PreprocessedData\REST_reference\');
    
    

    % re-reference to current source density
    % https://psychophysiology.cpmc.columbia.edu/software/CSDtoolbox/tutorial.html
    % https://www.frontiersin.org/articles/10.3389/fnins.2021.660449/full#footnote3
    % https://osf.io/m4vfu
    %MikeCohen writes in his book that a minimum of 64 electrodes should be
    %there???
    cd Z:\Rosina
	allEEG{4}.data=laplacian_perrinX(allEEG{4}.data, [allEEG{4}.chanlocs.X],[allEEG{4}.chanlocs.Y],[allEEG{4}.chanlocs.Z]);
    allEEG{4} = pop_editset(allEEG{4}, 'setname', sprintf('CSD_%s',allEEG{4}.setname));
    allEEG{4}.reference = 'CSD';

    %allEEG{4} = pop_saveset(allEEG{4}, 'filename', allEEG{4}.setname, 'filepath', 'Y:\Rosina\PreprocessedData\CSD_reference\');
    

    % 2nd Multiverse step: Select certain electrodes (see above)
    % loop to run through all folders and subfolders
    for i = 1:4 %folders refernce method
        for j=1:4 % subfolders electrode groups
        % go to each subfolder
        cd(fullfile(folders{i}, sprintf('elec_group_%d', j)));
        EEG_temp=allEEG{i}; % create temporary EEG
        EEG_temp.data = allEEG{i}.data(channels{j},:,:); % select channels of interest
        EEG_temp.elec_group = sprintf('elec_group_%d_', j);
        EEG_temp = pop_editset(EEG_temp, 'setname', [sprintf('elec_group_%d_', j), EEG_temp.setname]); %edit setname
        EEG_temp = pop_saveset(EEG_temp, 'filename', EEG_temp.setname, 'filepath', fullfile(folders{i}, sprintf('elec_group_%d', j))); % save with new name
        end
    end

end

% %% Tryout if rereferencing yielded in a difference in plotting
% x=[-200:1999];
% figure;
% hold on;
% for i=1:34
% plot(x, allEEG{4}.data(2,:,i), 'y')
% end
% for i=1:34
% plot(x, allEEG{3}.data(2,:,i), 'g')
% end
% for i=1:34
% plot(x, allEEG{1}.data(2,:,i), 'r')
% end
% for i=1:34
% plot(x, allEEG{2}.data(2,:,i), 'b')
% end
% 
% 
