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
    tim(i)=toc;
end
