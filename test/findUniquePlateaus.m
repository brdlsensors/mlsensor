clc
clear all
close all

numSensors = 3;
load('t1_2.mat');

%%

[m,n] = size(singleReading);

plateau_sigs = zeros(length(singleReading), numSensors);

for i = 1:length(singleReading)
    sig(i,:) = abs(pwc_cluster(singleReading(i,:),[],0,0.1,1));
    [v, ind] = max(sig(i,:));
    sig(i,:) = circshift(sig(i,:), n+1-ind);

    % How to identify array elements that occur more than once
    sig_filt = sig(i,:);
    idx = find(hist(sig_filt,unique(sig_filt))>4); % current challenge is that histogram sorts manually
    uniqVals = unique(sig_filt);
    plateau = uniqVals(idx);

    [counts, centers] = hist(sig_filt, unique(sig_filt));

    %figure;
    %plot(sig_filt)

    ordering = zeros(size(plateau));
    for k=1:length(plateau)
        vals = find(sig_filt == plateau(k));
        ordering(k) = vals(1); % take the first value that represents the plateau.
    end

    [ordering_sorted, ordering_order] = sort(ordering);
    plateau_sorted = plateau(ordering_order);
    
    if(length(plateau_sorted) < 4)
       plateau_sorted = [plateau_sorted, plateau_sigs(i-1, end)]; 
    end
    if(length(plateau_sorted) < 5)
        plateau_sorted = [plateau_sorted, plateau_sorted(4)];
    end
    
    plateau_sigs(i,:) = [plateau_sorted(2), plateau_sorted(4), plateau_sorted(5)];
end


%plot(plateau_sigs,'DisplayName','plateau_sigs')


windowSize = 5;
plateau_sigFilt = zeros(size(plateau_sigs));
for i=1:numSensors
    plateau_sigFilt(:,i) = medfilt1(plateau_sigs(:,i), windowSize);
end
plot(plateau_sigFilt, 'DisplayName', 'plateau_sigFilt');
