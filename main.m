clear
close all
%%%%%%%%%%%%variable inputs%%%%%%%%%%%
%%%%system parameters%%%
%numerical aperture
NA=1.4;
%refrax index and focal length
n=1.5;
f=1;
%scale of detection in unit of wavelengths
r0=1;
z0=1;
%resolution of detection area in unit of steps/wavelength
rsteps=30;
zsteps=30;
%%%%laser parameters%%%%%%%

%wavelegnth of excitation and depletion beam in unit of nm
lambda1=635;
lambda2=760;
%intensity |E|^2 of excitation and depletion beam
Ie0=1;
Id0=60;
%ratio of laser amplitude between x and y: tan(beta)=ey/ex0, beta is between 0 to 90¡ã.45¡ãrepresents
%ex=ey£¬0 represents electric field is along x
betae0=45;
betad0=45;
%phase difference between y and x oscillation£¬90 is left-circular £¬0 is linear£¬-90 is right-circular
polarizatione=90; 
polarizationd=90;

%saturation intensity
Ids=1;
%saturation modes£¬1 for continuous£¬2 for pulsed£¬3 for user-defined
saturationformula=1;


%%%%%%oupput parameters%%%%%%%%
%observed rotation angle of xz
phip0=0;
zp0=0;
Sexcitation=1;
Sdepletion=1;

Sdrawexcitationimage=1;
Sdrawdepletionimage=1;
Ssaturation=1;

Smeasure=1;

Srandommask=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%initiation of parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%change from degree to arc;
alpha=asin(NA/n);             
%scale to be calculated
    %along optics axis
zmaxstep=floor(z0*zsteps*n);      %maximun steps along z
ztotalsteps=zmaxstep+2; %loop from zmaxstep-2 to zminstep+2 to prevent violation of index£¬ztotalsteps is total steps of the loop
%perpendicular to optical axis
rmaxstep=floor(r0*rsteps*n);
rtotalsteps=rmaxstep+2;
rlabel1=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda1;   
rlabel2=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda2;   


Sexcitationintegrationcalculated=0;
Sdepletionintegrationcalculated=0;
Sexcitationfieldcalculated=0;
Sdepletionfieldcalculated=0;
Sresiduefieldcalculated=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%calculate excitation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Sexcitation==1
    [IIe1,IIe2,IIe3]=calculateexcitationintegration(alpha,ztotalsteps,rtotalsteps,zsteps,rsteps);
    Sexcitationintegrationcalculated=1;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%calculate depletion beam%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Sdepletion==1
    [IId1,IId2,IId3,IId4,IId5]=calculatedepletionintegration(alpha,ztotalsteps,rtotalsteps,zsteps,rsteps); 
    Sdepletionintegrationcalculated=1;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%plot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%draw excitation beam
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


%draw depletion beam
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


%show residue beam
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%measurements%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






if Srandommask==1
    [Edfield3d,Edfield3d2]=calculaterandommaskintegration(NA,lambda2,r0,z0,n,f,rsteps,zsteps,Id0,betad0,polarizationd);
end;









