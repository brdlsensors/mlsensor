timeStepEnd=10000;


i=1
tic
for i = 1:timeStepEnd
    
  

    
    %t(i,1) = toc;
    
    %% Online learning.
    inp=inp2(1,ceil(t(i,1))); % interpolate the data if it's not already at 10 Hz.
    outr(i,:)=out(i,:); %-out(1,:)+[4673 -1912 2778 -1358 3046 -1263]; % take the values of outp at the current instance in time, i, and convert from 3d to 2d.
    
    if i>1
        for k=1:6 % RX channels x3, for 3 sensors.
            % [tempval,yt]=resample(outr(i-1:i,k),t(i-1:i,1),10,'linear');
            % Linear interpolation. to interpolate the data 10 Hz.
            outp(1,k)=outr(i-1,k)+(outr(i,k)-outr(i-1,k))*0.1/(t(i)-t(i-1));
            
        end
        % inplstm=[inp,out(1:i,rx),outpf(1:i-1,rx)]';
        inplstm=[inp,outp(1,:)]'; % only need to train on the current instance in time.
        
        % Normalize the input for LSTM.
        inplstm = inplstm-xm(:);
        inplstm = inplstm./xs(:);
        
        % NN predict and update state.
        [net,YPred_o(:,i)] = predictAndUpdateState(net,inplstm);
        % Undo normalization.
        YPred_o(1,i)=YPred_o(1,i)*ts(1)+tm(1);
        YPred_o(2,i)=YPred_o(2,i)*ts(2)+tm(2);
        YPred_o(3,i)=YPred_o(3,i)*ts(3)+tm(3);
        
         
           
        
        
        
        
    end
    
    %a=t(i,1);
    
end
