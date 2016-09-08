function [ output_args ] = measureFWHMdepletion(rlabel2,ztotalsteps,Edfield)

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%²âÁ¿Í¼x·½Ïò
h=figure(5);
%set(h,'position',[860 400 400 300]);
hold on
plot(rlabel2,Edfield(floor(ztotalsteps),:).^2,'b');
t21=['Excitation and depletion along x'];
title(t21,'fontsize',30);
xlabel ('r/nm','fontsize',40)
ylabel ('I/I_0','fontsize',40)
set(gca,'FontSize',30)
%  n41=['C:\Users\pku\Desktop\images\' t21];
% saveas(h,n41);

end

