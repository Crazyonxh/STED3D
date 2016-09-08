clear
close all
NA=1.0;
%折射率
n=1.5;
f=1;
%探测区间的范围，单位为波长
r0=0.3;
z0=1;
%探测区间的分辨率，单位为步/波长
rsteps=600;
zsteps=30;
%%%%激光参数%%%%%%%

%excitation和sted的波长，单位为纳米
lambda1=635;
lambda2=760;
%激发和退激发的光强|E|^2
Ie0=1;
Id0=60;
Is0=1;
%y方向相对x方向的偏振幅度大小tan(beta)=ey/ex0,beta在0到90°之间，45°表示等幅，0度偏振仅沿x方向
betae0=45;
betad0=45;
phip0=0;
%y和x方向的偏振相位差，90为左旋，0为线偏振，-90右旋
polarizatione=90; 
polarizationd=90;

pole=polarizatione/180*3.14;
pold=polarizationd/180*3.14;

phip=phip0/180*3.14;
betae=betae0/180*3.14;
betad=betad0/180*3.14;

Ee1=sqrt(Ie0)*sin(betae)/lambda1*3.14*f*1E6;
Ee2=sqrt(Ie0)*cos(betae)/lambda1*3.14*f*1E6;

ae1=Ee1;
ae2=Ee2*exp(1i*pole);

Ed1=sqrt(Id0)*sin(betad)/lambda2*3.14*f*1E6;
Ed2=sqrt(Id0)*cos(betad)/lambda2*3.14*f*1E6;

ad1=Ed1;
ad2=Ed2*exp(1i*pold);

Es1=sqrt(Is0)*sin(betad)/lambda2*3.14*f*1E6;
Es2=sqrt(Is0)*cos(betad)/lambda2*3.14*f*1E6;

as1=Es1;
as2=Es2*exp(1i*pold);
%ad2=0;
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


exex=-ae1*1i*(Ie1+cos(2*phip)*Ie3);
eyex=-ae1*1i*(sin(2*phip)*Ie3);
ezex=-ae1*2*(cos(phip)*Ie2);
 
exey=-ae2*1i*sin(2*phip)*Ie3;
eyey=-ae2*1i*(Ie1-cos(2*phip)*Ie3);
ezey=-ae2*2*sin(phip)*Ie2;

eex=exex+exey;
eey=eyex+eyey;
eez=ezex+ezey;

Eefield=sqrt(eex.*conj(eex)+eey.*conj(eey)+eez.*conj(eez));


exdx=ad1*(Id1*exp(1i*phip)-0.5*Id2*exp(-1i*phip)+0.5*Id3*exp(3i*phip));
eydx=-0.5*ad1*1i*(Id2*exp(-1i*phip)+Id3*exp(3i*phip));
ezdx=ad1*1i*(Id4-Id5*exp(2i*phip));
%e0=ey
exdy=-0.5*ad2*1i*(Id2*exp(-1i*phip)+Id3*exp(3i*phip));
eydy=ad2*(Id1*exp(1i*phip)+0.5*Id2*exp(-1i*phip)-0.5*Id3*exp(3i*phip));
ezdy=-ad2*(Id4+Id5*exp(2i*phip));

edx=exdx+exdy;
edy=eydx+eydy;
edz=ezdx+ezdy;

Edfield=sqrt(edx.*conj(edx)+edy.*conj(edy)+edz.*conj(edz));

a01=betainc(s,1,0.75)*beta(1,0.75)+betainc(s,1,1.25)*beta(1,1.25);
a02=-0.25*(betainc(s,2,0.75)*beta(2,0.75)+betainc(s,2,1.25)*beta(1,2.25));
a1=betainc(s,2,0.75)*beta(2,0.75)/2;
a2=(betainc(s,2,0.75)*beta(2,0.75)-betainc(s,2,1.25)*beta(2,1.25))/8;
b1=(betainc(s,1.5,0.75)*beta(1.5,0.75)+betainc(s,1.5,1.25)*beta(1.5,1.25))/2;
b2=(betainc(s,1.5,0.75)*beta(1.5,0.75)-betainc(s,1.5,1.25)*beta(1.5,1.25))/2;
b41=betainc(s,1.5,0.75)*beta(1.5,0.75);
b42=-betainc(s,1.5,1.25)*beta(1.5,1.25)/4;
b5=betainc(s,1.5,1.25)*beta(1.5,1.25)/8;



% figure(1)
% exsquare=ae1^2*(a01^2+2*(a02+a2*cos(2*phip))*a01*kr.^2)/4;
% plot(kr,exsquare,kr,eex.*conj(eex));
% 
% 
% figure(2)
% eysquare=(ae2/1i)^2*(a01^2+2*(a02-a2*cos(2*phip))*a01*kr.^2)/4;
% plot(kr,eysquare,kr,eey.*conj(eey));
% 
% figure(3)
% ezsquare=(ae1^2*(cos(phip))^2+(ae2/1i)^2*(sin(phip))^2)*a1^2*kr.^2;
% plot(kr,ezsquare,kr,eez.*conj(eez));

kr1=kr/n/2/3.14*lambda1;    
figure(94)
esquare0=((ae1^2+(ae2/1i)^2)*a01^2+2*((ae1^2+(ae2/1i)^2)*(a01*a02+a1^2)+(ae1^2-(ae2/1i)^2)*(a01*a2+a1^2)*cos(2*phip))*kr.^2)/4;
s0=(ae1^2+(ae2/1i)^2)*a01^2/4;
s1=2*((ae1^2+(ae2/1i)^2)*(a01*a02+a1^2)+(ae1^2-(ae2/1i)^2)*(a01*a2+a1^2)*cos(2*phip))/4;
esquare=s0*exp((s1/s0)*kr.^2);
esquare1=s0*besselj(0,sqrt(-s1/s0)*2*kr);
plot(kr1,esquare1,kr1,Eefield.*conj(Eefield));
% axis([0 1.9/n/2/3.14*lambda1 0.5E7 2E7])
% set(gca,'ytick',0.5E7:3E6:2E7)
% t21=['Excitation and depletion along x'];
% title(t21,'fontsize',30);
% xlabel ('r/nm','fontsize',36)
% ylabel ('I/I_0','fontsize',36)
% set(gca,'FontSize',30)

% figure(5)
% dxsquare=(ad1^2*b1^2+0.25*(ad1-ad2/1i)^2*b2^2-ad1*(ad1-ad2/1i)*b1*b2*cos(phip))*kr.^2/4;
% plot(kr,dxsquare,kr,edx.*conj(edx));
% 
% figure(6)
% dysquare=((ad2/1i)^2*b1^2+0.25*(ad1-ad2/1i)^2*b2^2-(ad2/1i)*(ad1-ad2/1i)*b1*b2*cos(phip))*kr.^2/4;
% plot(kr,dysquare,kr,edy.*conj(edy));
% 
% figure(7)
% dzsquare=((ad1-ad2/1i)^2*b41^2+2*((ad1-ad2/1i)^2*b42-b5*(ad1^2-(ad2/1i)^2)*cos(2*phip))*b41*kr.^2)/4;
% plot(kr,dzsquare,kr,edz.*conj(edz));


kr2=kr/n/2/3.14*lambda2;             
figure(98)
dsquare=((ad1-ad2/1i)^2*b41^2+(ad1^2+(ad2/1i)^2)*b1^2*kr.^2+(ad1-ad2/1i)^2*(0.5*b2^2-b1*b2*cos(phip)+2*b41*b42)*kr.^2-2*b5*(ad1-ad2/1i)*cos(2*phip)*kr.^2)/4;
plot(kr2,dsquare,kr2,Edfield.*conj(Edfield));
% axis([0 1.6/n/2/3.14*lambda2 -1E7 6E7])
% % t21=['Excitation and depletion along x'];
% % title(t21,'fontsize',30);
% xlabel ('r/nm','fontsize',36)
% ylabel ('I/I_0','fontsize',36)
% set(gca,'FontSize',30)

Isat=a01^2*(as1^2+(as2/1i)^2)/4;
Id=0:10:60;
FWHM=lambda1./3.14./n./(sqrt(-4*(a01*a02+a1^2))./a01)./sqrt(1+b1^2/(-4)/(a01*a02+a1^2).*(lambda1/lambda2)^2.*Id);
FWHM2=lambda1./3.14./n./(sqrt(-2*(a01*a02+a1^2)/log(2))./a01)./sqrt(1+b1^2/(-2)/(a01*a02+a1^2).*(lambda1/lambda2)^2.*log(2).*Id);
HWHM=FWHM/2;
HWHM2=FWHM2/2;
experiment=[128 68 52 44 39 35 32];%n=1.5
experiment2=[128 71 54 45 39 35 32];%n=1.5
figure(99)
plot(Id,HWHM,'b')
hold on;
plot(Id,experiment,'r')

figure(100)
plot(Id,HWHM2,'k')
hold on;
plot(Id,experiment2,'r')