 siz=25000;
% sfreq=1;
% lag=10;
% 
% rx=1:2;


%inp(4+lag:siz+3,1),
%x=[inp(3+lag:siz+2,1),outp(1+lag:siz,2),outp(2+lag:siz+1,2)]';%,outp(lag:siz-1,1)
outp=outp-outp(1,:);

inpf=inp(1:sfreq:end);
outpf=outp(1:sfreq:end,:);
pospf=posp(:,1:sfreq:end,:);
siz=siz/sfreq;




x=[inpf(3+lag:siz+2,1),outpf(3+lag:siz+2,rx)]';

%x=[outpf(3+lag:siz+2,rx)]';
%t=squeeze(pospf(1,3+lag:siz+2,2));
%t=rssq(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1)));
t=(squeeze(pospf(:,3+lag:siz+2,2))-squeeze(pospf(:,3+lag:siz+2,1)));



X = tonndata(x,true,false);
T = tonndata(t,true,false);

[x,xi,ai,t] = preparets(net,X,T);


y = net(x,xi,ai);
e = gsubtract(t,y);
performance = perform(net,t,y)

figure;
yt=cell2mat(y);
tt=cell2mat(t);
plot(yt(1,:))
hold on
plot(tt(1,:))

figure;
scatter3(tt(1,:),tt(2,:),tt(3,:))
hold on
scatter3(yt(1,:),yt(2,:),yt(3,:))