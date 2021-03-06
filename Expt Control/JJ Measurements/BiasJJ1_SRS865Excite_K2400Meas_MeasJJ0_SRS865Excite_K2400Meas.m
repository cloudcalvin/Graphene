function CrossTalk_data = BiasJJ1_SRS865Excite_K2400Meas_MeasJJ0_SRS865Excite_K2400Meas(RunTime,LoadResistor0, Vb0, Vthresh0, Vreset0, ResetTime0, LoadResistor1, Vbias1, VG, tag)
%UNTITLED2 Summary of this function goes here
%   Sweeps JJ1 looking for switching as a function of time in JJ0.

% Connect to Instruments
KMeasJJ0=deviceDrivers.Keithley2400();
KMeasJJ0.connect('23');
KMeasJJ1=deviceDrivers.Keithley2400();
KMeasJJ1.connect('24');
LockinJJ0=deviceDrivers.SRS865;
LockinJJ0.connect('10');
LockinJJ1=deviceDrivers.SRS865;
LockinJJ1.connect('9');

StartTime = clock;
FileName = strcat('VJJ_vs_Time_with_Switch_', datestr(StartTime, 'yyyymmdd_HHMMSS_'), tag,'.mat');

CrossTalk_data = struct('VG',VG,'Time',[],'VJJ0',[],'VJJ1',[],'Clicks0',0,'Ib0',Vb0/LoadResistor0,'Ireset0',Vreset0/LoadResistor0,'Vthresh0',Vthresh0,'JJ1_Bias',Vbias1/LoadResistor1);

figure;
pause on
save_flag=0;

LockinJJ0.DC=Vb0;
LockinJJ1.DC=Vbias1;
CrossTalk_data.Time(1)=0;
CrossTalk_data.VJJ0(1)=KMeasJJ0.value;
CrossTalk_data.VJJ1(1)=KMeasJJ1.value;
tic

i=0;
temp_time=toc;
while temp_time<RunTime
    i=i+1;
    drawnow;

    VJJ_temp0=KMeasJJ0.value;
    VJJ_temp1=KMeasJJ1.value;    
    temp_time = toc;
        
    CrossTalk_data.Time(i+1)=temp_time;
    CrossTalk_data.VJJ0(i+1)=VJJ_temp0;
	CrossTalk_data.VJJ1(i+1)=VJJ_temp1;
        
    if VJJ_temp0>Vthresh0
        LockinJJ0.DC=Vreset0;
        pause(ResetTime0);
        LockinJJ0.DC=Vb0;
        CrossTalk_data.Clicks0=CrossTalk_data.Clicks0+1;
    end
    subplot(2,1,1)
    plot(CrossTalk_data.Time/60,CrossTalk_data.VJJ0/10^-3); grid on; xlabel('Time (min)'); ylabel('JJ Voltage (mV)');
    subplot(2,1,2)
    plot(CrossTalk_data.Time/60,CrossTalk_data.VJJ1/10^-3); grid on; xlabel('Time (min)'); ylabel('JJ Voltage (mV)');
    
    %Save every 10 mins
    if save_flag+toc>600
        save(FileName,'CrossTalk_data')
        save_flag=save_flag-600;
    end
end
%Final Save
save(FileName,'CrossTalk_data')

%Disconnect from instruments
KMeasJJ0.disconnect();
KMeasJJ1.disconnect();
LockinJJ1.disconnect();
LockinJJ0.disconnect();
clear KMeasJJ0
clear KMeasJJ1
clear LockinJJ0
clear LockinJJ1
end

