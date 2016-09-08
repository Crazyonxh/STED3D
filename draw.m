function [ output_args ] = draw()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clear
figure(1);
figure(2);
figure(3);
figure(4);
figure(5);
figure(8);
figure(7);
close figure 1
close figure 2
close figure 3
close figure 4
close figure 5
close figure 8
close figure 7
global NA n f r0 z0 rsteps zsteps lambda1 lambda2 Ie0 Id0 betae0 betad0 Ids saturationformula phip0 zp0 polarizatione polarizationd IIe1 IIe2 IIe3 IId1 IId2 IId3 IId4 IId5 Eefield Eefield2 Edfield Edfield2 residue
global Sexcitation Sdepletion Sdrawexcitationimage Sdrawdepletionimage Ssaturation Srandommask Smeasure Sexcitationintegrationcalculated Sdepletionintegrationcalculated Sresiduefieldcalculated Sexcitationfieldcalculated Sdepletionfieldcalculated Sresiduefieldcalculated

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���㼤����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if Srandommask==1
    [Edfield3d,Edfield3d2]=calculaterandommaskintegration(NA,lambda2,r0,z0,n,f,rsteps,zsteps,Id0,betad0,polarizationd);
else

if Sexcitation==1
    [IIe1,IIe2,IIe3]=calculateexcitationintegration(alpha,ztotalsteps,rtotalsteps,zsteps,rsteps);
    Sexcitationintegrationcalculated=1;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����depletion��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Sdepletion==1
    [IId1,IId2,IId3,IId4,IId5]=calculatedepletionintegration(alpha,ztotalsteps,rtotalsteps,zsteps,rsteps); 
    Sdepletionintegrationcalculated=1;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������
if Sdrawexcitationimage==1
    if Sexcitationintegrationcalculated==0
        msgbox('Please calculate excitation integration first!');
    else if Sdrawexcitationimage==1
             [Eefield,Eefield2]=drawexcitationimage(IIe1,IIe2,IIe3,lambda1,Ie0,betae0,polarizatione,ztotalsteps,zsteps,rtotalsteps,rsteps,phip0,zp0,n,f);
             Sexcitationfieldcalculated=1;
             if Smeasure==1
                measureFWHMexcitation(rlabel1,ztotalsteps,Eefield);
            end;
        end;
    end;
end;


%����depletion��
if Sdrawdepletionimage==1
    if Sdepletionintegrationcalculated==0
        msgbox('Please calculate depletion integration first!');
    else if Sdrawdepletionimage==1
             [Edfield,Edfield2]=drawdepletionimage(IId1,IId2,IId3,IId4,IId5,lambda2,Id0,betad0,polarizationd,ztotalsteps,zsteps,rtotalsteps,rsteps,phip0,zp0,n,f);
             Sdepletionfieldcalculated=1;
             if Smeasure==1
                measureFWHMdepletion(rlabel2,ztotalsteps,Edfield);
            end;
        end;
    end;
end;


%����sted���
if Ssaturation==1
    if Sexcitationfieldcalculated&&Sdepletionfieldcalculated==1
        [residue,residue2]=calculateresidue(Ids,saturationformula,n,f,lambda1,lambda2,betad0,Eefield,Eefield2,Edfield,Edfield2,IIe1,ztotalsteps,zsteps,rtotalsteps,rsteps);
        Sresiduefieldcalculated=1;
         if Smeasure==1
                measureFWHMresidue(rlabel1,ztotalsteps,residue);
         end;
    else msgbox('Please calculate excitation and depletion field first!');
    end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





end;

end

