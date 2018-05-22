%%
for i=1:length(singleReading)
    
    sig(i,:) = pwc_cluster((medfilt1(singleReading(i,:))),[],0,0.1,1);
    
      
    asd=unique(sig(i,:),'stable');
    if length(asd)<3
        out(i,1:2)=asd(1:2);
        out(i,3)=asd(2); 
    else
        out(i,:)=asd(1:3);
    end
end

%%
inp=inp2;
freq=50;%hz
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
    [outp(:,i),yt]=resample(out(:,i),t(:,1),freq,'spline');

    for j=1:3
      for k=1:2
        [posp(j,:,k),yt]=resample(squeeze(pos(j,:,k)),t(:,1),freq,'spline');
      end
    end
end





