%%
%       Signal processing problems, solved in MATLAB and histython
%       Median filter to remove spike noise
%
%%
clear all;
close all;
clc;

% create signal
n = 2000;
signal = cumsum(randn(n,1));
actual_signal = signal;

% proportion of time points to replace with noise
propnoise = 0.05;

% find noise points
noisepnts = randperm(n);
noisepnts = noisepnts(1:round(n*propnoise));

% generate signal and replace points with noise
signal(noisepnts) = 50 + rand(size(noisepnts)) * 100;

figure(2);
histogram(signal,100);

% Step 1: Calculate the histogram of the signal
histogram = hist(signal, 256); % Assuming 256 bins, adjust as needed

% Step 2: Calculate the total number of pixels (data points)
total_pixels = numel(signal);

% Step 3: Initialize variables to store the threshold and maximum between-class variance
threshold = 0;
max_variance = 0;

% Step 4: Iterate through the histogram to find the optimal threshold
for t = 1:255 % Iterate through possible thresholds (1 to 255)
    % Calculate the probability of class 1 (values below threshold)
    prob_class1 = sum(histogram(1:t)) / total_pixels;
    
    % Calculate the probability of class 2 (values at or above threshold)
    prob_class2 = sum(histogram(t+1:end)) / total_pixels;
    
    % Calculate the mean of class 1
    mean_class1 = sum((0:t-1) .* histogram(1:t)) / (prob_class1 * total_pixels);
    
    % Calculate the mean of class 2
    mean_class2 = sum((t:255) .* histogram(t+1:end)) / (prob_class2 * total_pixels);
    
    % Calculate the between-class variance
    between_class_variance = prob_class1 * prob_class2 * (mean_class1 - mean_class2)^2;
    
    % Update threshold if the variance is greater than the current maximum
    if between_class_variance > max_variance
        max_variance = between_class_variance;
        threshold = t;
    end
end

% threshold = graythresh(signal)*max(signal);

spike_indices = signal>threshold;

% Apply median filter
k = 20; % actual window is k*2+1
filtsig = signal;

for ti = 1:length(spike_indices)
    if (spike_indices(ti))
        lowbnd = max(1, ti - k);
        uppbnd = min(ti + k, n);
        filtsig(ti) = median(signal(lowbnd:uppbnd));
    end
end

% plot
figure(1), clf
subplot(211);
plot(1:n, signal, 1:n, filtsig);
legend("Noisy signal", "Filtered signal");
subplot(212);
plot(1:n, filtsig, 1:n, actual_signal);
legend("Filtered signal", "Actual signal");
zoom on
