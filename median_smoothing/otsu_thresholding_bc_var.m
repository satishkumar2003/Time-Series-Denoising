clc;
clear all;
close all;
img = imread("8-FigureA.1-1.png");

[histImg,counts] = imhist(img);

P = histImg/sum(histImg);

max = 0;
sigma(1) = 0;

for i=2:255
    p1 = sum(P(1:i));
    p2 = sum(P(i+1:256));

    mu1 = sum((0:i-1)'.*P(1:i))/p1;
    mu2 = sum((i:255)'.*P(i+1:256))/p2;
    
    sigma(i) = p1*p2*((mu1-mu2)^2);

    if sigma(i)>max
        max = sigma(i);
        threshold = i-1;
    end
end

bw_img = img>threshold;

figure(1);
subplot(2,2,1:2);

subplot(2,2,3);
imshow(img);
subplot(2,2,4);
imshow(bw_img);