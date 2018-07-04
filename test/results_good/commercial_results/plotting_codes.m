%run('processing_pos.m')


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

subplot(3,1,1)
plot(pos_pred(1,:))
hold on
plot(pos_ref(1,:))

subplot(3,1,2)
plot(pos_pred(2,:))
hold on
plot(pos_ref(2,:))

subplot(3,1,3)
plot(pos_pred(3,:))
hold on
plot(pos_ref(3,:))

% subplot(4,1,4)
% plot(err)

% mean(err(50:end-50))
% plot(err)

% plot(forc(1:i))
% hold on
% plot(YPred_o(end,1:i))
% 
% 
% plot(YPred_o(1,1:i),'b')
% %                 drawnow()
% hold on
% plot(squeeze(pos(1,1:i,2))-squeeze(pos(1,1:i,1)),'r') % *position COULD be off slightly because it's not being interpolated upon.
% 
% 
% [a,ind]=max(pos_ref(3,:));
% [a,ind2]=min(pos_ref(3,:));
% rssq(pos_ref(:,ind)-pos_ref(:,ind2))