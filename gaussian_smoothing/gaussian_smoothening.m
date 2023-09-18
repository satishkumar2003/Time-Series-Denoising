%%
%     Signal Processing problems
%     Time Series Denoising
%%

clear all;
close all;
clc;

% generating the signal
srate = 1000;
time = 0:1/srate:3;
n = length(time);
p = 15; % 15 points to interpolate

noiseamp = 5;

amp1 = interp1(rand(p,1)*30,linspace(1,p,n));
noise = noiseamp*rand(size(time));
signal = amp1+noise;

% Gaussian kernel generation

fwhm = 25; % omega

k = 40;
gtime = 1000*(-k:k)/srate;

gaussian_window = exp(-(4*log(2)*gtime.^2/fwhm^2));

% compute empirical FWHM
prePeakHalf = k+dsearchn(gaussian_window(k+1:end)',.5);
postPeakHalf = dsearchn(gaussian_window(1:k)',.5);

empFWHN = gtime(prePeakHalf)-gtime(postPeakHalf);

figure(1)
hold on;
plot(gtime,gaussian_window,'ko-','markerfacecolor','w');
plot(gtime([prePeakHalf postPeakHalf]),gaussian_window([prePeakHalf postPeakHalf]),'m');
hold off;

% normalising Gaussian window to contain unit energy
gaussian_window = gaussian_window/sum(gaussian_window);

filtered_signal = zeros(1,length(time));
for i=k+1:n-k-1
    filtered_signal(i) = sum(signal(i-k:i+k).*gaussian_window);
end

figure(2);
subplot(211);
plot(time,signal);
subplot(212);
plot(time,filtered_signal);
hold on;
plot(time,amp1);
legend("Filtered","Clean    ");