%%
%     Signal Processing problems
%     Time Series Denoising
%%

clear all;
close all;
clc;

% Running-mean time series filter

% generate the signal itself
srate = 1000;
time_span = 0:1/srate:3;
n = length(time_span);
p = 15; % points of data

% adding noise to signal
noise_level = 5;
amp1 = interp1(rand(p,1)*30,linspace(1,p,n)); % random signal generated
noise = noise_level*randn(size(time_span));
signal = amp1+noise;

figure(1);
subplot(2,1,1);
plot(time_span,amp1);
hold on;
plot(time_span,signal);
hold off;
legend("Clean","Noisy");
grid on;

filtered_signal = zeros(1,length(time_span));

k = 20; % order?
for i=k+1:n-k-1
    filtered_signal(i) = mean(signal(i-k:i+k));
end

subplot(2,1,2);
plot(time_span,filtered_signal);
hold on;
plot(time_span,amp1,Color="red");
hold off;
legend("Filtered signal","Actual signal");
grid on;
window_ms = (2*k+1)*1000/srate; % to get window size in ms