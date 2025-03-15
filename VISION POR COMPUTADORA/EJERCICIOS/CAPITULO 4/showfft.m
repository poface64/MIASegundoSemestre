function varargout = showfft(X, Ts, S, NORM)

%[freq, power]=showfft(detrend(Y(1:100)),3,'k');
%power(find(freq == max(freq)))

%SHOWFFT    [freq, power] = showfft(X, Ts, S, NORM)
%
%	Returns the magnitude of the positive frequencies
%	of the FFT in power and the corresponding frequency values in freq
%	and displays the Fourier Power spectrum of data X.  
%       Ts is the sampling period of data. The default value is 0.04.
%	S can be chosen for line types, plot symbols and colors.
%	The default value is 'y-'.
%       NORM = 1 normlized power magnitude. The default value is 0.
%	

if any([nargin < 1 nargin > 4])
  error ('SHOWFFT: Wrong number of input arguments')
end
if nargin == 1
   Ts = 0.04;
   S = 'y-';
   NORM = 0;
else
   if nargin == 2
      S = 'y-';
      NORM = 0;
   else
      if nargin == 3
         NORM = 0; 
      end
   end;
end;

len = length(X);
nyquist = 1/(Ts*2);
freq = linspace(0, nyquist, len/2)';
X = X - min(X);
pow = fft(X);
pow = pow(1:floor(len/2)).*conj(pow(1:floor(len/2)))/len;

pow(1) = 0;

if NORM == 1
   pow = pow/sum(pow);
end

if nargout == 2
   varargout{1} = pow;
   varargout{2} = freq;
elseif nargout == 1
   varargout{1} = pow;
elseif nargout == 0    
   %get(gcf);
   %semilogx(freq, 10*log10(pow), S)
   semilogx(freq, pow, S)
   xlabel('Frequency (Hz)') 
   ylabel('Power Spectrum Magnitude ');
   if NORM == 0
      title('FFT Spectral Estimate')
   else
      title('Normalized Fourier Power Spectrum')
   end
   grid on
end



