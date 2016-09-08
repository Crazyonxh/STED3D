
figure(1);plot(NA,contco1,'b',NA,pulco1,'r');xlabel ('NA','fontsize',20);ylabel ('\alpha','fontsize',20);set(gca,'FontSize',20);
aa=1.844*NA+0.4449;bb=1.566*NA+0.378;
hold on;plot(NA,aa,'b',NA,bb,'r');
figure(2);plot(NA,contco2,'b',NA,pulco2,'r');xlabel ('NA','fontsize',20);ylabel ('\beta','fontsize',20);set(gca,'FontSize',20);
figure(3);plot(NA,contsat,'b',NA,pulsat,'r');xlabel ('NA','fontsize',20);ylabel ('\gamma','fontsize',20);set(gca,'FontSize',20);
a=contsat.*contco2;b=pulsat.*pulco2;
aa=0.1932*NA+0.1289;bb=0.2398*NA+0.1674;
figure(4);plot(NA,a,'b',NA,b,'r');xlabel ('NA','fontsize',20);ylabel ('\xi','fontsize',20);set(gca,'FontSize',20);
hold on;plot(NA,aa,'b',NA,bb,'r')































% clear
% close all
% NA=1.0;
% %折射率
% n=1.5;
% f=1;
% %探测区间的范围，单位为波长
% r0=0.3;
% z0=1;
% %探测区间的分辨率，单位为步/波长
% rsteps=600;
% zsteps=30;
% %%%%激光参数%%%%%%%
% 
% %excitation和sted的波长，单位为纳米
% lambda1=635;
% lambda2=760;
% %激发和退激发的光强|E|^2
% Ie0=1;
% Id0=60;
% Is0=1;
% %y方向相对x方向的偏振幅度大小tan(beta)=ey/ex0,beta在0到90°之间，45°表示等幅，0度偏振仅沿x方向
% betae0=45;
% betad0=45;
% phip0=0;
% %y和x方向的偏振相位差，90为左旋，0为线偏振，-90右旋
% polarizatione=90; 
% polarizationd=90;
% 
% pole=polarizatione/180*3.14;
% pold=polarizationd/180*3.14;
% 
% phip=phip0/180*3.14;
% betae=betae0/180*3.14;
% betad=betad0/180*3.14;
% 
% Ee1=sqrt(Ie0)*sin(betae)/lambda1*3.14*f*1E6;
% Ee2=sqrt(Ie0)*cos(betae)/lambda1*3.14*f*1E6;
% 
% ae1=Ee1;
% ae2=Ee2*exp(1i*pole);
% 
% Ed1=sqrt(Id0)*sin(betad)/lambda2*3.14*f*1E6;
% Ed2=sqrt(Id0)*cos(betad)/lambda2*3.14*f*1E6;
% 
% ad1=Ed1;
% ad2=Ed2*exp(1i*pold);
% 
% Es1=sqrt(Is0)*sin(betad)/lambda2*3.14*f*1E6;
% Es2=sqrt(Is0)*cos(betad)/lambda2*3.14*f*1E6;
% 
% as1=Es1;
% as2=Es2*exp(1i*pold);
% %ad2=0;
% %%%%%%输出参数%%%%%%%%
% %xz观察平面旋转角
% phip0=0;
% zp0=0;
% Sexcitation=1;
% Sdepletion=1;
% 
% Sdrawexcitationimage=1;
% Sdrawdepletionimage=1;
% Ssaturation=1;
% 
% Smeasure=0;
% 
% Srandommask=0;
% 
% 
% %转角换成弧度单位phi=phi0/180*3.14;
% alpha=asin(NA/n);             
% %计算需要计算的矩形区域大小
%     %沿着光轴方向
% zmaxstep=floor(z0*zsteps*n);      %z方向的最大步数
% ztotalsteps=zmaxstep+2; %循环从格子zmaxstep-2做到zminstep+2以防止溢出，总步数为ztotalsteps
% %垂直于光轴方向
% rmaxstep=floor(r0*rsteps*n);
% rtotalsteps=rmaxstep+2;
% rlabel1=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda1;   
% rlabel2=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda2;   
% 
% rr=1:rtotalsteps;
% kr=(rr-1)*2*3.14/rsteps;
% s=sin(alpha)^2;
% 
% a01=betainc(s,1,0.75)*beta(1,0.75)+betainc(s,1,1.25)*beta(1,1.25);
% a02=-0.25*(betainc(s,2,0.75)*beta(2,0.75)+betainc(s,2,1.25)*beta(1,2.25));
% a1=betainc(s,2,0.75)*beta(2,0.75)/2;
% a2=(betainc(s,2,0.75)*beta(2,0.75)-betainc(s,2,1.25)*beta(2,1.25))/8;
% b1=(betainc(s,1.5,0.75)*beta(1.5,0.75)+betainc(s,1.5,1.25)*beta(1.5,1.25))/2;
% b2=(betainc(s,1.5,0.75)*beta(1.5,0.75)-betainc(s,1.5,1.25)*beta(1.5,1.25))/2;
% b41=betainc(s,1.5,0.75)*beta(1.5,0.75);
% b42=-betainc(s,1.5,1.25)*beta(1.5,1.25)/4;
% b5=betainc(s,1.5,1.25)*beta(1.5,1.25)/8;
% 
% kr1=kr/n/2/3.14*lambda1;   
% 
% 
% 
% 
% 
% a=3.14.*n.*(sqrt(-4*(a01*a02+a1^2))./a01);
% b=b1^2/(-4)/(a01*a02+a1^2).*(lambda1/lambda2)^2;
% 
% 
% aa=3.14.*n.*(sqrt(-2*(a01*a02+a1^2)/log(2))./a01)
% bb=b1^2/(-2)/(a01*a02+a1^2).*(lambda1/lambda2)^2.*log(2)
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % Edfieldnew=Eefield;
% % weight=Eefield;
% % det=Eefield;
% %     residue=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
% %     for xx=1:2*ztotalsteps-1
% %         for yy=1:2*rtotalsteps-1
% %             xcor=ztotalsteps+(xx-ztotalsteps)*lambda1/lambda2;
% %             ycor=rtotalsteps+(yy-rtotalsteps)*lambda1/lambda2;
% %             Edfieldnew(xx,yy)=Eefield(round(xcor),round(ycor));
% %             weight(xx,yy)=0.5+abs(yy-rtotalsteps);
% %         end;
% %     end; 
% %  
% %     ksteps=100;interval=10;
% %     etanew=zeros(2*ztotalsteps-1,2*rtotalsteps-1,ksteps);
% %     etanew2=zeros(2*ztotalsteps-1,2*rtotalsteps-1,ksteps);
% %     flu=zeros(2*ztotalsteps-1,2*rtotalsteps-1,ksteps);
% %     flu2=zeros(2*ztotalsteps-1,2*rtotalsteps-1,ksteps);
% %     resflu=zeros(2*ztotalsteps-1,2*rtotalsteps-1,ksteps);
% %     resflu2=zeros(2*ztotalsteps-1,2*rtotalsteps-1,ksteps);
% %     
% % %   for k=1:2*rtotalsteps-1
% % %      det(:,k)=sum(Eefield.^2.*weight,2);       
% % %  end;  
% %  det=Eefield.^2;
% %  exweighted=Eefield.^2.*weight.*det;
% %  flu0=sum(sum(exweighted));
% %  for k=1:ksteps;
% %     etanew(:,:,k)=1./(1+(k-1)/interval*(Edfieldnew/Edfieldnew(ztotalsteps,rtotalsteps)).^2);
% %     etanew2(:,:,k)=exp(-log(2)*(k-1)/interval*(Edfieldnew/Edfieldnew(ztotalsteps,rtotalsteps)).^2);
% %     flu(:,:,k)=etanew(:,:,k).*Eefield.^2;
% %     flu2(:,:,k)=etanew2(:,:,k).*Eefield.^2;
% %     resflu(:,:,k)=flu(:,:,k).*weight.*det;
% %     resflu2(:,:,k)=flu2(:,:,k).*weight.*det;
% %     r1(k)=sum(sum(resflu(:,:,k)))/flu0;
% %     r2(k)=sum(sum(resflu2(:,:,k)))/flu0;
% %  end;  
% % 
% % close all
% % figure(1)
% % imagesc(Eefield.^2)
% % figure(2)
% % imagesc(Edfieldnew.^2)
% % figure(3)
% %  imagesc(etanew(:,:,2))
% %  figure(4)
% % imagesc(flu(:,:,2))
% %  figure(5)
% % imagesc(resflu(:,:,2))
% % %  figure(6)
% % % imagesc(flu(:,:,1).*weight./(Eefield.^2))
% % %  figure(7)
% % %  plot(r1);
% %   figure(8)
% % plot((0:ksteps-1)/interval,r1)
% % xlabel ('I/I_s','fontsize',20)
% % ylabel ('P_{det}/P_{0det}','fontsize',20)
% % set(gca,'FontSize',20);
% % % hold on;plot(sum(flu(:,:,20).*weight./(Eefield.^2)));
% % % hold on;plot(sum(flu(:,:,30).*weight./(Eefield.^2)));
% % % hold on;plot(sum(flu(:,:,40).*weight./(Eefield.^2)));
% % % hold on;plot(sum(flu(:,:,50).*weight./(Eefield.^2)));
% % figure(9)
% % plot((0:ksteps-1)/interval,1./r1)
% % xlabel ('I/I_s','fontsize',20)
% % ylabel ('P_{0det}/P_{det}','fontsize',20)
% % set(gca,'FontSize',20);
% % k=1:ksteps;
% % s=1./r1;
% % zlabel1=(-ztotalsteps+1:ztotalsteps-1)/zsteps/n*lambda1;
% % figure(10)
% % plot(zlabel1,sum(flu(:,:,1).*weight(:,:).*det,2))
% % hold on;plot(zlabel1,sum(flu(:,:,21).*weight(:,:).*det,2))
% % xlabel ('z/nm','fontsize',20)
% % ylabel ('P_{0det}/P_{det}','fontsize',20)
% % set(gca,'FontSize',20);
% % figure(8)
% % hold on
% % plot((0:ksteps-1)/interval,r2,'r')
% % xlabel ('I/I_s','fontsize',20)
% % ylabel ('P_{det}/P_{0det}','fontsize',20)
% % set(gca,'FontSize',20);