%clear; close all; clc


s = daq.createSession('digilent')

ch = addAnalogInputChannel(s,'AD1', 1, 'Voltage')
s.Rate = 300e3;
s.Channels.Range = [-5 5];
ch.Range=[-5 5];
%%s.IsContinuous = true;
%queueOutputData(s)
%ch2.Offset=5;
%s.Channels.TerminalConfig='SingleEnded' %
%'Differential', 'SingleEnded',
%'SingleEndedNonReferenced', 'PseudoDifferential'
s.DurationInSeconds = 0.001 
count=1;
ind=1;
stp=1;
tic
for i=1:10000
     [singleReading(i), triggerTime(i)] = inputSingleScan(s);
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
%          
%      end
    tim(i)=toc;
end
