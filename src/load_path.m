function [wekaPath rootdir] = load_path()
% FVQITPATH Returns the path where the application is installed.
%
% Authors  : Iago Porto-Diaz, Oscar Fontenla-Romero, Amparo Alonso-Betanzos
%            Laboratory for Research and Development in Artificial Intelligence
%            (LIDIA Group) Universidad of A Coruna

%% Load subdirectories.
[dirs rootdir] = subdirs();
addpath(dirs{:});

%% Load weka jar.
wekajar = loadWeka([rootdir filesep 'lib' filesep 'weka']);

%% Set weka path.
wekaPath = ['-cp ' '"' wekajar '"'];



function [dirs rootdir] = subdirs()
% DIRS Returns FVQIT's subdirs
%
% Authors  : Iago Porto-Diaz, Oscar Fontenla-Romero, Amparo Alonso-Betanzos
%            Laboratory for Research and Development in Artificial Intelligence
%            (LIDIA Group) Universidad of A Coruna

% Find the fragment in the path string

if datenum(version('-date')) >= datenum('May 6 2004')
 d = dbstack('-completenames');
 rootdir = fileparts(d(1).file);
else
 d = dbstack; 
 rootdir = fileparts(d(1).name);
end   


if 0
    % Might be a relative path: convert to absolute
    olddir = pawd; cd(rootdir);
    rootdir = pawd;
    cd(olddir);
end

subdirs0 = {
    'aggregate_ranker';
    'complex_measures';
    'feature_selection';
    'feature_selection/mi_0.9';
    'lib/mutual_info';
    'lib/weka';
    'svm_ranker';
    'threshold';
};

t=1;
for i=1:length(subdirs0)    
	s = cellstr(subdirs0{i});
    if(isdir(fullfile(rootdir, s{:})))
        dirs{t}=subdirs0{i};
        t=t+1;
    end
end
for i = 1:length(dirs)
	s = cellstr(dirs{i});
	dirs{i} = fullfile(rootdir, s{:});
end

