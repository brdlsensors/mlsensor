
sfreq=2; % downsampling frequency.
lag=100;% cut off the beginning part.
siz=length(outp)/1-lag-100; % size of posp (position matrix)..
rx=[1:6]; % which RX pairs of the LCR to use.


% Downsampling the actual frequency by sfreq.
% initial frequency: 20 (from sampling_LCR_multi_triggered.m) divided by 2
% (sfreq) = 10 Hz.
inpf=inp(1:sfreq:end);
outpf=outp(1:sfreq:end,:);
pospf=posp(:,1:sfreq:end,:); 
siz=siz/sfreq;

%outpf(:,2:3)=rand(47200,2);
offset=0;
% combining pressure values (inpf) and sensor values (outpf).
x=[inpf(3+lag+offset:siz+2+offset,1),outpf(3+lag+offset:siz+2+offset,rx)]';
%x=[inpf(3+lag:siz+2,1),outpf(3+lag:siz+2,rx),outpf(2+lag:siz+1,rx)]';
%x=[outpf(3+lag:siz+2,rx),outpf(2+lag:siz+1,rx)]';
%x=[outpf(3+lag:siz+2,rx)]';
 %x=[inpf(3+lag+offset:siz+2+offset,1)]';
% t=[outpf(3+lag:siz+2,rx)]';


%x=[inpf(3+lag:siz+2,1)]';
%x=[outpf(3+lag:siz+2,rx)]';

%x=[outpf(3+lag:siz+2,rx),outpf(2+lag:siz+1,rx)]';
%t=squeeze(pospf(1,3+lag:siz+2,2));
%t=rssq(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1)));
% subtracting second marker from the first in order to determine the
% relative positioning.
t=[(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1))) ];
%t=[(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1))) ;outpf(3+lag:siz+2,7)' ];
%t=[inpf(2+lag:siz+1,1)]';

%% Build training and testing sets.
% Number of inputs/outputs.
inputSize = size(x,1);
numResponses = size(t,1);

% Where to split the data between testing and training..
%t=t+60*randn(1,length(t));
divi=floor(0.8*length(x));
numTimeStepsTrain=divi;

%numTimeStepsTrain = floor(0.9*numel(data));
% x=normalize(x,2);
% t=normalize(t,2);

xm=mean(x');
xs=std(x');
tm=mean(t');
ts=std(t');

% Normalizing by mean and stdev for both inputs/outputs.
for z=1:inputSize
    x(z,:)= x(z,:)-xm(z);
     x(z,:)= x(z,:)/xs(z);
end
for z=1:numResponses
        t(z,:)= t(z,:)-tm(z);
     t(z,:)= t(z,:)/ts(z);
end
% Same as above but without the explicit computation of the mean and stdev:
%x=normalize(x,2);
%t=normalize(t,2);

% Split the data based on the index.
XTrain = x(:,1:divi);
YTrain = t(:,1:divi);
XTest = x(:,divi+1:end);
YTest = t(:,divi+1:end);


%% Parameters for LSTM.
numHiddenUnits = 50;
% Computational capability/complexity of the network. 30 is picked via trial and
% error. As small as possible to prevent overfitting. Want the smallest
% layer that can predict position AND contact. Should also be able to
% predict position, because that is a degenerate case (subset).

layers = [ ...
    sequenceInputLayer(inputSize)
    %clippedReluLayer(10)
    dropoutLayer(0.5) %dropout should prevent overfitting and make predicitons more robust to noise
    lstmLayer(numHiddenUnits)%,'OutputMode','last'
    fullyConnectedLayer(numResponses)
    regressionLayer];
%bilstmLayer

opts = trainingOptions('adam', ...
    'MaxEpochs',2000, ... % number of training iterations.
    'MiniBatchSize', 512,... %%%512
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005*1, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125*1, ...%%changed
    'LearnRateDropFactor',0.2/1, ...%%
    'Verbose',0, ...
    'Plots','training-progress', 'ExecutionEnvironment', 'gpu');

% Training.
net = trainNetwork(XTrain,YTrain,layers,opts);

% Predict for the whole dataset.
[net,YPred_o]= predictAndUpdateState(net,x);
%[net,YPred] = predictAndUpdateState(net,XTrain(:,end));

% Undo the normalization.
for z=1:numResponses
     t(z,:)= t(z,:)*ts(z);
     YPred_o(z,:)=YPred_o(z,:)*ts(z);
end

% Plotting.
plot(YPred_o(3,:),'r')
hold on
plot(t(3,:),'b')
% figure;
% plot(YPred_o(4,:),'r')
% hold on
% plot(t(4,:),'b')

% Error. 
err=rssq(YPred_o(1:3,:)-t(1:3,:));
test_s=0.8*length(err);
mean(err(test_s:end)) % mean error for only the test set.
 
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





% for i=1:18955
%     if squeeze(posp(3,i,1)) <-110
%         a=posp(:,i,1);
%         b=posp(:,i,2);
%         posp(:,i,1)=b;
%         posp(:,i,2)=a;
%     end
% end
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