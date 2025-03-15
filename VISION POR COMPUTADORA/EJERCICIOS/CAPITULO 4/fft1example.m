clear all
close all

x=1:120;

s1=sin(x*pi/60); % Signal 1 cycle.

s2=sin(x*pi/30); % Signal 2 cicle.

s4=sin(x*pi/15); % Signal 4 cicle.

%s=s4;
%s=s1+s4;
%s=s1+s2+s4;
s=s1+s2+randn(1,120)*.5;
plot(s)
grid on

% Sampling frequency 120 points per second
fs=120;
figure

[freq, power]=showfft(s,1/fs,'ob',1);

%power(find(freq == max(freq)))
 showfft(s,1/fs,'ob',1); % 1 cicle per second for s1 at fs=120

