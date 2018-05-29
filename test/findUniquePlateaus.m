clc
clear all
close all

numSensors = 3;
load('t4contacts.mat');

%%

[m,n] = size(singleReading);

plateau_sigs = zeros(length(singleReading), numSensors);

for i = 1:length(singleReading)
    sig(i,:) = abs(pwc_cluster(singleReading(i,:),[],0,0.1,1));
    
    
    % Jump penalization
name{8} = 'Jump penalty';
x(:,8) = pwc_jumppenalty(y,1,1.0);

% Robust jump penalization
name{9} = 'Robust jump penalty';
x(:,9) = pwc_jumppenalty(y,0,1.0);

% Bilateral filter with Gaussian kernel
name{10} = 'Bilateral filter';
x(:,10) = pwc_bilateral(y,1,200.0,5);

    [v, ind] = max(sig(i,:));
    sig(i,:) = circshift(sig(i,:), n+1-ind);

    % How to identify array elements that occur more than once
    sig_filt = sig(i,:);
    idx = find(hist(sig_filt,unique(sig_filt)) >= 4); % current challenge is that histogram sorts manually
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
    
    
%     if(length(plateau_sorted) < 3) % incorporate for the edge cases that
%     are breaking stuff.
%        plateau_sorted = [ 
%     end
    if(length(plateau_sorted) < 4)
       plateau_sorted = [plateau_sorted, plateau_sigs(i-1, end)]; 
    end
    if(length(plateau_sorted) < 5)
        plateau_sorted = [plateau_sorted, plateau_sorted(4)];
    end
    
    plateau_sigs(i,:) = [plateau_sorted(2), plateau_sorted(4), plateau_sorted(5)];
end


figure(1)
plot(plateau_sigs,'DisplayName','plateau_sigs')

%% Filter signal.

windowSize = 20;
plateau_sigFilt = plateau_sigs;
for i=1:numSensors
    %plateau_sigFilt(:,i) = filloutliers(plateau_sigs(:,i),'nearest', 'mean');
    plateau_sigFilt(:,i) = filloutliers(plateau_sigs(:,i),'nearest','movmean',windowSize);
end
figure(2)
plot(plateau_sigFilt, 'DisplayName', 'plateau_sigFilt');
title(['moving window:' num2str(windowSize)])

out=plateau_sigFilt;

%%
inp=inp2;
freq=50;%hz
inptime=1; %sec %based on arduino

inps=length(inp);
%inp=cell2mat(inp);
inp=repmat(inp,inptime*freq,1);
inp=reshape(inp,1,[]);
inp=inp';
%
asd=length(t);
t=[0;t];

out=out(1:asd,:);
out=[out(1,:);out];

pos=pos(:,1:asd,:);
pos=[pos(:,1,:) pos];
pos=double(pos);

for i=1:3
   [outp(:,i),yt]=resample(out(:,i),t(:,1),freq,'spline');
    
    for j=1:3
        for k=1:2
            [posp(j,:,k),yt]=resample(squeeze(pos(j,:,k)),t(:,1),freq,'spline');
        end
    end
end


% for i=1:length(sig)
%     plot(sig(i,:))
%     hold on
% end
