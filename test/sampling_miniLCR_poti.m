clear; close all; clc
rng(147424)

s = daq.createSession('digilent')

ch = addAnalogInputChannel(s,'AD1', 1, 'Voltage')
s.DurationInSeconds = 0.001;
s.Channels.Range = [-5 5];
ch.Range=[-5 5];
% ch2=addFunctionGeneratorChannel(s,'AD1',1,'DC')
% s.IsContinuous = true;
% queueOutputData(s)
% ch2.Gain=0;
% ch2.Offset=5;
s.Rate = 300e3;


% startBackground(s);
% count=1;
% ind=1;
% stp=1;
% tic
% for i=1:10000
%     %[singleReading(i), triggerTime(i)] = inputSingleScan(s);
%      if singleReading(i)<-1.9 && ind <6 &&count==1
%          inp(ind,count,stp)=singleReading(i);
%          ind=ind+1;
%      elseif ind==6
%          count=2;
%          ind=1;
%      end
%      if singleReading(i)>-1.2 && ind <6  &&count==2
%          inp(ind,count,stp)=singleReading(i);
%          ind=ind+1;
%      elseif ind==6
%          count=3;
%          ind=1;
%      end
%      if singleReading(i)<-1.2  &&singleReading(i)>-1.9 && ind <6  &&count==3
%          inp(ind,count,stp)=singleReading(i);
%          ind=ind+1;
%      elseif ind==6
%          count=1;
%          ind=1;
%          stp=stp+1;
%          tim(stp)=tic;
%      end
%
% end

%% LCR Meter Reader


addpath('C:\Users\thoma\Desktop\mlsensor\test\NatNetSDK\Samples\Matlab')
timeStepEnd = 30000;


%%


natnetclient = natnet;

% connect the client to the server (multicast over local loopback) -
% modify for your network
fprintf( 'Connecting to the server\n' )
natnetclient.HostIP = '169.254.35.191';
natnetclient.ClientIP = '169.254.35.191';
natnetclient.ConnectionType = 'Multicast';
natnetclient.connect;
if ( natnetclient.IsConnected == 0 )
    fprintf( 'Client failed to connect\n' )
    return
end
%% Main Data Collection

out = zeros(timeStepEnd,4);

dev = serial('COM3','BaudRate',250000);
fopen(dev)
pause(5)

inp2=35*rand(1,1000);
inp2=round(inp2);
for i=1:1000
    fprintf(dev,'%d/n' ,(inp2(1,i)));
    pause(0.01)
    hop(1,i)=fscanf(dev,'%i');
end

%pause(5)
fprintf(dev,'%i',1)

i=1
tic
for i = 1:timeStepEnd
    
    % Get current time
    for kk=1:50
        [singleReading(i,kk), triggerTime(i,kk)] = inputSingleScan(s);
    end
    
    data_opti = natnetclient.getFrame;
    for j = 1:2
        %fprintf( 'Name:"%s"  ', model.RigidBody( 1 ).Name )
        pos (1,i,j)=data_opti.UnlabeledMarker(j).x*1000 ;
        pos(2,i,j)=data_opti.UnlabeledMarker(j).y*1000 ;
        pos(3,i,j)=data_opti.UnlabeledMarker(j).z*1000 ;
    end
    t(i,1) = toc;
    
    
end

fprintf(dev,'%i',2)
% Disconnect from instrument object, obj1.

fclose(dev);


%%
% sig=sig';
% sig(:);
% plot(ans)

%plot(sig(i,:))
%hold on
%     asd= uniquetol(sig(i,:),0.1);
%      if length (asd)>3
%        sig(i,:) = pwc_cluster(singleReading(i,:),[],0,0.2,1);
%     % asd= uniquetol(sig(i,:),0.1);
%      elseif length(asd)<3
%              sig(i,:) = pwc_cluster(singleReading(i,:),[],0,0.03,1);
%      asd= uniquetol(sig(i,:),0.1);
%      end
%     outp(i,:)=asd(1:3);
% outp(i,:)= asd(1<histc(sig(i,:),unique(sig(i,:))));
% sig(i,:)  = pwc_cluster(singleReading(i,:),[],1,500.0,0);
