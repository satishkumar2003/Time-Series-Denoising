- In signals such as this, if the objective is to preserve all trends of the data and only eliminate the spikes![[Pasted image 20230911172621.png]]
	- mean filtering is bad as it would lift up all samples in vicinity of the spike
	- gaussian filtering is bad as it would do the same but in a smoother manner
	- TKEO algorithm would not give as an optimal result as it preserves mostly the spikes
- Median smoothing would work here as it would never select the spike in a large enough window as it would always be the largest element
- Generate the signal
```matlab
% create signal
n = 2000;
signal = cumsum(randn(n,1));
actual_signal=signal;
% proportion of time points to replace with noise
propnoise = .05;
% find noise points
noisepnts = randperm(n);
noisepnts = noisepnts(1:round(n*propnoise));
% generate signal and replace points with noise
signal(noisepnts) = 50+rand(size(noisepnts))*100;
```
- pick a threshold through the graph
```matlab
% visual-picked threshold
threshold = 40;
```
![[Pasted image 20230911172756.png]]
- After this , consider a window size and perform the median replacement only for the data points above the threshold
```matlab
% find data values above the threshold
suprathresh = find( signal>threshold );
% initialize filtered signal
filtsig = signal;
% loop through suprathreshold points and set to median of k
k = 20; % actual window is k*2+1
for ti=1:length(suprathresh)
	% find lower and upper bounds
	lowbnd = max(1,suprathresh(ti)-k); % to avoid scenarios at edge indices
	uppbnd = min(suprathresh(ti)+k,n);
	% compute median of surrounding points
	filtsig(suprathresh(ti)) = median(signal(lowbnd:uppbnd));
end
```

- The filtered and actual signals look as follows![[Pasted image 20230911173017.png]]
### Otsu's method of Thresholding

- This method focusses on automatic selection of threshold from the histogram
- ![[Pasted image 20230911173758.png]]
- Varying levels of noise with their histograms![[Pasted image 20230911173917.png]]
- GLOBAL Thresholding
	- Select an initial estimate for the global threshold, T (e.g. mean of intensity)
	- Segment the image using T into regions C1 and C2 above and below T
	- Compute the average intensity of pixels at Cl and C2 as and respectively
	- Set new threshold T = 0.5*(mt + nt2)
	- Repeat steps 2 to until difference between successive T becomes small (defined b a threshold)
- Otsu's Global Thresholding method
	- This method involves iterating through all possible threshold values and calculating a measure of spread for the pixel levels each side of the threshold { foreground vs background in binarization processes like grayscale to blackAndWhite }
	- ![[otsuOrig.png]]
	- Choosing a threshold value say 3, we calculate the statistical parameters from the histogram![[Pasted image 20230912141235.png]]
	- Following this we calculate the ***within-class variance*** which is the weighted sum of the two variances weighted by their ***"weights"***
	- We perform this process for all possible threshold values![[Pasted image 20230912141629.png]]
	- It can be seen that for the threshold equal to 3, as well as being used for the example, also has the lowest sum of weighted variances. Therefore, this is the final selected threshold. All pixels with a level less than 3 are background, all those with a level equal to or greater than 3 are foreground. As the images in the table show, this threshold works well.
- By a bit of manipulation, you can calculate what is called the ***between class variance***, which is far quicker to calculate.![[Pasted image 20230912142122.png]]
- The threshold with the *maximum between class variance* also has the *minimum within class variance*. So it can also be used for finding the best threshold and therefore due to being simpler is a much better approach to use.
- ![[Pasted image 20230912141900.png]]
- 