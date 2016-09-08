function [ residue,residue2 ] = calculateresidue( Ids,saturationformula,n,f,lambda1,lambda2,betad0,Eefield,Eefield2,Edfield,Edfield2,IIe1,ztotalsteps,zsteps,rtotalsteps,rsteps)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Ssaturation    
    
    betad=betad0/180*3.14;
    ads1=sqrt(Ids)*sin(betad)/lambda2*3.14*f*1E6;
    ads2=sqrt(Ids)*cos(betad)/lambda2*3.14*f*1E6;
    Ispeak=(ads1^2+ads2^2)*IIe1(ztotalsteps,1)^2;

    %连续波，分数抑制关系1/(1+I/Is)
    if saturationformula==1
        eta=1./(1+Edfield.^2/Ispeak);
        eta2=1./(1+Edfield2.^2/Ispeak);

    end;

    %先激发后接收
    if saturationformula==2
        eta=exp(-Edfield.^2/Ispeak*log(2));
        eta2=exp(-Edfield2.^2/Ispeak*log(2));

    end;


    %先激发后接收
    if saturationformula==3
        eta=saturationfunction(Edfield,Ispeak);
        eta2=saturationfunction(Edfield2,Ispeak);
    end;


    residue=zeros(2*ztotalsteps-1,2*rtotalsteps-1);
    for xx=1:2*ztotalsteps-1
        for yy=1:2*rtotalsteps-1
            xcor=ztotalsteps+(xx-ztotalsteps)*lambda1/lambda2;
            xlower=floor(xcor);
            xupper=xlower+1;
            ycor=rtotalsteps+(yy-rtotalsteps)*lambda1/lambda2;
            ylower=floor(ycor);
            yupper=ylower+1;
            kx=eta(xupper,ylower)-eta(xlower,ylower);
            ky=eta(xlower,yupper)-eta(xlower,ylower);
            residue(xx,yy)=Eefield(xx,yy)^2*(eta(xlower,ylower)+(xcor-xlower)*kx+(ycor-ylower)*ky);  %双线性插值
        end;
    end;


    residue2=zeros(2*floor(rtotalsteps/1.5)+1,2*floor(rtotalsteps/1.5)+1);
    for xx=1:2*floor(rtotalsteps/1.5)+1
        for yy=1:2*floor(rtotalsteps/1.5)+1
            xcor=floor(rtotalsteps/1.5)+1+(xx-floor(rtotalsteps/1.5)-1)*lambda1/lambda2;
            xlower=floor(xcor);
            xupper=xlower+1;
            ycor=floor(rtotalsteps/1.5)+1+(yy-floor(rtotalsteps/1.5)-1)*lambda1/lambda2;
            ylower=floor(ycor);
            yupper=ylower+1;
            kx=eta2(xupper,ylower)-eta2(xlower,ylower);
            ky=eta2(xlower,yupper)-eta2(xlower,ylower);
            residue2(xx,yy)=Eefield2(xx,yy)^2*(eta2(xlower,ylower)+(xcor-xlower)*kx+(ycor-ylower)*ky);  %双线性插值
        end;
    end;




zlabel1=(-ztotalsteps+1:ztotalsteps-1)/zsteps/n*lambda1;
rlabel1=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda1;   
rlabelxy1=(-floor(rtotalsteps/1.5):floor(rtotalsteps/1.5))/rsteps/n*lambda1; 

if Ssaturation==1
    h=figure(7);
    set(h,'position',[860 400 400 300]);
    imagesc(rlabel1,zlabel1,residue);
    t41=['residue electic field |E|^2 on xz'];
    title(t41,'fontsize',20);
    xlabel ('r/\mu m','fontsize',20)
    ylabel ('z/\mu m','fontsize',20)
    colormap hot
    colorbar
    axis image
     set(gca,'FontSize',20);


    h=figure(8);
    set(h,'position',[860 0 400 300]);
    imagesc(rlabelxy1,rlabelxy1,residue2);
    t41=['residue electic field |E|^2 on xy'];
    title(t41,'fontsize',20);
    xlabel ('x/nm','fontsize',20)
    ylabel ('y/nm','fontsize',20)
    colormap hot
    colorbar
    axis image
     set(gca,'FontSize',20);
end;

end

