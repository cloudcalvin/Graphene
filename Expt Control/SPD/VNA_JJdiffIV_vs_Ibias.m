%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%     What and How?      %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphene Sweeping Software
% version 2.0 in July 2016 by BBN Graphene Trio: Jess Crossno, Evan Walsh,
% and KC Fong
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [data] = VNA_JJdiffIV_vs_Ibias(BiasList, InitialWaitTime, measurementWaitTime)
pause on;
Lockin = deviceDrivers.SRS865();
Lockin.connect('4');

%%%%%%%%%%%%%%%%%%%%%       PLOT DATA     %%%%%%%%%%%%%%%%%%%%%%%%
function plot_data()
    figure(799); clf; plot(BiasList(1:k), data.X, '.-'); grid on;
    xlabel('V_{bias} (V)'); ylabel('Lockin X (V)');
    figure(737); clf; imagesc(20*log10(abs(data.S)));
    %xlabel('V_{bias} (V)'); ylabel('Lockin X (V)');
end

%%%%%%%%%%%%%%%%%%%%%     RUN THE EXPERIMENT      %%%%%%%%%%%%%%%%%%%%%%%%%
Lockin.DC = BiasList(1);
pause(InitialWaitTime);
for k=1:length(BiasList)
    Lockin.DC = BiasList(k);
    pause(measurementWaitTime);
    data.X(k) = Lockin.X; data.Y(k) = Lockin.Y;
    result = GetVNASpec_VNA();
    data.S(k,:) = result.S;
    save('backup.mat')
    plot_data()
end
data.Freq = result.Freq;

%%%%%%%%%%%%%%%%%%%%    BACK TO DEFAULT, CLEAN UP     %%%%%%%%%%%%%%%%%%%%%%%%%
%Keithley.value = 0;
Lockin.DC = 0;
Lockin.disconnect(); 
pause off; clear result Lockin;
end