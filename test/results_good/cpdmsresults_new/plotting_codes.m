%run('processing_pos.m')


test_per=length(pos);
% for i=1:test_per
%     if pos(3,i,2)>pos(3,i,1)
%         asd= pos(:,i,2);
%         pos(:,i,2)=pos(:,i,1);
%         pos(:,i,1)=asd;
%     end
% end
pos_ref=squeeze(pos(:,:,2))-squeeze(pos(:,:,1));
pos_pred=YPred_o(:,1:test_per);

err=rssq(pos_pred-pos_ref);

% subplot(3,1,1)
% plot(pos_pred(1,:))
% hold on
% plot(pos_ref(1,:))
% 
% subplot(3,1,2)
% plot(pos_pred(2,:))
% hold on
% plot(pos_ref(2,:))
% 
% subplot(3,1,3)
% plot(pos_pred(3,:))
% hold on
% plot(pos_ref(3,:))

beg=550;
fin=1000;
subplot(3,4,1:2)
plot([beg:fin]/10,-pos_ref(3,beg:fin))
hold on
plot([beg:fin]/10,-pos_pred(3,beg:fin))

subplot(3,4,3:4)
plot([beg:fin]/10,pos_ref(2,beg:fin))
hold on
plot([beg:fin]/10,pos_pred(2,beg:fin))

subplot(3,4,5:12)

%scatter(pos_ref(3,beg:fin),pos_ref(2,beg:fin),30,err(beg:fin),'filled')
plot(-pos_ref(3,beg:fin),pos_ref(2,beg:fin))
hold on
plot(-pos_pred(3,beg:fin),pos_pred(2,beg:fin))
 axis equal
% colormap cool
% colorbar

% plot3(beg:fin,pos_ref(3,beg:fin),pos_ref(2,beg:fin))
% hold on
% plot3(beg:fin,pos_pred(3,beg:fin),pos_pred(2,beg:fin))
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


st=14300;
ed=14600;
%subplot(2,1,1)
plot(YTrain(end,st:ed))
hold on
yyaxis right
plot(XTrain(2,st:ed))
%subplot(2,1,2)
lls=min(XTrain(1,st:ed));
area(XTrain(1,st:ed)-lls)