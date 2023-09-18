clc;
clear all;
close all;

n = 2000;
signal = cumsum(randn(1,n)) + linspace(-30,30,n);

detsignal = detrend(signal);

figure(1);
plot(1:n,signal,1:n,detsignal);
legend("Signal","Detrended signal");