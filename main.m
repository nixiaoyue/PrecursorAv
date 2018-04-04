% this code searches the previous maximum stress,
% rezeroed the reloading curves according to the previous maximum

%% load the sample data
data = importdata('B22P1 LC.txt');
disp = data.data(:,1);      % depth into sample (nm)
load0  = data.data(:,2);    % load on sample (uN)
time = data.data(:,3);      % testing time (s)

fs = 200; % sampling frequency

% pillar geometry:
D = 500e-9; % pillar diameter (m)
E = 140e9;  % Young's modulus (Pa)

%% find the previous maximum stress
% run index searching analysis
reload_idxLC

% find the previous maximum stress
prev_max_search

%% Reloading stress-strain interpolation for precursor reconstruction
avg_reconstruct