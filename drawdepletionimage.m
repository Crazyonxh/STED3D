function [Edfield,Edfield2] = drawdepletionimage(IId1,IId2,IId3,IId4,IId5,lambda2,Id0,betad0,polarizationd,ztotalsteps,zsteps,rtotalsteps,rsteps,phip0,zp0,n,f)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
        pold=polarizationd/180*3.14;
        phip=phip0/180*3.14;
        betad=betad0/180*3.14;
        Ed1=sqrt(Id0)*sin(betad)/lambda2*3.14*f*1E6;
        Ed2=sqrt(Id0)*cos(betad)/lambda2*3.14*f*1E6;
        ad1=Ed1;
        ad2=Ed2*exp(1i*pold);
        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%depletion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%xz plane%%%%%%%%%%%%%%%%%%%%%%%

    %e0=ex
    exdx=ad1*[-fliplr(IId1)*exp(1i*phip)+0.5*fliplr(IId2)*exp(-1i*phip)-0.5*fliplr(IId3)*exp(3i*phip) IId1(:,2:rtotalsteps)*exp(1i*phip)-0.5*IId2(:,2:rtotalsteps)*exp(-1i*phip)+0.5*IId3(:,2:rtotalsteps)*exp(3i*phip)];
    eydx=-0.5*ad1*1i*[-fliplr(IId2)*exp(-1i*phip)-fliplr(IId3)*exp(3i*phip) IId2(:,2:rtotalsteps)*exp(-1i*phip)+IId3(:,2:rtotalsteps)*exp(3i*phip)];
    ezdx=ad1*1i*[fliplr(IId4)-fliplr(IId5)*exp(2i*phip) IId4(:,2:rtotalsteps)-IId5(:,2:rtotalsteps)*exp(2i*phip)];
    %e0=ey
    exdy=-0.5*ad2*1i*[-fliplr(IId2)*exp(-1i*phip)-fliplr(IId3)*exp(3i*phip) IId2(:,2:rtotalsteps)*exp(-1i*phip)+IId3(:,2:rtotalsteps)*exp(3i*phip)];
    eydy=ad2*[-fliplr(IId1)*exp(1i*phip)-0.5*fliplr(IId2)*exp(-1i*phip)+0.5*fliplr(IId3)*exp(3i*phip) IId1(:,2:rtotalsteps)*exp(1i*phip)+0.5*IId2(:,2:rtotalsteps)*exp(-1i*phip)-0.5*IId3(:,2:rtotalsteps)*exp(3i*phip)];
    ezdy=-ad2*[fliplr(IId4)+fliplr(IId5)*exp(2i*phip) IId4(:,2:rtotalsteps)+IId5(:,2:rtotalsteps)*exp(2i*phip)];

    edx=exdx+exdy;
    edy=eydx+eydy;
    edz=ezdx+ezdy;

    Edfield=sqrt(edx.*conj(edx)+edy.*conj(edy)+edz.*conj(edz));
    %%%%%%%%%%%%%%%%%%%%%%xy plane%%%%%%%%%%%%%%%%%%%%%%%
    exdx2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
    eydx2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
    ezdx2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
    exdy2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
    eydy2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
    ezdy2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
    for xx=1:2*floor(rtotalsteps/1.5)+1
        for yy=1:2*floor(rtotalsteps/1.5)+1
        xcord=xx-floor(rtotalsteps/1.5)-1;
        ycord=yy-floor(rtotalsteps/1.5)-1;
        [phip rp]=cart2pol(xcord,ycord);
        rp=floor(rp)+1;
        zz=ztotalsteps+floor(zp0*zsteps*n);
        exdx2(xx,yy)=ad1*(IId1(zz,rp)*exp(1i*phip)-0.5*IId2(zz,rp)*exp(-1i*phip)+0.5*IId3(zz,rp)*exp(3i*phip));
        eydx2(xx,yy)=-0.5*ad1*1i*(IId2(zz,rp)*exp(-1i*phip)+IId3(zz,rp)*exp(3i*phip));
        ezdx2(xx,yy)=ad1*1i*(IId4(zz,rp)-IId5(zz,rp)*exp(2i*phip));
        %e0=ey
        exdy2(xx,yy)=-0.5*ad2*1i*(IId2(zz,rp)*exp(-1i*phip)+IId3(zz,rp)*exp(3i*phip));
        eydy2(xx,yy)=ad2*(IId1(zz,rp)*exp(1i*phip)+0.5*IId2(zz,rp)*exp(-1i*phip)-0.5*IId3(zz,rp)*exp(3i*phip));
        ezdy2(xx,yy)=-ad2*(IId4(zz,rp)+IId5(zz,rp)*exp(2i*phip));
        end;
    end;
    edx2=exdx2+exdy2;
    edy2=eydx2+eydy2;
    edz2=ezdx2+ezdy2;

    Edfield2=sqrt(edx2.*conj(edx2)+edy2.*conj(edy2)+edz2.*conj(edz2));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%drawing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zlabel2=(-ztotalsteps+1:ztotalsteps-1)/zsteps/n*lambda2;
rlabel2=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda2;   


h=figure(3);
set(h,'position',[430 400 400 300]);

imagesc(rlabel2,zlabel2,Edfield.^2);
t41=['Depletion electic field |E|^2 on xz'];
title(t41,'fontsize',20);
xlabel ('r/nm','fontsize',20)
ylabel ('z/nm','fontsize',20)
colormap hot
colorbar
axis image
 set(gca,'FontSize',20);
 %n41=['C:\Users\pku\Desktop\images\' t41];
% saveas(h,n41);


h=figure(4);
set(h,'position',[430 0 400 300]);

imagesc(rlabel2,rlabel2,Edfield2.^2);
t41=['Depletion electic field |E|^2 on xy'];
title(t41,'fontsize',20);
xlabel ('x/nm','fontsize',20)
ylabel ('y/nm','fontsize',20)
colormap hot
colorbar
axis image
 set(gca,'FontSize',20);
 %n41=['C:\Users\pku\Desktop\images\' t41];
% saveas(h,n41);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

