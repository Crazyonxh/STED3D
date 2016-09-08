function [ output_args ] = updateimage( input_args )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global NA n f r0 z0 rsteps zsteps lambda1 lambda2 Ie0 Id0 betae0 betad0 Ids saturationformula phip0 zp0 polarizatione polarizationd IIe1 IIe2 IIe3 IId1 IId2 IId3 IId4 IId5 Eefield Eefield2 Edfield Edfield2
global Sexcitation Sdepletion Sdrawexcitationimage Sdrawdepletionimage Ssaturation Srandommask Smeasure Sexcitationintegrationcalculated Sdepletionintegrationcalculated Sresiduefieldcalculated Sexcitationfieldcalculated Sdepletionfieldcalculated Sresiduefieldcalculated

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


if Sdrawexcitationimage==1
     [Eefield,Eefield2]=drawexcitationimage(IIe1,IIe2,IIe3,lambda1,Ie0,betae0,polarizatione,ztotalsteps,zsteps,rtotalsteps,rsteps,phip0,zp0,n,f);
     Sexcitationfieldcalculated=1;
     if Smeasure==1
        measureFWHMexcitation(rlabel1,ztotalsteps,Eefield);
    end;
end;


if Sdrawdepletionimage==1
     [Edfield,Edfield2]=drawdepletionimage(IId1,IId2,IId3,IId4,IId5,lambda2,Id0,betad0,polarizationd,ztotalsteps,zsteps,rtotalsteps,rsteps,phip0,zp0,n,f);
     Sdepletionfieldcalculated=1;
     if Smeasure==1
        measureFWHMdepletion(rlabel2,ztotalsteps,Edfield);
    end;
end;

if Sexcitationfieldcalculated&&Sdepletionfieldcalculated==1
        [residue,residue2]=calculateresidue(Ids,saturationformula,n,f,lambda1,lambda2,betad0,Eefield,Eefield2,Edfield,Edfield2,IIe1,ztotalsteps,zsteps,rtotalsteps,rsteps);
        Sresiduefieldcalculated=1;
         if Smeasure==1
                measureFWHMresidue(rlabel1,ztotalsteps,residue);
         end;
 end;

 
 
end

