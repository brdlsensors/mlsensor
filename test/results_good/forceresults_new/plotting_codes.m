%run('processing_pos.m')
%i=asd;
mx=max(forc(50:860)*222.411*10/(204.8*884.72));
mi=min(forc(50:860)*222.411*10/(204.8*884.72));
forc(50:860)=forc(50:860)*222.411*10/(204.8*884.72)-mi;
YPred_o(end,50:860)=YPred_o(end,50:860)*222.411*10/(204.8*884.72)-mi;
plot(YPred_o(end,50:860))
hold on
plot(forc(50:860))
mv=10;
avt=movmean(forc(50:860),mv);
plot(avt)
err2=abs(YPred_o(end,50:860)-avt);
yyaxis right
area(err2)
% figure;
% err=abs(YPred_o(end,2:i)-forc(2:i));
% err2=abs(YPred_o(end,2:i)-avt(2:i));
% plot(err)
