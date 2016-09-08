function [Edfield3d,Edfield3d2]=calculaterandommaskintegration(NA,lambda2,r0,z0,n,f,rsteps,zsteps,Id0,betad0,polarizationd)

%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%
phip0=0;
pold=polarizationd/180*3.14;
betad=betad0/180*3.14;

Ed1=sqrt(Id0)*sin(betad)/lambda2*3.14*f*1E6;
Ed2=sqrt(Id0)*cos(betad)/lambda2*3.14*f*1E6;
ad1=Ed1;
ad2=Ed2*exp(1i*pold);














%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%转角换成弧度单位phi=phi0/180*3.14;
alpha=asin(NA/n);
phip=phip0/180*3.14;
%计算需要计算的矩形区域大小
    %沿着光轴方向
    zmaxstep=floor(z0*zsteps*n);      %z方向的最大步数
    ztotalsteps=zmaxstep+2; %循环从格子zmaxstep-2做到zminstep+2以防止溢出，总步数为ztotalsteps
    %垂直于光轴方向
    rmaxstep=floor(r0*rsteps*n);
    rtotalsteps=rmaxstep+2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%入射激发光%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%下面利用公式计算衍射积分
%xz方向
exdx=zeros(2*ztotalsteps-1 ,2*rtotalsteps-1);
eydx=zeros(2*ztotalsteps-1 ,2*rtotalsteps-1);
ezdx=zeros(2*ztotalsteps-1 ,2*rtotalsteps-1);
exdy=zeros(2*ztotalsteps-1 ,2*rtotalsteps-1);
eydy=zeros(2*ztotalsteps-1 ,2*rtotalsteps-1);
ezdy=zeros(2*ztotalsteps-1 ,2*rtotalsteps-1);
h = waitbar(0,'Incident depletion beam calculation.');
for zz=1:2*ztotalsteps-1                   %坐标为（r,z）的点在数组中的位置为(zz,j)
    for rr=1:2*rtotalsteps-1
        kz=(zz-ztotalsteps)*2*3.14/zsteps;    %z坐标
        kr=(rr-rtotalsteps)*2*3.14/rsteps;
        fun1=@(phi,theta)cos(theta).^(1/2).*sin(theta).*(cos(theta)+(1-cos(theta)).*sin(phi).^2).*exp(1i.*(sin(theta).*kr.*cos(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi);
        fun2=@(phi,theta)cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*cos(phi).*sin(phi).*exp(1i.*(sin(theta).*kr.*cos(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi);
        fun3=@(phi,theta)cos(theta).^(1/2).*sin(theta).^2.*cos(phi).*exp(1i.*(sin(theta).*kr.*cos(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi);
        fun4=@(phi,theta)cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*cos(phi).*sin(phi).*exp(1i.*(-sin(theta).*kr.*sin(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi+pi/2);
        fun5=@(phi,theta)cos(theta).^(1/2).*sin(theta).*(cos(theta)+(1-cos(theta)).*sin(phi).^2).*exp(1i.*(-sin(theta).*kr.*sin(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi+pi/2);
        fun6=@(phi,theta)cos(theta).^(1/2).*sin(theta).^2.*cos(phi).*exp(1i.*(-sin(theta).*kr.*sin(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi+pi/2);
        exdx(zz,rr)=-1i*ad1/pi*quad2d(fun1,0,2*pi,0,alpha);
        eydx(zz,rr)=1i*ad1/pi*quad2d(fun2,0,2*pi,0,alpha);
        ezdx(zz,rr)=1i*ad1/pi*quad2d(fun3,0,2*pi,0,alpha);
        exdy(zz,rr)=-1i*ad2/pi*quad2d(fun4,0,2*pi,0,alpha);
        eydy(zz,rr)=-1i*ad2/pi*quad2d(fun5,0,2*pi,0,alpha);
        ezdy(zz,rr)=1i*ad2/pi*quad2d(fun6,0,2*pi,0,alpha);
    end;
    waitbar(zz/(2*ztotalsteps-1+eps)/(rsteps+zsteps)*zsteps,h,sprintf(['Incident depletion beam xz calculation completed ' num2str(zz/(2*ztotalsteps-1+eps)/(rsteps+zsteps)*zsteps,0.1)]));
end;

edx=exdx+exdy;
edy=eydx+eydy;
edz=ezdx+ezdy;
Edfield3d=sqrt(edx.*conj(edx)+edy.*conj(edy)+edz.*conj(edz));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%下面利用公式计算衍射积分
%xz方向
exdx2=zeros(2*rtotalsteps-1 ,2*rtotalsteps-1);
eydx2=zeros(2*rtotalsteps-1 ,2*rtotalsteps-1);
ezdx2=zeros(2*rtotalsteps-1 ,2*rtotalsteps-1);
exdy2=zeros(2*rtotalsteps-1 ,2*rtotalsteps-1);
eydy2=zeros(2*rtotalsteps-1 ,2*rtotalsteps-1);
ezdy2=zeros(2*rtotalsteps-1 ,2*rtotalsteps-1);
kz=0;
for xx=1:2*rtotalsteps-1                   %坐标为（r,z）的点在数组中的位置为(zz,j)
    for yy=1:2*rtotalsteps-1
        xcord=-(xx-rtotalsteps)*2*3.14/rsteps;    %z坐标
        ycord=-(yy-rtotalsteps)*2*3.14/rsteps;
        [phip kr]=cart2pol(xcord,ycord);
        fun1=@(phi,theta)cos(theta).^(1/2).*sin(theta).*(cos(theta)+(1-cos(theta)).*sin(phi).^2).*exp(1i.*(sin(theta).*kr.*cos(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi);
        fun2=@(phi,theta)cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*cos(phi).*sin(phi).*exp(1i.*(sin(theta).*kr.*cos(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi);
        fun3=@(phi,theta)cos(theta).^(1/2).*sin(theta).^2.*cos(phi).*exp(1i.*(sin(theta).*kr.*cos(phi-phip)+cos(theta).*kz)).*maskfunction(-theta,-phi);
        fun4=@(phi,theta)cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*cos(phi).*sin(phi).*exp(-1i.*(sin(theta).*kr.*sin(phi-phip)+cos(theta).*kz)).*maskfunction(-theta+pi/2,-phi+pi/2);
        fun5=@(phi,theta)cos(theta).^(1/2).*sin(theta).*(cos(theta)+(1-cos(theta)).*sin(phi).^2).*exp(-1i.*(sin(theta).*kr.*sin(phi-phip)+cos(theta).*kz)).*maskfunction(-theta+pi/2,-phi+pi/2);
        fun6=@(phi,theta)cos(theta).^(1/2).*sin(theta).^2.*cos(phi).*exp(1i.*(-sin(theta).*kr.*sin(phi-phip)+cos(theta).*kz)).*maskfunction(-theta+pi/2,-phi+pi/2);
        exdx2(xx,yy)=-1i*ad1/pi*quad2d(fun1,0,2*pi,0,alpha);
        eydx2(xx,yy)=1i*ad1/pi*quad2d(fun2,0,2*pi,0,alpha);
        ezdx2(xx,yy)=1i*ad1/pi*quad2d(fun3,0,2*pi,0,alpha);
        exdy2(xx,yy)=-1i*ad2/pi*quad2d(fun4,0,2*pi,0,alpha);
        eydy2(xx,yy)=-1i*ad2/pi*quad2d(fun5,0,2*pi,0,alpha);
        ezdy2(xx,yy)=1i*ad2/pi*quad2d(fun6,0,2*pi,0,alpha);
    end;
    waitbar(xx/(2*rtotalsteps-1+eps)/(rsteps+zsteps)*rsteps+1/(rsteps+zsteps)*zsteps,h,sprintf(['Incident depletion beam xy calculation completed ' num2str(xx/(2*rtotalsteps-1+eps)/(rsteps+zsteps)*rsteps+1/(rsteps+zsteps)*zsteps,0.1)]));
end;
close(h) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%绘图%%%%%%%%%%%%%%%%%%%%%%%%%%%
edx2=exdx2+exdy2;
edy2=eydx2+eydy2;
edz2=ezdx2+ezdy2;
Edfield3d2=sqrt(edx2.*conj(edx2)+edy2.*conj(edy2)+edz2.*conj(edz2));


zlabel2=(-ztotalsteps+1:ztotalsteps-1)/zsteps/n*lambda2;
rlabel2=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda2;   

h=figure(3);
imagesc(rlabel2,zlabel2,Edfield3d.^2);
t41=['Depletion electic field |E|^2 on xz'];
title(t41,'fontsize',20);
xlabel ('r/nm','fontsize',20)
ylabel ('z/nm','fontsize',20)
colormap hot
colorbar
axis image
 set(gca,'FontSize',20);
 
 
h=figure(4);
imagesc(rlabel2,rlabel2,Edfield3d2.^2);
t41=['Depletion electic field |E|^2 on xy'];
title(t41,'fontsize',20);
xlabel ('x/nm','fontsize',20)
ylabel ('y/nm','fontsize',20)
colormap hot
colorbar
axis image
 set(gca,'FontSize',20);

end

