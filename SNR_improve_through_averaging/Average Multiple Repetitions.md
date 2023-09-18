# Signal-to-Noise Ratio Improvement Through Averaging

In this tutorial, we explore a simple yet effective method for increasing the signal-to-noise ratio in a time series signal, known as time synchronous averaging. The concept involves cutting the time series into smaller epochs aligned with the onset of an event and averaging these epochs together to attenuate or eliminate noise while preserving the signal.

## Procedure Overview

1. **Epoch Creation**: The initial step is to cut the continuous time series into smaller, aligned snippets or epochs around the onset of specific events.

2. **Averaging**: Each of these epochs is averaged together at corresponding time points across repetitions. The process involves summing the data points and dividing by the number of repetitions.

3. **Noise Reduction**: The result is a cleaner version of the signal with reduced noise compared to individual epochs.

## Implementation in MATLAB

The tutorial uses simulated data and MATLAB to demonstrate the procedure:

1. **Event Generation**: A derivative of a Gaussian function is created to represent the event. Multiple instances of this event (30 in this example) are inserted into random positions within the noisy data set.

2. **Noise Addition**: Noise, similar in magnitude to the signal, is added to the data.

3. **Visualization**: The data set is plotted, showing the inserted events with noise.

4. **Signal Averaging**: A data matrix is generated, containing the time series for each event. These time series are averaged together to produce a cleaner representation of the underlying signal.

## Important Considerations

- The success of this method assumes knowledge of the actual onset times of the events in the system.
- If onset times are unknown and events occur sporadically, alternative techniques like template matching or pattern recognition algorithms should be used for event detection.

[Artefact Removal Using this process and Template Matching](https://www.udemy.com/course/signal-processing/learn/lecture/11864600#overview)

```matlab
clc; clear all; close all;

% create event (derivative of Gaussian)
k = 100; % duration of event in time points
event = diff(exp( -linspace(-2,2,k+1).^2 ));
event = event./max(event); % normalize to max=1
% event onset times
Nevents = 30;
onsettimes = randperm(10000-k);
onsettimes = onsettimes(1:Nevents);

% put event into data
data = zeros(1,10000);
for ei=1:Nevents
	data(onsettimes(ei):onsettimes(ei)+k-1) = event;
end
% add noise
data = data + .7*randn(size(data));

% plot data
figure(1), clf
subplot(211)
plot(data)
title("Data set");

% plot one event
subplot(212)
plot(1:k, data(onsettimes(3):onsettimes(3)+k-1),...
1:k, event,'linew',3)

%% extract all events into a matrix
datamatrix = zeros(Nevents,k);
for ei=1:Nevents
	datamatrix(ei,:) = data(onsettimes(ei):onsettimes(ei)+k-1);
end

figure(2), clf
subplot(4,1,1:3)
imagesc(datamatrix)
xlabel('Time'), ylabel('Event number')
title('All events');

subplot(414)
plot(1:k,mean(datamatrix), 1:k,event,'linew',3)
xlabel('Time'), ylabel('Amplitude')
legend({'Averaged';'Ground-truth'})
title('Average events')
%% done.
```

![[Pasted image 20230916221739.png]]
![[Pasted image 20230916221758.png]]