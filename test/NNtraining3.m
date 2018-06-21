
trainFcn = 'trainlm';  % training algorithm 


hiddenLayerSize=[50];
net = fitnet(hiddenLayerSize,trainFcn);


net.input.processFcns = {'removeconstantrows','mapminmax'}; % normalization
net.output.processFcns = {'removeconstantrows','mapminmax'};
%net.layers{2}.transferFcn='satlins';
%net.layers{1}.transferFcn='radbas';
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.epochs=500;

net.performFcn = 'mse';  

net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};



[net,tr] = train(net,x,t,{},{});%,err(:,1:n-1));-- if you have data about uncertainty of individual samples


y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

net.performParam.normalization='standard';
trainTargets = t .* tr.trainMask{1};
valTargets = t  .* tr.valMask{1};
testTargets = t  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y )
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)


y = net(x);
% err=y-t;
% plot(err(1,:))
% 
% figure;
% plot(err(2,:))
% figure;
% 
% plot(y)
% hold on
% plot(t)
% plot(tt)


plot(y)
hold on
plot(t)
 hold on

xx=x;
% 
% for i=5000:10000
%     yy = net(xx);
%     xx(4,i+1)=yy(1,i);
%     xx(3,i+1)=xx(4,i);
% end

% test(:,1)=net(x(:,1));
%  test(:,2)=net(x(:,2));
%  
% for i=1:1000
%   
%     test(:,i+2)=net([test(1:6,i+1);posi(i+2,:)';posi(i+1,:)']);
%     
%     if mod(i,30)==0
%         test(:,i+2)=t(:,i+1);
%         test(:,i+1)=t(:,i);
%     end
% end
% plot(test(1,:))
% hold on
% plot(t(1,:))



%  normA = outp(1:end-100,1) - min(outp(1:end-100,1));
% normA = normA ./ max(normA(:));
% 
% plot(normA)
% hold on