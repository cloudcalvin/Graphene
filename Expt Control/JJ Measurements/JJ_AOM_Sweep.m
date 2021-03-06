function Power_sweep_data = JJ_AOM_Sweep
%Sweeps RF Power input to AOM, takes switching data from JJ with NIDAQ

%NIDAQ Parameters
sampling_rate=50000;
time_total=1200;
time_plot=10;
Vthresh=0.065;

%Start Time and File Name
StartTime = clock;
FileName1 = strcat('Power_Sweep_Data_', datestr(StartTime, 'yyyymmdd_HHMMSS'),'.mat');

%Connect to RF Source
RFsource=deviceDrivers.AgilentN5183A;
RFsource.connect('19');

RFpower=[7.18, 8.44, 9.48, 10.28, 10.95, 11.50, 12.01, 12.47, 15.52, 17.31, 18.56, 19.46, 20.35];
LaserPower=[30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400, 500, 600];

Power_sweep_data=struct('Power_nW',LaserPower,'Rate',[],'Ib',2.5e-6,'VG',20);


TrialString='123';

for i=1:length(RFpower)
	RFsource.power=RFpower(i);
    powerstring=num2str(LaserPower(i));
    tag=strcat('BGB38_',powerstring,'nW_VG_20V_Ib_2p50uA');
    
    for j=1:3
        FileName2 = strcat('VJJ_vs_Time_with_Switch_', datestr(clock, 'yyyymmdd_HHMMSS_'), tag,'_Trial',TrialString(j),'_File',num2str(847+(i-1)*3+j),'.mat');
        VJJvsTime=NIDAQ_ai0(sampling_rate,time_total,time_plot);
        num_peaks(j)=CountPeaks2(VJJvsTime.Voltage_V,Vthresh,sampling_rate*160e-6);
        save(FileName2,'VJJvsTime')
    end
    Power_sweep_data.Rate(i)=sum(num_peaks)/(3*time_total);
    save(FileName1,'Power_sweep_data')
    close all
end

RFsource.disconnect();
clear RFsource;

end

