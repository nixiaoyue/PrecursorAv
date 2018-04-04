% parallel reconstruction
% the function input raw stress-strain data: stress_DC, strain_DC,
% prescribe strain0 for interpolation (for later averaging)
% output interp_DCstress as the reconstructed stress

function interp_DCstress = interpDC(strain_DC, stress_DC, strain0)
k = 1; % clean the non-monotonically increasing strain values
while ~isempty(k)
  k = find(diff(strain_DC) <= 0);
  stress_DC(k+1) = [];
  strain_DC(k+1) = [];
end
if length(stress_DC) < 2
    interp_DCstress = nan(1, length(strain0));
else
    interp_DCstress = interp1(strain_DC, stress_DC, strain0);
end
