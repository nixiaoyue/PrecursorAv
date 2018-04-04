% run index searching analysis first, i.e. reload_idxLC 
% which outputs: stress, strain, ys_idx, reload_idx as inputs to this code

%% find the maximum stress idx between reloading idx
max_idx = nan(length(reload_idx)-1,1);
for ii = 1:length(reload_idx)-1
    ss_seg= stress(reload_idx(ii):reload_idx(ii+1));
    max_idx(ii) = reload_idx(ii)-1+find(ss_seg==max(ss_seg));
end

%% Plot stress-strain, reload start point, yield start point
figure(2)
cla
col = get(gca, 'ColorOrder');
h(1)=plot(strain, stress, '--.', 'MarkerSize', 4);
hold all
h(2)=plot(strain(reload_idx),stress(reload_idx), 'o');
h(3)=plot(strain(max_idx), stress(max_idx), 'o');

% mark out the 21th to 23rd reloading process for rezeroing demo
for jj = 21:23
    h(jj-17) = plot(strain(reload_idx(jj):max_idx(jj)), stress(reload_idx(jj):max_idx(jj)), 'LineWidth', 2, 'Color', col(mod(jj-20+3, 7)+1,:));
    plot(strain(reload_idx(jj))*[1, 1], [0, 600], ':', 'Color', col(mod(jj-20+3, 7)+1,:), 'LineWidth', 1)
    plot([0, max(strain)], stress(max_idx(jj-1))*[1, 1], ':', 'Color', col(mod(jj-20+3, 7)+1,:), 'LineWidth', 1)
end
legend(h, {'Data', 'Reload Start', 'Previous Maximum', 'Reloading $O_1$', 'Reloading $O_2$', 'Reloading $O_3$'}, ...
    'interpreter', 'latex', 'Location', 'SouthEast')
xlim([0, 0.06]); ylim([0, 550]);
xlabel('Strain'); ylabel('Stress (MPa)')