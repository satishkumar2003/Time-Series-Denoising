clc;
clear all;
close all;

% Assuming 'signal' is your 1D signal array
t = 0:1/1000:1;
signal = sin(2*pi*8*t); % Your signal data here
spike_points = randi(1000,[1,randi([25 200])]);
signal(spike_points) = signal(spike_points) + (rand(1)+1)*10;

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

% Step 5: Apply the threshold to the signal
binary_signal = signal > threshold;

% Step 6: Display the original signal and the binary result
figure;
subplot(3, 1, 1);
plot(signal);
title('Original Signal');

subplot(3,1,2);
hist(signal,256);

subplot(3, 1, 3);
plot(binary_signal);
title('Binary Signal (Otsu)');
