
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

rr=1:rtotalsteps;
kr=(rr-1)*2*3.14/rsteps;
s=sin(alpha)^2;

a01=betainc(s,1,0.75)*beta(1,0.75)+betainc(s,1,1.25)*beta(1,1.25);
a02=-0.25*(betainc(s,2,0.75)*beta(2,0.75)+betainc(s,2,1.25)*beta(1,2.25));
a1=betainc(s,2,0.75)*beta(2,0.75)/2;
a2=(betainc(s,2,0.75)*beta(2,0.75)-betainc(s,2,1.25)*beta(2,1.25))/8;
b1=(betainc(s,1.5,0.75)*beta(1.5,0.75)+betainc(s,1.5,1.25)*beta(1.5,1.25))/2;
b2=(betainc(s,1.5,0.75)*beta(1.5,0.75)-betainc(s,1.5,1.25)*beta(1.5,1.25))/2;
b41=betainc(s,1.5,0.75)*beta(1.5,0.75);
b42=-betainc(s,1.5,1.25)*beta(1.5,1.25)/4;
b5=betainc(s,1.5,1.25)*beta(1.5,1.25)/8;

kr1=kr/n/2/3.14*lambda1;   




%continuous
a=3.14.*n.*(sqrt(-4*(a01*a02+a1^2))./a01);
b=b1^2/(-4)/(a01*a02+a1^2).*(lambda1/lambda2)^2;

%pulsed
aa=3.14.*n.*(sqrt(-2*(a01*a02+a1^2)/log(2))./a01)
bb=b1^2/(-2)/(a01*a02+a1^2).*(lambda1/lambda2)^2.*log(2)













