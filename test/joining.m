% This file is used manually (copy&paste the sections) to merge two sets of
% vectors (inp, outp, posp) between two workspaces (.mat files) for testing
% different combinations of data for training.

%% Account for the total size of the new vector and merge the two sets of vectors.
siz=18000;

%load('t3_4contcts.mat','inp','outp','posp')
%outp=outp-outp(1,:);

inp=inp(1:siz,1);
outp=outp(1:siz,:);
posp=posp(:,1:siz,:);


a1=[a1; inp];
b1=[b1; outp];
c1=cat(2,c1, posp);
%% Temp vars for curr vectors.
a1=[inp];
b1=[outp];
c1=posp;
%% Restore to original file name.
 
inp=a1;
outp=b1;
posp=c1;