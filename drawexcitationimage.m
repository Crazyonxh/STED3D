function [ Eefield,Eefield2 ] = drawexcitationimage(IIe1,IIe2,IIe3,lambda1,Ie0,betae0,polarizatione,ztotalsteps,zsteps,rtotalsteps,rsteps,phip0,zp0,n,f )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

        pole=polarizatione/180*3.14;

        phip=phip0/180*3.14;
        betae=betae0/180*3.14;

        Ee1=sqrt(Ie0)*sin(betae)/lambda1*3.14*f*1E6;
        Ee2=sqrt(Ie0)*cos(betae)/lambda1*3.14*f*1E6;

        ae1=Ee1;
        ae2=Ee2*exp(1i*pole);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%exictation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%xz plane%%%%%%%%%%%%%%%%%%%%%%%

        %e0=ex
        exex=-ae1*1i*[fliplr(IIe1)+cos(2*phip)*fliplr(IIe3) IIe1(:,2:rtotalsteps)+cos(2*phip)*IIe3(:,2:rtotalsteps)];
        eyex=-ae1*1i*[fliplr(IIe3)*sin(2*phip) sin(2*phip)*IIe3(:,2:rtotalsteps)];
        ezex=-ae1*2*[-fliplr(IIe2)*cos(phip) cos(phip)*IIe2(:,2:rtotalsteps)];
        %e0=ey
        exey=-ae2*1i*[fliplr(IIe3)*sin(2*phip) sin(2*phip)*IIe3(:,2:rtotalsteps)];
        eyey=-ae2*1i*[fliplr(IIe1)-cos(2*phip)*fliplr(IIe3) IIe1(:,2:rtotalsteps)-cos(2*phip)*IIe3(:,2:rtotalsteps)];
        ezey=-ae2*2*[-fliplr(IIe2)*sin(phip) sin(phip)*IIe2(:,2:rtotalsteps)];

        eex=exex+exey;
        eey=eyex+eyey;
        eez=ezex+ezey;

        Eefield=sqrt(eex.*conj(eex)+eey.*conj(eey)+eez.*conj(eez));

        %%%%%%%%%%%%xy%plane%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        exex2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
        eyex2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
        ezex2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
        exey2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
        eyey2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
        ezey2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
        for xx=1:2*floor(rtotalsteps/1.5)+1
            for yy=1:2*floor(rtotalsteps/1.5)+1
            xcord=xx-floor(rtotalsteps/1.5)-1;
            ycord=yy-floor(rtotalsteps/1.5)-1;
            [phip rp]=cart2pol(xcord,ycord);
            rp=floor(rp)+1;
            zz=ztotalsteps+floor(zp0*zsteps*n);
            exex2(xx,yy)=-ae1*1i*(IIe1(zz,rp)+cos(2*phip)*IIe3(zz,rp));
            eyex2(xx,yy)=-ae1*1i*(sin(2*phip)*IIe3(zz,rp));
            ezex2(xx,yy)=-ae1*2*(cos(phip)*IIe2(zz,rp));
            %e0=ey
            exey2(xx,yy)=-ae2*1i*(sin(2*phip)*IIe3(zz,rp));
            eyey2(xx,yy)=-ae2*1i*(IIe1(zz,rp)-cos(2*phip)*IIe3(zz,rp));
            ezey2(xx,yy)=-ae2*2*(sin(phip)*IIe2(zz,rp));
            end;
        end;
        eex2=exex2+exey2;
        eey2=eyex2+eyey2;
        eez2=ezex2+ezey2;

        Eefield2=sqrt(eex2.*conj(eex2)+eey2.*conj(eey2)+eez2.*conj(eez2));
        
        
        
    zlabel1=(-ztotalsteps+1:ztotalsteps-1)/zsteps/n*lambda1;
    rlabel1=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda1;   
    rlabelxy1=(-floor(rtotalsteps/1.5):floor(rtotalsteps/1.5))/rsteps/n*lambda1; 
    h=figure(1);
     set(h,'position',[0 400 400 300]);
    imagesc(rlabel1,zlabel1,Eefield.^2);
    t41=['Excitation electic field |E|^2 on xz'];
    title(t41,'fontsize',20);
    xlabel ('r/\mu m','fontsize',20)
    ylabel ('z/\mu m','fontsize',20)
    colormap hot
    colorbar
    axis image
     set(gca,'FontSize',20);
     %n41=['C:\Users\pku\Desktop\images\' t41];
    % saveas(h,n41);

    h=figure(2);
    set(h,'position',[0 0 400 300]);
    imagesc(rlabelxy1,rlabelxy1,Eefield2.^2);
    t41=['Excitation electic field |E|^2 on xy'];
    title(t41,'fontsize',20);
    xlabel ('x/nm','fontsize',20)
    ylabel ('y/nm','fontsize',20)
    colormap hot
    colorbar
    axis image
     set(gca,'FontSize',20);
end

