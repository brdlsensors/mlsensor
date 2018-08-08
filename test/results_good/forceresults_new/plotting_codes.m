%run('processing_pos.m')
i=asd;
plot(YPred_o(end,50:860))
hold on
plot(forc(50:860))
mv=10;
avt=movmean(forc,mv);
plot(avt(50:860))


figure;
err=abs(YPred_o(end,2:i)-forc(2:i));

plot(err)