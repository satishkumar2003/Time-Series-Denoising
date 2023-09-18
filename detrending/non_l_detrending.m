clc;
clear all;
close all;

n = 10000;
t = (1:n);
k = 10;
slowdrift = interp1(100*randn(1,k),linspace(1,k,n));
signal = slowdrift + 20*randn(1,n);

figure(1);
hold on;
plot(t,signal);

% fit a 4th-order polynomial
p = polyfit(t,signal,4);

y_ = polyval(p,t);
residual = signal - y_;

plot(t,y_);
plot(t,residual);
hold off;
legend("Original","Polyfit","DeTrended signal");

orders = (5:40);
% sum of squared errors
sse1 = zeros(1,length(orders));
for i=1:length(orders)
    y_ = polyval(polyfit(t,signal,orders(i)),t);
    sse1(i) = sum((y_-signal).^2)/n;
end

% Bayes information criteria

BIC = n*log(sse1)+orders*log(n);

[best,idx] = min(BIC);

figure(2);
plot(orders,BIC);
hold on;
plot(orders(idx),best,'o');
hold off;
legend("Bayes information criterion","Optimal order");

residual_better = signal - polyval(polyfit(t,signal,orders(idx)),t);

figure(3);
hold on;
plot(t,signal);
plot(t,residual_better);
hold off;

legend("Signal","Optimal order detrending");