function GammaMQT = GammaMQT(Ib, Ic, RN, ETH)
%Gives JJ macroscopic quantum tunneling rate as a function of bias current 
%(Ib) for a given critical current (Ic), normal metal resistance (RN), 
%Thouless energy (ETH), and temperature (T)

%Constants of nature
hbar = 1.05e-34; %reduced Planck's constant (m^2kg/s)
e = 1.6e-19; %Electron charge (C)

gammaJJ=Ib/Ic; %Normalized bias current

CJJ=hbar/(ETH*RN); %Effective JJ capacitance (F)
wp0=sqrt(2*e*Ic/(hbar*CJJ)); %Zero bias plasma frequency (rad/s)
wp=wp0*(1-gammaJJ.^2).^0.25; %Plasma frequency (rad/s)
Q=wp*RN*CJJ; %Quality Factor

EJ0=0.5*hbar*Ic/e; %Josephson Coupling Energy (J)
DU=2*EJ0*(sqrt(1-gammaJJ.^2)-gammaJJ.*acos(gammaJJ)); %Barrier height (J)

GammaMQT=12*wp.*sqrt(3*DU./(2*pi*hbar*wp)).*exp(-7.2*(1+.87./Q).*DU./(hbar*wp)); %MQT switching rate

end
