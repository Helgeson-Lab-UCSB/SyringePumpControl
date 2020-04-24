clear all

%if Matlab can't find COM run this
if ~isempty(instrfind)
     fclose(instrfind);
     delete(instrfind);
end


pump1 = serial('COM6');%change this to the COM port that the syringe pump is connected to
set(pump1,'BaudRate',9600,'DataBits',8,'Parity','none','StopBits',2);
fopen(pump1);
%fprintf(pump1, ['pumpaddress', 'command ## units' char(13)])

%Config pump01
% Clears syringe pump 1 volume accumulator to zero.
fprintf(pump1,['01','CLV' char(13)]);
pause(0.1)
% Sets diameter of syringe in mm.  (Flow rate is reset to 0 following this command.)
fprintf(pump1,['01','DIA 26.7' char(13)]);
pause(1)%keep pause at 1 because it needs to set RAT to 0
%Mode:choose btw PMP (Pump Mode), VOL (Volume Mode) and PGM (Program Mode)
fprintf(pump1, ['01','MOD PMP' char(13)]); 
pause(0.1);
%!!Pump won't run if Infuse rate=0!!
fprintf(pump1,['01','RAT 0.01'  char(13)]);
pause(0.1) %in seconds
%%%% Sets syringe pump 1 target volume to 1 mL.
% fprintf(pump1,['TAR 1.0' char(13)]);
% pause(0.1)


%Config pump02
% Clears syringe pump 1 volume accumulator to zero.
fprintf(pump1,['02','CLV' char(13)]);
pause(0.1)
% Sets diameter of syringe in mm.  (Flow rate is reset to 0 following this command.)
fprintf(pump1,['02','DIA 26.7' char(13)]);
pause(1)%keep pause at 1 because it needs to set RAT to 0
%Mode:choose btw PMP (Pump Mode), VOL (Volume Mode) and PGM (Program Mode)
fprintf(pump1, ['02','MOD PMP' char(13)]); 
pause(0.1);
%!!Pump won't run if Infuse rate=0!!
fprintf(pump1,['02','RAT 0.01' char(13)]);
pause(0.1) %in seconds


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% ENTER PARAMETER HERE %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set parameter for pump 01
rate1_01 = 0.09;
rate2_01 = 1;
time_01 = 60*10; %in sec
n_01 = 0.5; %steps per sec max. depending 
dir_01 = 'REF'; %set pumping direction


%Set parameter for pump 02
rate1_02 = 0.1;
rate2_02 = 1;
time_02 = 60*10; %in sec
n_02 = 0.5; %steps per sec max. 15
dir_02 = 'INF'; %set pumping direction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pumping direction: choose btw INF (infusion), REF (Refill) and REV
%(Reverses current pumping direction)
fprintf(pump1, ['01','DIR' dir_01 char(13)]);
pause(0.1);
fprintf(pump1, ['02','DIR' dir_02 char(13)]);
pause(0.1);

 if strcmp(dir_01, 'INF') == 1
    pump_dir_01 = 'RAT';
 elseif strcmp(dir_01, 'REF') == 1
     pump_dir_01 = 'RFR';
 end

 if strcmp(dir_02, 'INF') == 1
    pump_dir_02 = 'RAT';
 elseif strcmp(dir_02, 'REF') == 1
     pump_dir_02 = 'RFR';
 end

 
%Calculate rate incresement per step for each pump
% rate_inc_01 = (rate2_01 - rate1_01)/(time_01*n_01);
% rate_inc_02 = (rate2_02 - rate1_02)/(time_02*n_02);

%%%Constant flow rate
fprintf(pump1,['01', 'RAT', num2str(rate1_01) char(13)]);
pause(0.25) %in seconds

fprintf(pump1,['02','RAT', num2str(rate1_02) char(13)]);
pause(0.25) %in seconds


fprintf(pump1,['01','RUN' char(13)]);
fprintf(pump1,['02','RUN' char(13)]);
 
toc = 0.005;

% %Ramping
% while (rate1_01 < rate2_01)
%     pause((1/n_01)-toc);
%     rate1_01 = rate1_01 + rate_inc_01;
%     rate1_02 = rate1_02 + rate_inc_02;
%     tic
%     fprintf(pump1,['01', pump_dir_01 , num2str(rate1_01, '%.4f'), 'MM' char(13)]);
%     fprintf(pump1,['02', pump_dir_02 , num2str(rate1_02, '%.4f'), 'MM' char(13)]); 
%     toc
% end  
% 
% pause(30)
% 
% % fprintf(pump1, ['01','DIR ', 'INF' char(13)]);
% % pause(0.1);
% fprintf(pump1,['01', 'RAT', num2str(rate2_01) char(13)]);
% pause(0.25) %in seconds
% 
% fprintf(pump1,['02','RAT', num2str(rate2_02) char(13)]);
% pause(0.25) %in seconds

pause(time_01)

fprintf(pump1,['01','STP' char(13)]);
pause(0.25)
fprintf(pump1,['02','STP' char(13)]);
pause(1)
fclose(pump1)
delete(pump1)
clear pump1