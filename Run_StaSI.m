function handles = Run_StaSI(hObject, handles)
%% The main function of the generalized change point algorithm
% Input: 
%       single 1D trace (eff) or multiple traces selected in dialog
% Output:
%       G: structure, recording all the optimum clusterings under different
%   number of states
%       MDL: the minimum discription length, used to determine the optimum
%   number of states
%       states: the fitting based on the optimum number of states
%       eff: group the traces of different data together, if use input eff
%   trace, the output will be identical to the input
%       eff_fit: the fitting of all the feasible number of states, up to 30
%       breaks: recording the separations among different traces
%       output: recording several important parameters for potential usage
%       records: structure, recording the analysis of each loaded trace,
%   and also recording the location of each trace in the output eff
%       excluded: structure, recording all the traces not being used

%% step 1: loading the traces and change-points detection
set(handles.status,'String','loading...')
[filelist,datadir] = uigetfile({'*.mat';'*.dat'},'multiselect','on');
groups = [];
breaks = [];
records = struct([]);
excluded = struct([]);
% make a judgement if use input trace or use loaded traces
if iscell(filelist)
    numfiles = numel(filelist);
    eff = [];
elseif isstr(filelist)
    numfiles = 1;
    eff = [];
else % use the input eff and detect the change point
    return
end
% load each trace and detect change points
set(handles.status,'String','Student t test...')
for n = 1 : numfiles
    if numfiles == 1
        fullname = strcat(datadir, filelist);
    else
        fullname = strcat(datadir, filelist{n});
    end
    data = importdata(fullname);
    try
        temp = data.obsf;% for FRET trace in Landes group
    catch ME
        temp = data.raw_data;
    end
    %temp = data.denf;
    T1 = numel(eff)+1;
    sd(n) = w1_noise(diff(temp))/1.4;% estimate the noise level
    points = change_point_detection(temp);% change points detection
    eff = [eff, temp];% group traces together
    T2 = numel(eff);
    breaks(end+1) = T2;
    groups = cat(2,groups,[T1, points+T1; points+T1-1, T2]);
end
try
    sd = sd_control;
catch ME
    sd = max(sd);% use the maximum noise level among these traces as the global noise level
end

%% step 2 and 3: clustering the segments and calculate MDL
set(handles.status,'String','Grouping...')
[G, Ij, Tj] = clustering_GCP(eff, groups);
G = G(end:-1:1);% flip the G
n_mdl = min(30, numel(G));% calculate up to 30 states
MDL = zeros(1,n_mdl);
eff_fit = zeros(n_mdl, numel(eff));
set(handles.status,'String','Determining the optimum number of states...')
for i = 1:n_mdl;
    [MDL(i), eff_fit(i,:)] = MDL_piecewise(Ij, Tj, G(i), eff, groups, sd, breaks);
end
%[~, q] = min(MDL);%now the BIC is actually MDL

handles.MDL = MDL;
handles.eff = eff;
handles.eff_fit = eff_fit;
handles.breaks = breaks;

guidata(hObject, handles);