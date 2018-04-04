% Reloading stress-strain reconstruction

%% interpolate all reloading curves for averaging
strain0 = 0: 1e-5: 0.15;
stress0 = -80: 1e-2: 20; % MPa

% define the starts and ends of avalanches
starts = ys_idx;
ends = reload_idx;

% initiate interpolated stress/strain
N_analysis = length(ends)-1; % number of reloading process to be analyzed
interp_LCstrain = nan(N_analysis, length(stress0));
interp_DCstress = nan(N_analysis, length(strain0));

% plot all reloading process
figure(3)
h = gcf;
col = get(gca, 'ColorOrder');
hold all
for ii=1:length(ends)
    zero_stress = stress(starts(ii));   % rezeroing stress
    zero_strain = strain(ends(ii));     % rezeroing strain
    
    % plot raw reloading processes
    reload_end = length(strain);
    plot(strain(ends(ii):reload_end)-zero_strain, (stress(ends(ii):reload_end)-zero_stress), 'LineWidth', 2, 'Color', col(mod(ii+3, 7)+1,:)) 
    hold all
    
    % plot in-series (LC) and in-parallel (DC) interpolation
    interp_LCstrain(ii, :) = interpLC(strain(ends(ii):reload_end)-zero_strain, (stress(ends(ii):reload_end)-zero_stress), stress0);
    interp_DCstress(ii, :) = interpDC(strain(ends(ii):reload_end)-zero_strain, (stress(ends(ii):reload_end)-zero_stress), strain0);
    plot(interp_LCstrain(ii,:), stress0, 'LineStyle', '--', 'Color', col(mod(ii+3, 7)+1,:))
    plot(strain0, interp_DCstress(ii,:), 'LineStyle', '-', 'Color', col(mod(ii+3, 7)+1,:))
end
xlabel('Strain'); ylabel('Stress (MPa)')

% averaging
LCstrain = nanmean(interp_LCstrain);   
DCstress = nanmean(interp_DCstress);
LCstrain_err = nanstd(interp_LCstrain)/sqrt(N_analysis);
DCstress_err = nanstd(interp_DCstress)/sqrt(N_analysis);

%% plot averaged reloading curves
fill_between_linesX = @(X1,X2,Y,C) fill( [X1 fliplr(X2)],  [Y fliplr(Y)], C , 'FaceAlpha', 0.2, 'LineStyle', 'none');
fill_between_linesY = @(X,Y1,Y2,C) fill( [X fliplr(X)],  [Y1 fliplr(Y2)], C , 'FaceAlpha', 0.2, 'LineStyle', 'none');

n_seg = 1;      % error bar stands fo n_seg ste
n_desamp = 10;  % block averaging to reduce image size

% series
x = stress0;        % reconstructed stress
y = LCstrain;       % reconstructed strain
err = LCstrain_err; % error bar

figure(4)
hold all
xax = blockaver(x(~isnan(y)), n_desamp);
yax = blockaver(y(~isnan(y)), n_desamp);
eax = blockaver(err(~isnan(y)), n_desamp);
fill_between_linesX(yax-n_seg*eax, yax+n_seg*eax, xax, col(1,:))
h(1) = plot(y, x, 'Color', col(1,:), 'LineWidth',2);

% parallel
x = strain0;
y = DCstress;
err = DCstress_err;

figure(4)
hold all
xax = blockaver(x(~isnan(y)), n_desamp);
yax = blockaver(y(~isnan(y)), n_desamp);
eax = blockaver(err(~isnan(y)), n_desamp);
fill_between_linesY(xax, yax+n_seg*eax, yax-n_seg*eax, col(2,:))
h(2) = plot(x, y, 'Color', col(2,:), 'LineWidth', 2);

xlim([0.0019, 0.0038])
ylim([-80, 10]);
xlabel('Reconstruct Strain'); ylabel('Reconstruct Stress (MPa)'); box on;

%% fit for the Hookean elastic loading part
f_idx = yax > -300 & yax < -100;
pp= polyfit(xax(f_idx), yax(f_idx), 1);
h(3) = plot(xax, pp(1)*xax + pp(2), 'k--', 'LineWidth', 1);
legend(h, {'In-Series', 'In-Parallel', 'Elastic Fit'}, 'Location', 'SouthEast')

%% plot sigle reloading curve to demo in-parallel, in-series reconstruction
ii = 21;
zero_stress = stress(starts(ii));
zero_strain = strain(ends(ii));
reload_end = length(strain);

figure(5)
plot(strain(ends(ii):reload_end)-zero_strain, (stress(ends(ii):reload_end)-zero_stress), 'LineWidth', 2, 'Color', 'k') 
hold all

xx = interpLC(strain(ends(ii):reload_end)-zero_strain, (stress(ends(ii):reload_end)-zero_stress), stress0);
yy = interpDC(strain(ends(ii):reload_end)-zero_strain, (stress(ends(ii):reload_end)-zero_stress), strain0);
plot(xx, stress0, 'LineStyle', '-', 'Color', col(1,:), 'LineWidth', 1)
plot(strain0, yy, 'LineStyle', '-', 'Color', col(2,:), 'LineWidth', 1)
legend({'Reloading $O_1$', 'In-Series', 'In-Parallel'}, 'Interpreter', 'latex')
xlabel('Reconstruct Strain'); ylabel('Reconstruct Stress (MPa)');