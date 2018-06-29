 

clc
close all

axislim = 30;

x1 = YPred_o(1,:);
y1 = YPred_o(2,:);
z1 = YPred_o(3,:);

x2 = t(1,:);
y2 = t(2,:);
z2 = t(3,:); 

figure;
for i = 10:length(YPred_o(1,:))
    hold on;
    view(0,90);
    %(90, 0) seemed closer to top view.
    grid on;
    
    % predicted
    plot3(x1(i),y1(i),z1(i), 'o', 'MarkerSize', 14, 'MarkerEdgeColor', 'blue');
    plot3(x1(i-1),y1(i-1),z1(i-1), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'blue') ;
    plot3(x1(i-2),y1(i-2),z1(i-2), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'blue') ;
    plot3(x1(i-3),y1(i-3),z1(i-3), 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'blue') ;
    plot3(x1(i-4),y1(i-4),z1(i-4), 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'blue') ;
    plot3(x1(i-5),y1(i-5),z1(i-5), 'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'blue') ;
    plot3(x1(i-6),y1(i-6),z1(i-6), 'o', 'MarkerSize', 4, 'MarkerEdgeColor', 'blue') ;
    plot3(x1(i-7),y1(i-7),z1(i-7), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'blue') ;
    plot3(x1(i-8),y1(i-8),z1(i-8), 'o', 'MarkerSize', 2, 'MarkerEdgeColor', 'blue') ;
    plot3(x1(i-9),y1(i-9),z1(i-9), 'o', 'MarkerSize', 1, 'MarkerEdgeColor', 'blue') ;
    
    % actual
    plot3(x2(i),y2(i),z2(i), 'o', 'MarkerSize', 14, 'MarkerEdgeColor', 'red');
    plot3(x2(i-1),y2(i-1),z2(i-1), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'red') ;
    plot3(x2(i-2),y2(i-2),z2(i-2), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'red') ;
    plot3(x2(i-3),y2(i-3),z2(i-3), 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'red') ;
    plot3(x2(i-4),y2(i-4),z2(i-4), 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'red') ;
    plot3(x2(i-5),y2(i-5),z2(i-5), 'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'red') ;
    plot3(x2(i-6),y2(i-6),z2(i-6), 'o', 'MarkerSize', 4, 'MarkerEdgeColor', 'red') ;
    plot3(x2(i-7),y2(i-7),z2(i-7), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'red') ;
    plot3(x2(i-8),y2(i-8),z2(i-8), 'o', 'MarkerSize', 2, 'MarkerEdgeColor', 'red') ;
    plot3(x2(i-9),y2(i-9),z2(i-9), 'o', 'MarkerSize', 1, 'MarkerEdgeColor', 'red') ;
    hold off;
    
    set(gca,'XLim',[-axislim axislim],'YLim',[-axislim axislim],'ZLim',[-axislim axislim])
    drawnow
    pause(0.1)
    clf
end
