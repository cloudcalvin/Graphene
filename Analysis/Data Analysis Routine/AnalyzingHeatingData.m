% Analyzing Heating Data
Vgate = [-8 -4 -2 -1 0 1 2 4 8];
Vgate = Vgate + 0.2;

% Reading out Current and dV/dI from HotElectron Data Files
GenerateHotElectronDataFileList
for k = 1:length(Vgate)
    [Rsd_kOhm(k,:), Isd_nA] = ReadHotElectronDataFile(DataFileList, ParametersList, Vgate(k));
end

% Analyzing Noise Spectrums
GenerateNoiseSpectrumDataFileList
for k=1:length(Vgate)
    [dummy1, Freq_GHz, NoisePow_W(k,:), T_K] = AnalyzeSpectrums(DataFileList, ParametersList, Vgate(k), 1.165e9, 100e6, 0);
end
clear dummy1;

% Fitting noise data around zero current for Johnson noise
for k=1:length(Vgate)
    [JohnsonNoise(k), IsdNull(k)] = Fit4Extremum(Isd_nA', NoisePow_W(k,:)', 0, 8, 1)
    title(Vgate(k));
end

for j=1:length(Vgate)
    dV = 1e-6*diff([Isd_nA(1:(length(Isd_nA)*0.5-0.5)) 0 Isd_nA((length(Isd_nA)*0.5+0.5):length(Isd_nA))]).*Rsd_kOhm(j,:);
    HalfLengthdV = length(dV)*0.5-0.5;
    for k=1:HalfLengthdV
        Vsd(j, k) = -sum(dV(k:HalfLengthdV));
    end
    Vsd(j, HalfLengthdV+1) = 0;
    for k=(HalfLengthdV+2):length(dV)
        Vsd(j, k) = sum(dV(HalfLengthdV+2:k));
    end
    figure; plot(Isd_nA, Vsd(j,:), '.'); ylabel('V_{sd} [V]'); title(Vgate(j));
    R_kOhm(j,:) = 1e6*Vsd(j,:)./Isd_nA;
    figure; plot(Isd_nA, R_kOhm(j,:), '.'); ylabel('Resistance [\Omega]'); title(Vgate(j));
end

% Calculating the Heating Power
for k=1:length(Vgate)
    HeaterPower_pW(k,:) = (Isd_nA-IsdNull(k)).^2.*R_kOhm(k,:)*1e-3;
    I2(k,:) = (Isd_nA-IsdNull(k)).^2;
end

% Calculating the graphene electron temperature
mean(JohnsonNoise)
std(JohnsonNoise)/mean(JohnsonNoise)
NoiseT_K = (NoisePow_W-7.482e-12)/5.539e-13;
csvwrite('HeatingPower.dat', HeaterPower_pW)
%save('Isd_nA.dat', 'Isd_nA', '-ASCII', '-tabs')
csvwrite('NoiseT.dat', NoiseT_K)
csvwrite('ISquare.dat', I2)

%for k=1:length(Vgate)
%    [dummy1, dummy2, ThermalConductance(k)] = Fit4Extremum(Isd_nA', NoiseT_K(k,:)', 0, 8, 1)
%    title(Vgate(k));
%end
%clear dummy1 dummy2