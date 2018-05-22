siz=230000;
sfreq=5;
lag=10;
rx=1:3;

% Downsampling the actual frequency by sfreq.
inpf=inp(1:sfreq:end);
outpf=outp(1:sfreq:end,:);
pospf=posp(:,1:sfreq:end,:);
siz=siz/sfreq;

outpf(:,2:3)=rand(47200,2);

x=[inpf(3+lag:siz+2,1),outpf(3+lag:siz+2,rx),outpf(2+lag:siz+1,rx)]';

%x=[inpf(3+lag:siz+2,1)]';
%x=[outpf(3+lag:siz+2,rx)]';
%x=[outpf(3+lag:siz+2,rx),outpf(2+lag:siz+1,rx)]';
%t=squeeze(pospf(1,3+lag:siz+2,2));
%t=rssq(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1)));
t=(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1)));



inputSize = size(x,1);
numResponses =size(t,1);

%t=t+60*randn(1,length(t));
divi=floor(0.8*length(x));
numTimeStepsTrain=divi;

%numTimeStepsTrain = floor(0.9*numel(data));
%x=normalize(x,2);
%t=normalize(t,2);
xm=mean(x');
xs=std(x');
tm=mean(t');
ts=std(t');
for z=1:inputSize
    x(z,:)= x(z,:)-xm(z);
     x(z,:)= x(z,:)/xs(z);
end
for z=1:numResponses
        t(z,:)= t(z,:)-tm(z);
     t(z,:)= t(z,:)/ts(z);
end

XTrain = x(:,1:divi);
YTrain = t(:,1:divi);
XTest = x(:,divi+1:end);
YTest = t(:,divi+1:end);

%  mu = mean(XTrain');
%  sig = std(XTrain');
% 
%   mu2 = mean(YTrain');
%  sig2 = std(YTrain');
 
% XTrain = (XTrain - mu) ./ sig;
% XTrain =normalize(XTrain,2)
% YTrain = (YTrain - mu2) / sig2;
% 
% XTest = (XTest - mu) / sig;
%YTest = (YTest - mu2) / sig2;


numHiddenUnits = 250;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numResponses)
    regressionLayer];
%bilstmLayer

opts = trainingOptions('adam', ...
    'MaxEpochs',550, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');


net = trainNetwork(XTrain,YTrain,layers,opts);



[net,YPred_o ]= predictAndUpdateState(net,x);
%[net,YPred] = predictAndUpdateState(net,XTrain(:,end));
for z=1:numResponses
       
     t(z,:)= t(z,:)*ts(z);
     YPred_o(z,:)=YPred_o(z,:)*ts(z);
end
plot(YPred_o(1,:),'r')
hold on
plot(t(1,:),'b')

err=rssq(YPred_o-t);
 mean(err)
 
% numTimeStepsTest = length(XTest);
% for i = 2:numTimeStepsTest
%     [net,YPred(1,i)] = predictAndUpdateState(net,XTest(:,i-1));
% end
% plot(YPred )
% hold on
% plot(YTest )
% 
% YPred = sig2*YPred + mu2;
% 
% rmse = sqrt(mean((YPred-YTest).^2))
% figure;
% plot(YPred )
% hold on
% plot(YTest )






% data=x(1,:);
% figure
% plot(data(1:numTimeStepsTrain))
% hold on
% idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
% plot(idx,[data(numTimeStepsTrain) YPred],'.-')
% hold off
% xlabel("Month")
% ylabel("Cases")
% title("Forecast")
% legend(["Observed" "Forecast"])