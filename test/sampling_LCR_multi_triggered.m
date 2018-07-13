
%% LCR Meter Reader
clear; clc
rng(78484574)
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

% Communicating with the LCR - parameters of the device including reading
% type, frequency. (all the info is in the datasheet).
query(obj1, ':FUNCtion:IMPedance:TYPE RX');%%CPD|CPQ|CPG|CPRP|CSD|CSQ|CSRS|LPD|LPQ|LPG|LPRP|LPRD|LSD|LSQ|LSRS|LS
%%RD|RX|ZTD|ZTR|GB|YTD|YTR|VDID
query(obj1, ':FREQuency:CW 300000');
query(obj1, ':APERture SHORt');%SHORt  MEDium
query(obj1, ':DISPlay:ENABle 0');%disable display

disp('LCR Connected.');

%% Network parameters for Optitrack.
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

%% Main Data Collection - connecting to the multiplexer for the Arduino and VCS.

% Multiplexer.
dev_mult = serial('COM4','BaudRate',115200);

fopen(dev_mult)
pause(1)

% VCS (pneumatic controller).
dev = serial('COM3','BaudRate',115200);
fopen(dev)
pause(1)

% Send random values for the actuation to the controller.
inp2=35*rand(1,1000); % pick 1000 random values between 0 to 3.5 bars
% (this range includes the scaling performed in the Arduino code, which is
% sent this way because it's easier to send the data as an integer).
inp2=round(inp2);
% Wite the random values to serial.
for i=1:1000
    fprintf(dev,'%d/n' ,(inp2(1,i)));
    pause(0.01)
    hop(1,i)=fscanf(dev,'%i');
end
clear i
fprintf(dev,'%i',1) % Start the controller.
% [Possibly a synchronization issue here with simultaneous trigger - maybe the reason for small delay]



% Read the resulting multiplexed data from the LCR.
i=1
tic
for i = 1:timeStepEnd
    % Get current time
    for count=1:3
        fprintf(dev_mult,'%d/n' ,count);
        pause(0.01)
        if 1 == count
            data_opti = natnetclient.getFrame;
            for j = 1:2
                pos(1,i,j)=data_opti.UnlabeledMarker(j).x*1000 ;
                pos(2,i,j)=data_opti.UnlabeledMarker(j).y*1000 ;
                pos(3,i,j)=data_opti.UnlabeledMarker(j).z*1000 ;
            end
        end
        data = query(obj1, ':FETCh:IMPedance:FORMatted?');
        
        splt = strsplit(data,',');
        
        out(i,1,count) = str2double(splt(1)); % LCR channel 1
        out(i,2,count) = str2double(splt(2)); % LCR channel 2
    end
    % Get the position of the end effector based on the optitrack reading.
    %     data_opti = natnetclient.getFrame;
    %     for j = 1:2
    %         pos(1,i,j)=data_opti.UnlabeledMarker(j).x*1000 ;
    %         pos(2,i,j)=data_opti.UnlabeledMarker(j).y*1000 ;
    %         pos(3,i,j)=data_opti.UnlabeledMarker(j).z*1000 ;
    %     end
    t(i,1) = toc;
    % Print a message at approximately 80% for the point to start
    % generating testing data.
    if 0 == mod(i,1000)
        i
    end
end

% Stop the controller VCS.
fprintf(dev,'%i',2)
% Disconnect from instrument object, obj1.
fclose(obj1);
fclose(dev);
fclose(dev_mult);





inp=inp2;
freq=20;% sampling frequency of data [hz]
inptime=1;%sec%based on arduino

inps=length(inp);
inp=repmat(inp,inptime*freq,1);
inp=reshape(inp,1,[]);
inp=inp';

% Time vector generated by tic toc.
tIntervals=length(t);
t=[0;t]; % Assume that t=0 is when the input starts (this might not be true because of loop delay in Arduino).

% Take the starting value and use it as the value at t = 0.
out=out(1:tIntervals,:); % Take the first tIntervals of the out matrix and merge from 3d matrix to 2d matrix (collapse a dimension using test(n,:))
out=[out(1,:);out]; % Duplicate first row of the out matrix.
pos=pos(:,1:tIntervals,:);
pos=[pos(:,1,:) pos];
pos=double(pos);
 for i=1:length(pos)
     
     if pos(2,i,2)>-20
         pl_hold= pos(:,i,2);
          pos(:,i,2)= pos(:,i,1);
          pos(:,i,1)=pl_hold;
     end
 end
for i=1:6 % 6 total RX pairs of the LCR.
    [outp(:,i),yt]=resample(out(:,i),t(:,1),freq,'spline'); % interpolate the outp signal. 'spline' has some vibration at the start/beginning of signal.
end
for i=1:2 % 2 markers.
    for j=1:3 % 3 coordinates xyz per marker.
        [posp(j,:,i),yt]=resample(squeeze(pos(j,:,i)),t(:,1),freq,'spline'); % interpolate the outp signal.
    end
end
% stp=floor(length(yt)/(inps*inptime*freq));
% inp=repmat(inp,stp,1);
for i=1:length(out)
    if out (i,1)>100000
        out (i,1:2)=out (i-1,1:2);
    end
end