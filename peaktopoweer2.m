
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
 
    ksteps=60;interval=10;
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
plot((0:ksteps-1)/interval,1./r1);
hold on
xx=(0:ksteps-1)/interval;
y=log(1+xx+0.0001)./(xx+0.0001);
plot(xx,1./y,'g')
xlabel ('I/I_s','fontsize',20)
ylabel ('P_{0det}/P_{det}','fontsize',20)
set(gca,'FontSize',20);
k=1:ksteps;
s=1./r1;
zlabel1=(-ztotalsteps+1:ztotalsteps-1)/zsteps/n*lambda1;
figure(10)
plot(zlabel1,sum(exweighted,2))
hold on;plot(zlabel1,sum(resflu,2))
xlabel ('z/nm','fontsize',20)
ylabel ('P_{0det}/P_{det}','fontsize',20)
set(gca,'FontSize',20);
figure(8)
hold on
plot((0:ksteps-1)/interval,r2,'r')
hold on
plot(xx,y,'g')
xlabel ('I/I_s','fontsize',20)
ylabel ('P_{det}/P_{0det}','fontsize',20)
set(gca,'FontSize',20);