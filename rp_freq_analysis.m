function rp_freq_analysis(y,t)
% function rp_freq_analysis(y,t)
%
% nabbed it from the internet.

Fs = 1/(t(2)-t(1));
% Calculate fft
ydft = fft(y);
% Only take one side of the Fourier transform
ydft = 2*ydft(1:ceil((length(y)+1)/2));
% Calculate the frequencies
freq = 0:Fs/length(y):Fs/2;
% Normalise according to length of signal
ydft = ydft/(2*length(freq));
figure,
subplot(3,1,1), plot(t,y), xlabel('Time [s]')
grid on
subplot(3,1,2), semilogy(1./freq,abs(ydft)), xlabel('period [s]')
grid on
subplot(3,1,3), semilogy(freq,abs(ydft)), xlabel('frequency [Hz]')
grid on