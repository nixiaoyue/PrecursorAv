% input test variable: load P (N), displacement u (m), 
% input test parameter: Young's modulus E (Pa), pillar diameter D (m)
% output true stress-strain
% with sneddon stiffness correction applied
% note: all calculation done in SI units

function [stress, strain, up] = convert_stress0(P, u, E, D)
A0 = pi*(D/2)^2;            % initial contact area
L0 = 3*D;                   % intiial pillar height, norminal aspect ratio =3:1
C = sqrt(pi)*(1-0.33^2);    % poisson ratio mu_Cu = 0.33

Lp = A0/8/L0./(P-E*A0).^2.*(8*A0*E^2*L0*(L0-u)+P.*(C^2*P+8*E*L0*(u-L0)+C*sqrt(16*A0*E^2*L0*(L0-u)+P.*(C^2*P+16*E*L0*(u-L0)))));
up = L0 - Lp;
strain = P.*Lp/E/A0/L0 - log(Lp/L0);
stress = P.*Lp/A0/L0; % volume conservation