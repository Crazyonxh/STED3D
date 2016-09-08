clear
close all

%%%%%%%%%%%%��������%%%%%%%%%%%
%%%%ϵͳ����%%%
%��ֵ�׾�
NA=1.3;
%������
n=1.5;
f=1;
%̽������ķ�Χ����λΪ����
r0=5;
z0=5;
%̽������ķֱ��ʣ���λΪ��/����
rsteps=10;
zsteps=10;
%%%%�������%%%%%%%

%excitation��sted�Ĳ�������λΪ����
lambda1=635;
lambda2=760;
%�������˼����Ĺ�ǿ|E|^2
Ie0=1;
Id0=60;
%y�������x�����ƫ����ȴ�Сtan(beta)=ey/ex0,beta��0��90��֮�䣬45���ʾ�ȷ���0��ƫ�����x����
betae0=45;
betad0=45;
%y��x�����ƫ����λ�90Ϊ������0Ϊ��ƫ��-90����
polarizatione=90; 
polarizationd=90;

%���͹�ǿ
Ids=1;
%ѡ�񼤷���ʽ��1Ϊ������2 Ϊ���壬3Ϊ�Զ���
saturationformula=1;


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


Sexcitationintegrationcalculated=0;
Sdepletionintegrationcalculated=0;
Sexcitationfieldcalculated=0;
Sdepletionfieldcalculated=0;
Sresiduefieldcalculated=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���㼤����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [IIe1,IIe2,IIe3]=calculateexcitationintegration(alpha,ztotalsteps,rtotalsteps,zsteps,rsteps);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������
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