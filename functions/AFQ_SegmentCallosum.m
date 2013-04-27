function afq = AFQ_SegmentCallosum(afq)
% THIS FUNCTION IS STILL BEING DEVELOPED
% Segment the callosal fibers into 7 segments
%
% afq = AFQ_SegmentCallosum(afq)
%
%
%
% Copyright Jason D. Yeatman April 2012

%% Create callosum ROIs and fiber groups
% First creat a callosal fiber group from the wholebrain fiber group for
% each subject
for ii = 1:length(AFQ_get(afq,'numsubs'))
    % Load Dt6
    dt = dtiLoadDt6(AFQ_get(afq,'dt6path',ii));
    % Create an ROI of the corpus callosum
    ccRoi = dtiNewRoi('callosum','r',dtiFindCallosum(dt.dt6,dt.b0,dt.xformToAcpc,[],[],1));
    % Load wholebrain fiber group
    wholebrainFg = AFQ_get(afq,'wholebrain fg', ii);
    % Create callosum fiber group
    ccFg = dtiIntersectFibersWithRoi([],'and',2,ccRoi,wholebrainFg);
    ccFg.name = 'callosumFG';
    % Save callosum ROI and fiber group
    fgPath = fullfile(afq.sub_dirs{ii},'fibers',ccFg.name);
    roiPath = fullfile(afq.sub_dirs{ii},'ROIs',ccRoi.name);
    dtiWriteFiberGroup(ccFg,fgPath);
    dtiWriteRoi(ccRoi,roiPath);
end

%% Set up parameters for AFQ_AddNewFiberGroup

% List of ROI names for different callosal segments
roi1Names = {'L_Occipital.nii.gz' 'L_Post_Parietal.nii.gz' ...
    'L_Sup_Parietal.nii.gz' 'L_Motor.nii.gz' 'L_Sup_Frontal.nii.gz' ...
    'L_Ant_Frontal.nii.gz' 'L_Orb_Frontal.nii.gz'};
roi2Names = {'R_Occipital.nii.gz' 'R_Post_Parietal.nii.gz' ...
    'R_Sup_Parietal.nii.gz' 'R_Motor.nii.gz' 'R_Sup_Frontal.nii.gz' ...
    'R_Ant_Frontal.nii.gz' 'R_Orb_Frontal.nii.gz'};
% Add in the path to the templates folder to the roi paths
tdir = fullfile(AFQ_directories,'templates','callosum');
for ii = 1:length(roi1Names)
    roi1Names{ii} = fullfile(tdir,roi1Names{ii});
    roi2Names{ii} = fullfile(tdir,roi2Names{ii});
end
    
% List of the names of the callosal segments
fgNames = {'CC_Occipital.mat' 'CC_Post_Parietal.mat' ...
    'CC_Sup_Parietal.mat' 'CC_Motor.mat' 'CC_Sup_Frontal.mat' ...
    'CC_Ant_Frontal.mat' 'CC_Orb_Frontal.mat'};
% The name of the fiber group file to segment
segFgName = 'callosumFG.mat';

%% Segment callosum into it's different projections and add to afq struct

for ii = 1:length(fgNames)
    afq = AFQ_AddNewFiberGroup(afq,fgNames{ii},roi1Names{ii},roi2Names{ii},1,1,0,segFgName);   
end

return