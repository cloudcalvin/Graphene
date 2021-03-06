%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%     What and How?      %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphene Sweeping Software
% version 2.0 in July 2016 by BBN Graphene Trio: Jess Crossno, Evan Walsh,
% and KC Fong
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [data] = VNA_vs_Vgate(VgateList, InitialWaitTime, measurementWaitTime)
pause on;
GateController = deviceDrivers.Keithley2400();
GateController.connect('23');

%%%%%%%%%%%%%%%%%%%%%       PLOT DATA     %%%%%%%%%%%%%%%%%%%%%%%%
function plot_data()
    figure(737); clf; imagesc(20*log10(abs(data.S)));
    %xlabel('V_{bias} (V)'); ylabel('Lockin X (V)');
end

%%%%%%%%%%%%%%%%%%%%%     RUN THE EXPERIMENT      %%%%%%%%%%%%%%%%%%%%%%%%%
GateController.value = VgateList(1);
pause(InitialWaitTime);
for k=1:length(VgateList)
    GateController.value = VgateList(k);
    pause(measurementWaitTime);
    % data.X(k) = Lockin.X; data.Y(k) = Lockin.Y;
    result = GetVNASpec_VNA();
    data.S(k,:) = result.S;
    plot_data()
end
data.Freq = result.Freq;

%%%%%%%%%%%%%%%%%%%%    BACK TO DEFAULT, CLEAN UP     %%%%%%%%%%%%%%%%%%%%%%%%%
GateController.value = 0;
GateController.disconnect();
pause off; clear result GateController;
end