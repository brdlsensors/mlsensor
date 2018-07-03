%run('processing_pos.m')
[a,ind]=max(pos_ref(3,:));
[a,ind2]=min(pos_ref(3,:));
rssq(pos_ref(:,ind)-pos_ref(:,ind2))

test_per=length(pos);
for i=1:test_per
    if pos(3,i,2)>pos(3,i,1)
        asd= pos(:,i,2);
        pos(:,i,2)=pos(:,i,1);
        pos(:,i,1)=asd;
    end
end
pos_ref=squeeze(pos(:,:,2))-squeeze(pos(:,:,1));
pos_pred=YPred_o(:,1:test_per);

err=rssq(pos_pred-pos_ref);

mean(err(50:end-50))
plot(err)

plot(forc(1:i))
hold on
plot(YPred_o(end,1:i))


plot(YPred_o(1,1:i),'b')
%                 drawnow()
hold on
plot(squeeze(pos(1,1:i,2))-squeeze(pos(1,1:i,1)),'r') % *position COULD be off slightly because it's not being interpolated upon.
