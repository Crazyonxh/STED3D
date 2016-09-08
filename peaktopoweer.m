clear
close all

%%%%%%%%%%%%变量输入%%%%%%%%%%%
%%%%系统参数%%%
%数值孔径
NA=1.3;
%折射率
n=1.5;
f=1;
%探测区间的范围，单位为波长
r0=5;
z0=5;
%探测区间的分辨率，单位为步/波长
rsteps=10;
zsteps=10;
%%%%激光参数%%%%%%%

%excitation和sted的波长，单位为纳米
lambda1=635;
lambda2=760;
%激发和退激发的光强|E|^2
Ie0=1;
Id0=60;
%y方向相对x方向的偏振幅度大小tan(beta)=ey/ex0,beta在0到90°之间，45°表示等幅，0度偏振仅沿x方向
betae0=45;
betad0=45;
%y和x方向的偏振相位差，90为左旋，0为线偏振，-90右旋
polarizatione=90; 
polarizationd=90;

%饱和光强
Ids=1;
%选择激发方式，1为连续，2 为脉冲，3为自定义
saturationformula=1;


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


Sexcitationintegrationcalculated=0;
Sdepletionintegrationcalculated=0;
Sexcitationfieldcalculated=0;
Sdepletionfieldcalculated=0;
Sresiduefieldcalculated=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算激发光%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [IIe1,IIe2,IIe3]=calculateexcitationintegration(alpha,ztotalsteps,rtotalsteps,zsteps,rsteps);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%绘图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%画激发光
 [Eefield,Eefield2]=drawexcitationimage(IIe1,IIe2,IIe3,lambda1,Ie0,betae0,polarizatione,ztotalsteps,zsteps,rtotalsteps,rsteps,phip0,zp0,n,f);
Edfieldnew=Eefield;
weight=Eefield;
    residue=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
    for xx=1:2*ztotalsteps-1
        for yy=1:2*rtotalsteps-1
            xcor=ztotalsteps+(xx-ztotalsteps)*lambda1/lambda2;
            ycor=rtotalsteps+(yy-rtotalsteps)*lambda1/lambda2;
            Edfieldnew(xx,yy)=Eefield(round(xcor),round(ycor));
            weight(xx,yy)=0.5+abs(yy-rtotalsteps);
        end;
    end; 
 
    ksteps=100;interval=10;
    etanew=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
    etanew2=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
    flu=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
    flu2=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
    resflu=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
    resflu2=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
    
%   for k=1:2*rtotalsteps-1
%      det(:,k)=sum(Eefield.^2.*weight,2);       
%  end;  
 det=Eefield.^2;
 exweighted=Eefield.^2.*weight.*det;
 flu0=sum(sum(exweighted));
 for k=1:ksteps;
    etanew=1./(1+(k-1)/interval*(Edfieldnew/Edfieldnew(ztotalsteps,rtotalsteps)).^2);
    etanew2=exp(-log(2)*(k-1)/interval*(Edfieldnew/Edfieldnew(ztotalsteps,rtotalsteps)).^2);
    flu=etanew.*Eefield.^2;
    flu2=etanew2.*Eefield.^2;
    resflu=flu.*weight.*det;
    resflu2=flu2.*weight.*det;
    r1(k)=sum(sum(resflu))/flu0;
    r2(k)=sum(sum(resflu2))/flu0;
 end;  

close all
figure(8)
plot((0:ksteps-1)/interval,r1)
xlabel ('I/I_s','fontsize',20)
ylabel ('P_{det}/P_{0det}','fontsize',20)
set(gca,'FontSize',20);
% hold on;plot(sum(flu(:,:,20).*weight./(Eefield.^2)));
% hold on;plot(sum(flu(:,:,30).*weight./(Eefield.^2)));
% hold on;plot(sum(flu(:,:,40).*weight./(Eefield.^2)));
% hold on;plot(sum(flu(:,:,50).*weight./(Eefield.^2)));
figure(9)
xx1=(0:ksteps-1)/interval;
yy1=1./r1;
yy2=-log(r2);
plot((0:ksteps-1)/interval,1./r1);
hold on
% xx=(0:ksteps-1)/interval;
% y=log(1+xx+0.0001)./(xx+0.0001);
% plot(xx,1./y,'g')
xlabel ('I/I_s','fontsize',20)
ylabel ('P_{0det}/P_{det}','fontsize',20)
set(gca,'FontSize',20);
% k=1:ksteps;
% s=1./r1;
% zlabel1=(-ztotalsteps+1:ztotalsteps-1)/zsteps/n*lambda1;
% figure(10)
% plot(zlabel1,sum(exweighted,2))
% hold on;plot(zlabel1,sum(resflu,2))
% xlabel ('z/nm','fontsize',20)
% ylabel ('P_{0det}/P_{det}','fontsize',20)
% set(gca,'FontSize',20);
figure(8)
hold on
plot((0:ksteps-1)/interval,r2,'r')
% hold on
% plot(xx,y,'g')
xlabel ('I/I_s','fontsize',20)
ylabel ('P_{det}/P_{0det}','fontsize',20)
set(gca,'FontSize',20);