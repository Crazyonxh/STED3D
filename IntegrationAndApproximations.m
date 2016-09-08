close all;
clear
NA=1.4;
%������
n=1.5;
f=1;
%̽������ķ�Χ����λΪ����
r0=0.2;
z0=1;
%̽������ķֱ��ʣ���λΪ��/����
rsteps=30;
zsteps=30;
f=1
%%%%�������%%%%%%%

%excitation��sted�Ĳ�������λΪ����
lambda1=635;
lambda2=760;
%�������˼����Ĺ�ǿ|E|^2
Ie0=1;
Id0=10;
%y�������x�����ƫ����ȴ�Сtan(beta)=ey/ex0,beta��0��90��֮�䣬45���ʾ�ȷ���0��ƫ�����x����
betae0=90;
betad0=45;
phip0=0;
%y��x�����ƫ����λ�90Ϊ������0Ϊ��ƫ��-90����
polarizatione=90; 
polarizationd=90;

pole=polarizatione/180*3.14;

phip=phip0/180*3.14;
betae=betae0/180*3.14;

Ee1=sqrt(Ie0)*sin(betae)/lambda1*3.14*f*1E6;
Ee2=sqrt(Ie0)*cos(betae)/lambda1*3.14*f*1E6;

ae1=Ee1;
ae2=Ee2*exp(1i*pole);


%%%%%%�������%%%%%%%%
%xz�۲�ƽ����ת��
phip0=0;
zp0=0;
Sexcitation=1;
Sdepletion=1;

Sdrawexcitationimage=1;
Sdrawdepletionimage=1;
Ssaturation=1;

Smeasure=0;

Srandommask=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ת�ǻ��ɻ��ȵ�λphi=phi0/180*3.14;
alpha=asin(NA/n);             
%������Ҫ����ľ��������С
    %���Ź��᷽��
zmaxstep=floor(z0*zsteps*n);      %z����������
ztotalsteps=zmaxstep+2; %ѭ���Ӹ���zmaxstep-2����zminstep+2�Է�ֹ������ܲ���Ϊztotalsteps
%��ֱ�ڹ��᷽��
rmaxstep=floor(r0*rsteps*n);
rtotalsteps=rmaxstep+2;
rlabel1=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda1;   
rlabel2=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda2;   


h = waitbar(0,'Incident excitation beam calculation.');
 for zz=1:1                   %����Ϊ��r,z���ĵ��������е�λ��Ϊ(zz,j)
        for rr=1:rtotalsteps
           kz=(zz-1)*2*3.14/zsteps;    %z�������
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