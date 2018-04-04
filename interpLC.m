% series reconstruction
% the function input raw stress-strain data: stress_LC, strain_LC,
% prescribe stress0 for interpolation (for later averaging)
% output interp_LCstrain as the reconstructed stress

function interp_LCstrain = interpLC(strain_LC, stress_LC, stress0)
k = 1; % clean the non-monotonically increasing strain values
while ~isempty(k)
  k = find(diff(stress_LC) <= 0);
  stress_LC(k+1) = [];
  strain_LC(k+1) = [];
end
if length(stress_LC) < 2
    interp_LCstrain = nan(1, length(stress0));
else
    interp_LCstrain = interp1(stress_LC, strain_LC, stress0);
end