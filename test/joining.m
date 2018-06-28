if exist('a1','var') == 0
    siz=length(outp)-100;
    
    %load('t3_4contcts.mat','inp','outp','posp')
    %outp=outp-outp(1,:);
   % outp=normalize(outp,2);
    
    outp=outp-mean(outp(10:100,:));
    outp=outp./range(outp(10:100,:));
%     
    inp=inp(1:siz,1);
    outp=outp(1:siz,:);
    posp=posp(:,1:siz,:);
    
    a1=[inp];
    b1=[outp];
    c1=posp;
else
    
    siz=length(outp)-100;
    
    %load('t3_4contcts.mat','inp','outp','posp')
    %outp=outp-outp(1,:);
  %  outp=normalize(outp,2);
%     
    outp=outp-mean(outp(10:100,:));
    outp=outp./range(outp(10:100,:));
    
    inp=inp(1:siz,1);
    outp=outp(1:siz,:);
    posp=posp(:,1:siz,:);
    
    a1=[a1; inp];
    b1=[b1; outp];
    c1=cat(2,c1, posp);
end

%%

%%
if 0
inp=a1;
outp=b1;
posp=c1;
end