
%% LCR Meter Reader
clear out
clear t
rng(3536)
addpath('C:\Users\thoma\Desktop\LCR\NatNetSDK\Samples\Matlab')
timeStepEnd = 15000;
% Find a VISA-USB object.
obj1 = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0957::0x0909::MY54202935::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = visa('AGILENT', 'USB0::0x0957::0x0909::MY54202935::0::INSTR');
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

% Communicating with instrument object, obj1.
type = query(obj1, ':FUNCtion:IMPedance:TYPE?');

query(obj1, ':FUNCtion:IMPedance:TYPE RX');%%CPD|CPQ|CPG|CPRP|CSD|CSQ|CSRS|LPD|LPQ|LPG|LPRP|LPRD|LSD|LSQ|LSRS|LS
%%RD|RX|ZTD|ZTR|GB|YTD|YTR|VDID
query(obj1, ':FREQuency:CW 300000');
query(obj1, ':APERture SHORt');%SHORt  MEDium
query(obj1, ':DISPlay:ENABle 0');%disable display



disp('LCR Connected.');

%%


natnetclient = natnet;

% connect the client to the server (multicast over local loopback) -
% modify for your network
fprintf( 'Connecting to the server\n' )
natnetclient.HostIP = '169.254.35.191';
natnetclient.ClientIP = '169.254.35.191';
natnetclient.ConnectionType = 'Multicast';
natnetclient.connect;
if ( natnetclient.IsConnected == 0 )
    fprintf( 'Client failed to connect\n' )
    return
end
%% Main Data Collection

dev_mult = serial('COM4','BaudRate',115200);

fopen(dev_mult)
pause(1)


dev = serial('COM3','BaudRate',115200);
fopen(dev)
pause(1)

inp2=35*rand(1,1000);
inp2=round(inp2);
for i=1:1000
    fprintf(dev,'%d/n' ,(inp2(1,i)));
    pause(0.01)
    hop(1,i)=fscanf(dev,'%i');
end
clear i
fprintf(dev,'%i',1)



i=1
tic
for i = 1:timeStepEnd
    
    % Get current time
    for count=1:3
        fprintf(dev_mult,'%d/n' ,count);
        if count==1
           pause(0.015)
        end
        data = query(obj1, ':FETCh:IMPedance:FORMatted?');
        
        splt = strsplit(data,',');
        
        out(i,1,count) = str2double(splt(1)); % LCR 1
        out(i,2,count) = str2double(splt(2)); % LCR 2
    end
    data_opti = natnetclient.getFrame;
    for j = 1:2
        %fprintf( 'Name:"%s"  ', model.RigidBody( 1 ).Name )
        pos(1,i,j)=data_opti.UnlabeledMarker(j).x*1000 ;
        pos(2,i,j)=data_opti.UnlabeledMarker(j).y*1000 ;
        pos(3,i,j)=data_opti.UnlabeledMarker(j).z*1000 ;
    end
    
    t(i,1) = toc;
    inp=inp2(1,ceil(t(i,1)));
    outr=out(i,:);
     if i>1
       % inplstm=[inp,out(1:i,rx),outpf(1:i-1,rx)]';
        inplstm=[inp,outr]';
        inplstm= inplstm-xm(:);
        inplstm= inplstm./xs(:);
        [net,YPred_o(:,i) ]= predictAndUpdateState(net,inplstm);
        YPred_o(1,i)=YPred_o(1,i)*ts(1);
         YPred_o(2,i)=YPred_o(2,i)*ts(2);
         YPred_o(3,i)=YPred_o(2,i)*ts(3);
  %  scatter(YPred_o(1,i),YPred_o(2,i))
    % plot(YPred_o(1,1:i))
    %drawnow()
    hold on
    end
    
    %a=t(i,1);
    
end

fprintf(dev,'%i',2)
% Disconnect from instrument object, obj1.
fclose(obj1);
fclose(dev);
fclose(dev_mult);


%inp={2, 0,1.5,2.5,0.5,1,0,2.5,0,1.5,0.5,2.5,1.8,0.2};
%inp={0.2, 0,0.4,0.5,0.6,0.9,0.4,1.2,1.3,1.2,2.3,1.2,2.3,1.5,2.5,2.4,2.3,2.1,2.5,0,1.5,0,2.5,2,1.7,1.5,1,0.1};



%inp={0,1.5};
%inp={0.2, 0,0.4,0.5,0.6,0.9,0.4,1.2,1.3,2.9,2.3,1.2,2.3,1.5,2.5,2.4,2.3,2.1,2.5,0,1.5,0,2.5,2,1.7,1.5,1,0.1,3.5,2.5,0.5,3.4,1.2,1.9,2.5};

inp=inp2;
freq=20;%hz
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
% stp=floor(length(yt)/(inps*inptime*freq));
% inp=repmat(inp,stp,1);
