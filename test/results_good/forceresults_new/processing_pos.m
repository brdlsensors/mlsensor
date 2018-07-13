%% Resampling pos data to 10 Hz for correct error analysis

clear outp
clear posp
inp=inp2;
freq=10;%hz
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

for i=1:6
    [outp(:,i),yt]=resample(out(:,i),t(:,1),freq,'spline');
    
    
end
for i=1:2
    for j=1:3
        
        [posp(j,:,i),yt]=resample(squeeze(pos(j,:,i)),t(:,1),freq,'spline');
    end
end