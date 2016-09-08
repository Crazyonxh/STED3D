function [ output_args ] = measureFWHMresidue(rlabel1,ztotalsteps,residue)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    h=figure(5);
 %   set(h,'position',[860 400 400 300]);
    hold on
    plot(rlabel1,residue(floor(ztotalsteps),:),'g');
    t21=['Excitation and depletion along x'];
    title(t21,'fontsize',30);
    xlabel ('r/nm','fontsize',40)
    ylabel ('I/I_0','fontsize',40)
    set(gca,'FontSize',30)
    %  n41=['C:\Users\pku\Desktop\images\' t21];
    % saveas(h,n41);

end

