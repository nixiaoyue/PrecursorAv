% Automatic search for the index for onset of reloading, 
% and onset of unloading, or previous maximum stress

%% convert load-displacement to true stress-strain data
[stress, strain, up] = convert_stress0(load0*1e-6, disp*1e-9, E, D);
stress = stress/1e6; % present stress in MPa

% lowpass
[z, p, g] = butter(4, 20/(fs/2), 'low');
[sos,g] = zp2sos(z, p, g);
f = dfilt.df2sos(sos,g);
ss_lp = f.filter(stress);
ss_lp = flipud(f.filter(flipud(ss_lp))); % filtfilt

% use low-passed stress rate to find the unloading segment
seg_idx = find(diff(ss_lp) < -std(diff(ss_lp)));    % unloading segment
select_idx = find(diff(seg_idx)>fs);                % separate unloading segment
reload_idx = seg_idx(select_idx);                   % onset of reloading
ys_idx = seg_idx([1, select_idx'+1]);               % onset of unloading

% each reloading has to refer to a updated yield stress
while length(ys_idx)>length(reload_idx)
    ys_idx(end)=[];
end

%% plot to check all auto-searched points
figure(1)
plot(strain, stress, 'LineWidth', 1)
hold all
plot(strain(seg_idx), stress(seg_idx),'.')
plot(strain(ys_idx), stress(ys_idx),'o')
plot(strain(reload_idx),stress(reload_idx), 'o')
xlim([0, 0.06]); ylim([0, 550]);
xlabel('Strain'); ylabel('Stress (MPa)')