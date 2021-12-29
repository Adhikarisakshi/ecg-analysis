clc
clear all
close all

[fname,path]=uigetfile('.','choose the ecg signal file');

ecg=load(fname);

%getting sample frequency and the gain used to measure ECG signal
fs=input('sampling frequency=');
g=input('gain used=');

ecg_sig=(ecg.val)./g; 
n=1:length(ecg_sig);  
t=n./fs; 

wt=modwt(ecg_sig,4,'sym4');  
wtrec=zeros(size(wt));

wtrec(3:4,:)=wt(3:4,:);
y=imodwt(wtrec,'sym4');

y=abs(y).^2;
yavg=mean(y);

[R_peaks,locs]=findpeaks(y,n,'minpeakheight',8*yavg,'minpeakdistance',50);

n_beats=length(locs);
timelimit=length(ecg_sig)/fs;

bpm=(n_beats*60)/timelimit;
disp(strcat('heart rate is',num2str(bpm)))
 
if(bpm<60)
    disp('BRADYCARDIA');
elseif(bpm>100)
    disp('TACHYCARDIA');
    else
        disp('NORMAL');
end
    

subplot(211)
plot(t,ecg_sig);
xlim([0,timelimit]);
grid on;
xlabel('seconds')
title('ecg signal')

subplot(212)
plot(n,y);
xlim([0,length(ecg_sig)]);
grid on;
hold on
plot(locs,R_peaks,'RO')
xlabel('samples')
title('R peak found')


