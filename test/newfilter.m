clc
clear all
close all

numSensors = 3;
load('commercialt1rep.mat');
clear out
i=0;
%%

[m,n] = size(singleReading);
count=i+1;

siga=abs(singleReading);
for i = count:length(singleReading)
   % sig(i,:) = abs(pwc_cluster(singleReading(i,:),[],0,0.1,1));
    
 % sig(i,:) = abs(pwc_jumppenalty(singleReading(i,:),1,1.0,0));  % Jump penalization
  %   sig(i,:) = abs(pwc_bilateral(singleReading(i,:),1,200.0,5));% Bilateral filter with Gaussian kernel

     idx=find(siga(i,:)>4.5);
    ind= idx(diff(diff(diff(idx)))==0);
    if isempty(ind)
        ind=idx(1);
    end
    
    %[v, ind] = max(sig(i,:));
    siga(i,:) = circshift(siga(i,:), n+1-ind(1));
    siga(i,:)=medfilt1(siga(i,:));
   wtf=(find(siga(i,:)>4.5));
   wtf=wtf(wtf>33);
   if isempty(wtf)
       c=n;
   else
       c=wtf(1)+1;
   end
   sig=siga(i,1:c);
    idx=find(sig<0.2);
    ind= idx((diff(diff(idx)))==0);
    
    a=ind(1);
   % b=ind(find(diff(ind)>1)+1);
   b=ind(end);
    
    jk1 =(pwc_cluster(sig(1:a),[],0,0.1,1));
    unNum   = unique(jk1);
    idx = find(hist(jk1,unNum) >= 3);
    plateau = unNum(idx);
    out(i,1)=plateau(find(plateau<4&plateau>2));
  %  jk2=(pwc_cluster(sig(a:b),[],0,0.1,1));
     jk2=(pwc_cluster(sig(a:end),[],0,0.1,1));
        unNum   = unique(jk2);
    idx = find(hist(jk2,unNum) >= 3);
    plateau = unNum(idx);
    juk= plateau(find(plateau<4.5&plateau>3.3));
    out(i,2)=juk(1);
%     jk3 =(pwc_cluster(sig(b:end),[],0,0.1,1));
%         unNum   = unique(jk3);
%     idx = find(hist(jk3,unNum) >= 3);
%     plateau = unNum(idx);
%     juk= plateau(find(plateau<2.5&plateau>1.5));
%     out(i,3)=juk(1);
    
    

end


% figure(1)
% plot(plateau_sigs,'DisplayName','plateau_sigs')

%% Filter signal.

% windowSize = 20;
% plateau_sigFilt = plateau_sigs;
% for i=1:numSensors
%     %plateau_sigFilt(:,i) = filloutliers(plateau_sigs(:,i),'nearest', 'mean');
%     plateau_sigFilt(:,i) = filloutliers(plateau_sigs(:,i),'nearest','movmean',windowSize);
% end
% figure(2)
% plot(plateau_sigFilt, 'DisplayName', 'plateau_sigFilt');
% title(['moving window:' num2str(windowSize)])
% 
% out=plateau_sigFilt;

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
[sa,sb]=size(out);
for i=1:sb
   [outp(:,i),yt]=resample(out(:,i),t(:,1),freq,'spline');
    
    for j=1:3
        for k=1:2
            [posp(j,:,k),yt]=resample(squeeze(pos(j,:,k)),t(:,1),freq,'spline');
        end
    end
end


% for i=1:100:10000
%     plot(sig(i,:))
%     hold on
% end
