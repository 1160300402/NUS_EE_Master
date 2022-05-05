clc;
clear;

k = linspace(0, 3000);
y1 = 1 ./ k;
y2 = 100 ./ (100 + k);
y3 = (1 + log(k)) ./ k;
y4 = (1 + 5*log(k)) ./ k;
y5 = 2.^(-0.002*k);
figure;
plot(k, y1, k,y2, k,y3, k,y4, k,y5,'linewidth', 2);
legend('1/k','100/(100+k)', '(1 + log(k))/k','(1 + 5log(k))/k','2^(-0.002*k)')
ylim([0 0.4]);
yline(0.005,'--')
xlabel('K')
ylabel('Learning Rate')
