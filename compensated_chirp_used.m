% Create a chirp with compensation for the Fresnel ringing
filename = 'mychirp.wav'; % Filename to write to
fs = 48e3; % Sample frequency [Hz]
T = 50e-3; % Duration of chirp [s]
Twav = 60; % Duration of .wav [s]
fend = 6500; % Highest frequency of chirp [Hz]

ts = 1 / fs;
df = 1 / T;

t = 0:ts:T;
f = 0:df:fs;

x = chirp(t, 0, T, fend);
X = fft(x);

% Replace the magnitude in the chirp band with constant value, but keep the
% phase from the original chirp.
sel = f <= fend | f >= (fs - fend);
Ytarget = X;
Ytarget(sel) = rms(Ytarget(sel)) * exp(1i .* angle(Ytarget(sel)));
y = ifft(Ytarget);
y = real(y);

%16 bits. 128 microphone channel appended [mic1_measure1,
%mic2_measure2..., mic1_measure2, mic2_measure2]

% The recorded signal does not need to be phase-matched, i.e. the recording
% can start at any time in the signal. Test this by uncommenting the line
% below. Note that the recorded length does need to be exactly one period
% of the chirp, or the spectrum will be a pulse train instead.
%y = circshift(y, 10000, 2);

% The recorded signal should *not* be windowed, or the energy per band will
% not be flat. You can test this by modifying the window function below.
wnd = rectwin(length(y)).';
Y = fft(y .* wnd);

figure(1)
plot(t, x);
hold all;
plot(t, y);
hold off;
legend('Original chirp', 'Compensated chirp');
xlabel('Time [s]');
ylabel('Amplitude [-]');

figure(2);
plot(f, mag2db(abs(X)));
hold all;
plot(f, mag2db(abs(Y)));
hold off;
legend('Original chirp', 'Compensated chirp');
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');

% Write file of approximately 1 minute
ywav = y ./ max(abs(y));
ywav = repmat(ywav, 1, ceil(Twav / T));
ywav = ywav(1:round(Twav * fs));
audiowrite(filename, ywav, fs);