siz=9000;
% sfreq=4;
lag=10;
%
% rx=1:2;


%inp(4+lag:siz+3,1),
%x=[inp(3+lag:siz+2,1),outp(1+lag:siz,2),outp(2+lag:siz+1,2)]';%,outp(lag:siz-1,1)
%outp=outp-outp(1,:);

inpf=inp(1:sfreq:end);
outpf=outp(1:sfreq:end,:);
pospf=posp(:,1:sfreq:end,:);
%siz=siz/sfreq;




%x=[inpf(3+lag:siz+2,1),outpf(3+lag:siz+2,rx),outpf(2+lag:siz+1,rx)]';

%x=[inpf(3+lag:siz+2,1)]';
x=[inpf(3+lag:siz+2,1),outpf(3+lag:siz+2,rx)]';


%t=squeeze(pospf(1,3+lag:siz+2,2));
%t=rssq(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1)));
t=(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1)));


inputSize = size(x,1);
numResponses =size(t,1);

%t=t+60*randn(1,length(t));
divi=floor(0.8*length(x));
numTimeStepsTrain=divi;

%numTimeStepsTrain = floor(0.9*numel(data));
% x=normalize(x,2);
% t=normalize(t,2);


for z=1:inputSize
    x(z,:)= x(z,:)-xm(z);
    x(z,:)= x(z,:)/xs(z);
end
for z=1:numResponses
    t(z,:)= t(z,:)-tm(z);
    t(z,:)= t(z,:)/ts(z);
end

x=normalize(x,2);
t=normalize(t,2);
tic
[net,YPred_o ]= predictAndUpdateState(net,x);
toc
%[net,YPred] = predictAndUpdateState(net,XTrain(:,end));
for z=1:numResponses
    
    t(z,:)= t(z,:)*ts(z);
    YPred_o(z,:)=YPred_o(z,:)*ts(z);
end
plot(YPred_o(1,:))
hold on
plot(t(1,:))


err=rssq(YPred_o-t);
%err(err>50)=0;
mean(err)
M = movmean(err,100);
diffx=diff(t(1,:));
for i=1:length(err)-1
    if diffx(i)>0
        errd(i)=err(i);
    else
        errd(i)=-err(i);
    end
end
figure;
histogram(errd)

figure;
scatter3(t(1,:),t(2,:),t(3,:))
hold on
scatter3(YPred_o(1,:),YPred_o(2,:),YPred_o(3,:))