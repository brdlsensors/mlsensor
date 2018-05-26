% clc
% clear all
% close all

numSensors = 3;
%load('t1_4contacts.mat');

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


plot(plateau_sigs,'DisplayName','plateau_sigs')


windowSize = 5;
plateau_sigFilt = zeros(size(plateau_sigs));
for i=1:numSensors
    plateau_sigFilt(:,i) = medfilt1(plateau_sigs(:,i), windowSize); % BSTODO: improve this line to not apply the median filter to the entire signal, but rather only the points that are outliers.
end
%plot(plateau_sigFilt, 'DisplayName', 'plateau_sigFilt');

out=plateau_sigFilt;
%%
inp=inp2;
freq=20;%hz
inptime=1;%sec%based on arduino

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
   % [outp(:,i),yt]=resample(out(:,i),t(:,1),freq,'spline');
    
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
