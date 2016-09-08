close all;
clear
NA=1.4;
%折射率
n=1.5;
f=1;
%探测区间的范围，单位为波长
r0=0.2;
z0=1;
%探测区间的分辨率，单位为步/波长
rsteps=30;
zsteps=30;
f=1
%%%%激光参数%%%%%%%

%excitation和sted的波长，单位为纳米
lambda1=635;
lambda2=760;
%激发和退激发的光强|E|^2
Ie0=1;
Id0=10;
%y方向相对x方向的偏振幅度大小tan(beta)=ey/ex0,beta在0到90°之间，45°表示等幅，0度偏振仅沿x方向
betae0=90;
betad0=45;
phip0=0;
%y和x方向的偏振相位差，90为左旋，0为线偏振，-90右旋
polarizatione=90; 
polarizationd=90;

pole=polarizatione/180*3.14;

phip=phip0/180*3.14;
betae=betae0/180*3.14;

Ee1=sqrt(Ie0)*sin(betae)/lambda1*3.14*f*1E6;
Ee2=sqrt(Ie0)*cos(betae)/lambda1*3.14*f*1E6;

ae1=Ee1;
ae2=Ee2*exp(1i*pole);


%%%%%%输出参数%%%%%%%%
%xz观察平面旋转角
phip0=0;
zp0=0;
Sexcitation=1;
Sdepletion=1;

Sdrawexcitationimage=1;
Sdrawdepletionimage=1;
Ssaturation=1;

Smeasure=0;

Srandommask=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%转角换成弧度单位phi=phi0/180*3.14;
alpha=asin(NA/n);             
%计算需要计算的矩形区域大小
    %沿着光轴方向
zmaxstep=floor(z0*zsteps*n);      %z方向的最大步数
ztotalsteps=zmaxstep+2; %循环从格子zmaxstep-2做到zminstep+2以防止溢出，总步数为ztotalsteps
%垂直于光轴方向
rmaxstep=floor(r0*rsteps*n);
rtotalsteps=rmaxstep+2;
rlabel1=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda1;   
rlabel2=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda2;   


h = waitbar(0,'Incident excitation beam calculation.');
 for zz=1:1                   %坐标为（r,z）的点在数组中的位置为(zz,j)
        for rr=1:rtotalsteps
           kz=(zz-1)*2*3.14/zsteps;    %z光程坐标
           kr=(rr-1)*2*3.14/rsteps;
           fun1=@(theta)(cos(theta).^(1/2)).*sin(theta).*(1+cos(theta)).*besselj(0,kr.*sin(theta)).*exp(1i*kz*cos(theta));
           fun2=@(theta)cos(theta).^(1/2).*sin(theta).^2.*besselj(1,kr.*sin(theta)).*exp(1i*kz*cos(theta));
           fun3=@(theta)cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*besselj(2,kr.*sin(theta)).*exp(1i*kz*cos(theta));
           fun4=@(theta)(cos(theta).^(1/2).*sin(theta).*(1+cos(theta)).*besselj(1,kr.*sin(theta))).*exp(1i*kz*cos(theta));
           fun5=@(theta)(cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*besselj(1,kr.*sin(theta))).*exp(1i*kz*cos(theta));
           fun6=@(theta)(cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*besselj(3,kr.*sin(theta))).*exp(1i*kz*cos(theta));
           fun7=@(theta)(cos(theta).^(1/2).*sin(theta).^2.*besselj(0,kr.*sin(theta))).*exp(1i*kz*cos(theta));
           fun8=@(theta)(cos(theta).^(1/2).*sin(theta).^2.*besselj(2,kr.*sin(theta))).*exp(1i*kz*cos(theta));           
           Ie1(zz,rr)= quad(fun1,0,alpha);
           Ie2(zz,rr)= quad(fun2,0,alpha);
           Ie3(zz,rr)= quad(fun3,0,alpha);
           Id1(zz,rr)= quad(fun4,0,alpha);
           Id2(zz,rr)= quad(fun5,0,alpha);
           Id3(zz,rr)= quad(fun6,0,alpha);
           Id4(zz,rr)= quad(fun7,0,alpha);
           Id5(zz,rr)= quad(fun8,0,alpha);
        end;
 waitbar(zz/(ztotalsteps-1+eps),h,sprintf(['Incident excitation beam calculation completed ' num2str(zz/(ztotalsteps-1+eps),0.1)]));
 end;
     close(h) 
rr=1:rtotalsteps;
kr=(rr-1)*2*3.14/rsteps;
s=sin(alpha)^2;



aa=betainc(s,1,0.75)*beta(1,0.75)+betainc(s,1,1.25)*beta(1,1.25)-0.25*(betainc(s,2,0.75)*beta(2,0.75)+betainc(s,2,1.25)*beta(1,2.25))*kr.^2;
a=aa/2;
figure(1);
plot(kr,Ie1,kr,a)
bb=betainc(s,2,0.75)*beta(2,0.75)/2*kr;
b=bb/2;
figure(2);
plot(kr,Ie2,kr,b)
cc=(betainc(s,2,0.75)*beta(2,0.75)-betainc(s,2,1.25)*beta(2,1.25))/8*kr.^2;
c=cc/2;
figure(3);
plot(kr,Ie3,kr,c)
dd=(betainc(s,1.5,0.75)*beta(1.5,0.75)+betainc(s,1.5,1.25)*beta(1.5,1.25))/2*kr;
d=dd/2;
figure(4);
plot(kr,Id1,kr,d)
ee=(betainc(s,1.5,0.75)*beta(1.5,0.75)-betainc(s,1.5,1.25)*beta(1.5,1.25))/2*kr;
e=ee/2;
figure(5);
plot(kr,Id2,kr,e)
ff=0*kr;
f=ff/2;
figure(6);
plot(kr,Id3,kr,f)
gg=betainc(s,1.5,0.75)*beta(1.5,0.75)-betainc(s,1.5,1.25)*beta(1.5,1.25)/4*kr.^2;
g=gg/2;
figure(7);
plot(kr,Id4,kr,g)
hh=betainc(s,1.5,1.25)*beta(1.5,1.25)/8*kr.^2;
h=hh/2;
figure(8);
plot(kr,Id5,kr,h)


% exex=-ae1*1i*(Ie1+cos(2*phip)*Ie3);
% eyex=-ae1*1i*(sin(2*phip)*Ie3);
% ezex=-ae1*2*(cos(phip)*Ie2);
% %e0=ey
% exey=-ae2*1i*sin(2*phip)*Ie3;
% eyey=-ae2*1i*(Ie1-cos(2*phip)*Ie3);
% ezey=-ae2*2*sin(phip)*Ie2;
% 
% eex=exex+exey;
% eey=eyex+eyey;
% eez=ezex+ezey;
% 
% Eefield=sqrt(eex.*conj(eex)+eey.*conj(eey)+eez.*conj(eez));
% 
% a01=betainc(s,1,0.75)*beta(1,0.75)+betainc(s,1,1.25)*beta(1,1.25);
% a02=-0.25*(betainc(s,2,0.75)*beta(2,0.75)+betainc(s,2,1.25)*beta(1,2.25));
% a2=(betainc(s,2,0.75)*beta(2,0.75)-betainc(s,2,1.25)*beta(2,1.25))/8;
% exsquare=ae1^2*(a01^2+2*(a02+a2*cos(2*phip)*a01*kr.^2));