function [ IId1,IId2,IId3,IId4,IId5 ] = calculatedepletionintegration( alpha,ztotalsteps,rtotalsteps,zsteps,rsteps )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%入射depletion光%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Id1=zeros(ztotalsteps,rtotalsteps);
    Id2=zeros(ztotalsteps,rtotalsteps);
    Id3=zeros(ztotalsteps,rtotalsteps);
    Id4=zeros(ztotalsteps,rtotalsteps);
    Id5=zeros(ztotalsteps,rtotalsteps);

    h = waitbar(0,'Incident depletion beam calculation.');
    for zz=1:ztotalsteps                   %坐标为（r,z）的点在数组中的位置为(zz,j)
        for rr=1:rtotalsteps
            kz=(zz-1)*2*3.14/zsteps;    %z坐标
            kr=(rr-1)*2*3.14/rsteps;
            fun4=@(theta)(cos(theta).^(1/2).*sin(theta).*(1+cos(theta)).*besselj(1,kr.*sin(theta))).*exp(1i*kz*cos(theta));
            fun5=@(theta)(cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*besselj(1,kr.*sin(theta))).*exp(1i*kz*cos(theta));
            fun6=@(theta)(cos(theta).^(1/2).*sin(theta).*(1-cos(theta)).*besselj(3,kr.*sin(theta))).*exp(1i*kz*cos(theta));
            fun7=@(theta)(cos(theta).^(1/2).*sin(theta).^2.*besselj(0,kr.*sin(theta))).*exp(1i*kz*cos(theta));
            fun8=@(theta)(cos(theta).^(1/2).*sin(theta).^2.*besselj(2,kr.*sin(theta))).*exp(1i*kz*cos(theta));
            Id1(zz,rr)= quad(fun4,0,alpha);
            Id2(zz,rr)= quad(fun5,0,alpha);
            Id3(zz,rr)= quad(fun6,0,alpha);
            Id4(zz,rr)= quad(fun7,0,alpha);
            Id5(zz,rr)= quad(fun8,0,alpha);
        end;
        waitbar(zz/(ztotalsteps-1+eps),h,sprintf(['Step 2/2: depletion beam calculation completed ' num2str(zz/(ztotalsteps-1+eps),0.1)]));
    end;
    close(h) 

    IId1=[flipud(conj(Id1));Id1(2:ztotalsteps,:)];
    IId2=[flipud(conj(Id2));Id2(2:ztotalsteps,:)];
    IId3=[flipud(conj(Id3));Id3(2:ztotalsteps,:)];
    IId4=[flipud(conj(Id4));Id4(2:ztotalsteps,:)];
    IId5=[flipud(conj(Id5));Id5(2:ztotalsteps,:)];
end

