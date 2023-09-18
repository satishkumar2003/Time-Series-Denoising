- Similar to the mean-smoothing filter but instead of a direct mean, we take a weighted mean with gaussian coefficients with the current sample considered at the location of the mean
- ![[Pasted image 20230910190848.png]]
- ![[Pasted image 20230910190940.png]]
- A gaussian filter tends to be more smoother than a mean-smoothing filter
	- ![[Pasted image 20230910191005.png]]
- $\omega$ -> full-width at half-maximum![[Pasted image 20230910191127.png]]
- We first generate the signal itself along with the intended noise signal
```matlab
% generating the signal
srate = 1000;
time = 0:1/srate:3;
n = length(time);
p = 15; % 15 points to interpolate
noiseamp = 5;
amp1 = interp1(rand(p,1)*30,linspace(1,p,n));
noise = noiseamp*rand(size(time));
signal = amp1+noise;
```
![[Pasted image 20230910192947.png]]

- Generate the gaussian kernel by generating a window holding Gaussian coefficients for a given $k$ and $\omega=FWHM$ 
```matlab
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
```
- Increasing $\omega$ will increase smoothening
- $k$ is preferrably adjusted to make sure that the gaussian window doesnt extend too much while also maintaining the trends of the distribution![[Pasted image 20230910193514.png]]
- To maintain same energy of the actual signal before and after filtering, the gaussian filter is normalised to have unit energy
```python
gaussian_window = gaussian_window/sum(gaussian_window);
```

- After applying the filter to the signal we obtain![[Pasted image 20230910194147.png]]
- Upon closer inspection we observe the nature of the gaussian filter![[Pasted image 20230910194212.png]]
- We observe similar edge effects as that of running-mean filter
- But we are able to control the edge effect by changing the value of k which is the size of the Gaussian window, k=400![[Pasted image 20230910204310.png]]
- Importance of Normalizing Gaussian interval
	- Without normalization![[Pasted image 20230910204412.png]]
