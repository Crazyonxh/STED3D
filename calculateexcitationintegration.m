function [IIe1,IIe2,IIe3] = calculateexcitationintegration(alpha,ztotalsteps,rtotalsteps,zsteps,rsteps )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%入射激发光%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %下面利用公式计算衍射积分
    Ie1=zeros(ztotalsteps,rtotalsteps);
    Ie2=zeros(ztotalsteps,rtotalsteps);
    Ie3=zeros(ztotalsteps,rtotalsteps);
    h = waitbar(0,'Incident excitation beam calculation.');
    for zz=1:ztotalsteps                   %坐标为（r,z）的点在数组中的位置为(zz,j)
        for rr=1:rtotalsteps
           kz=(zz-1)*2*3.14/zsteps;    %z光程坐标
           kr=(rr-1)*2*3.14/rsteps;
           fun1=@(theta)(cos(theta).^(1/2)).*sin(theta).*(1+cos(theta)).*besselj(0,kr.*sin(theta)).*exp(1i*kz*cos(theta));
           fun2=@(theta)cos(theta).^(1/2).*sin(theta).^2.*besselj(1,kr.*sin(theta)).*exp(1i*kz*cos(theta));
           fun3=@(theta)cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*besselj(2,kr.*sin(theta)).*exp(1i*kz*cos(theta));
           Ie1(zz,rr)= quad(fun1,0,alpha);
           Ie2(zz,rr)= quad(fun2,0,alpha);
           Ie3(zz,rr)= quad(fun3,0,alpha);
        end;
        waitbar(zz/(ztotalsteps-1+eps),h,sprintf(['Incident excitation beam calculation completed ' num2str(zz/(ztotalsteps-1+eps),0.1)]));
    end;
    close(h) 


    IIe1=[flipud(conj(Ie1));Ie1(2:ztotalsteps,:)];
    IIe2=[flipud(conj(Ie2));Ie2(2:ztotalsteps,:)];
    IIe3=[flipud(conj(Ie3));Ie3(2:ztotalsteps,:)];


end

