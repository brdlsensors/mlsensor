
siz=50000;

%load('t3_4contcts.mat','inp','outp','posp')
%outp=outp-outp(1,:);

inp=inp(1:siz,1);
outp=outp(1:siz,:);
posp=posp(:,1:siz,:);


a1=[a1; inp];
b1=[b1; outp];
c1=cat(2,c1, posp);
%%
a1=[ inp];
b1=[ outp];
c1=posp;
%%
 
inp=a1;
outp=b1;
posp=c1;