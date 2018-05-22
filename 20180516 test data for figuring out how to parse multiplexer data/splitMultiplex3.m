% offline. 
% eventually need to do it online (20180516)

clc
clear all
close all

load('data_multiplexer.mat');

transitionIdx = [];

for idx = 1:numel(singleReading)-1
    curr = singleReading(idx);
    next = singleReading(idx+1);
    
    if(0.2*abs(curr) < abs(curr-next))
        disp('change');
        transitionIdx = [transitionIdx idx];
    end
end

figure;
hold on;
plot(singleReading);
for idx = 1 : numel(transitionIdx)
    plot([transitionIdx(idx) transitionIdx(idx)], [-.25 -2.5],'r');
end