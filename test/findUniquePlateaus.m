clc
clear all
close all

load('t1.mat');
i = 64;
sig(i,:) = abs(pwc_cluster(singleReading(i,:),[],0,0.05,1));

% How to identify array elements that occur more than once
sig_filt = sig(i,:);
idx = find(hist(sig_filt,unique(sig_filt))>4); % current challenge is that histogram sorts manually
uniqVals = unique(sig_filt);
plateau = uniqVals(idx)

[counts, centers] = hist(sig_filt, unique(sig_filt))

figure;
plot(sig_filt)

ordering = zeros(size(plateau));
for i=1:length(plateau)
    vals = find(sig_filt == plateau(i));
    ordering(i) = vals(1);
end

%%
[ordering_sorted, ordering_order] = sort(ordering)
plateau_sorted = plateau(ordering_order)



%%

