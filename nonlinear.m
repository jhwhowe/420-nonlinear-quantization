clear all, close all

format compact

%histogram to show error increases with higher inputs 

numBits = 4;

% Load audio and normalise 
% [y_orig,Fs] = audioread('loudme.wav');
[y_orig,Fs] = audioread('kanye.wav');
y_orig = y_orig(:,1);
y = y_orig;
test = linspace(-1,1,2000)';

map = brewermap(2,'Set1'); 
[me,Fs] = audioread('loudme.wav');
[ye,Fs] = audioread('kanye.wav');
ye = ye(342720:end,1);
figure()
histf(ye,-1.3:.01:1.3,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none');
hold on
histf(me,-1.3:.01:1.3,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none');
box off
axis tight
ylim([0,1e5])
xlim([-0.5,0.5])
title('Histogram showing the distribution of speech signals')
legalpha('Loud Talking','Normal Talking','location','northwest')
legend boxoff

mu = 2^8-1; %standard mu parameter used is 255 
A = 87.6; %standard A parameter used is 87.6

% compand signal
y_mu_c = compand(y,mu,max(abs(y)),'mu/compressor');
y_a_c = compand(y,A,max(abs(y)),'A/compressor');

test_mu_c = compand(test,mu,max(abs(test)),'mu/compressor');
test_a_c = compand(test,A,max(abs(test)),'A/compressor');


% uniformly quantize
y_mu_quantized = quantizer(y_mu_c, numBits);
y_a_quantized = quantizer(y_a_c, numBits);
y_normal_quantized = quantizer(y, numBits);

test_mu_quantized = quantizer(test_mu_c, numBits);
test_a_quantized = quantizer(test_a_c, numBits);
test_normal_quantized = quantizer(test, numBits);

% expand signal out again
mu_out = compand(y_mu_quantized,mu,max(abs(y_mu_quantized)),'mu/expander');
a_out = compand(y_a_quantized,A,max(abs(y_a_quantized)),'A/expander')';

test_mu_out = compand(test_mu_quantized,mu,max(abs(test_mu_quantized)),'mu/expander');
test_a_out = compand(test_a_quantized,A,max(abs(test_a_quantized)),'A/expander')';

linear_error = y_normal_quantized - y_orig;
mu_error = mu_out - y_orig;
a_error = a_out - y_orig;

linear_SNR = snr(y_normal_quantized, linear_error)
mu_SNR = snr(mu_out, mu_error)
a_SNR = snr(a_out, a_error)

figure()
plot(y_orig)
title('Read Sound Data')

figure()
plot(y_normal_quantized)
title('Linear quantized output')
ylim([-1,1])

figure()
plot(a_out)
title('A-law non-linear quantized output')
ylim([-1,1])


figure()
subplot(2,1,1)
plot(a_error)

abs_a_e = mean(abs(a_error))

title('Error in A-law non-linear quantized output')
ylim([min(a_error),max(a_error)])
xlabel('Sample')
ylabel('Magnitude')
subplot(2,1,2)
plot(linear_error)

abs_lin_e = mean(abs(linear_error))

title('Error in linear quantized output')
ylim([min(a_error),max(a_error)])
xlabel('Sample')
ylabel('Magnitude')
% ylim([-0.05,0.05])

% figure()
% plot(test_mu_out)
% 
% figure()
% plot(test_normal_quantized)

% autoArrangeFigures(3, 3, 1) 

figure()
histf(a_error,-1.3:.01:1.3,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none');
hold on
histf(linear_error,-1.3:.01:1.3,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none');
box off
axis tight
% ylim([0,1e5])
xlim([-0.25,0.25])
title('Histogram of the errors from linear and non-linear quantization')
legalpha('A-Law error','Linear error','location','northwest')
legend boxoff
% write out quantized signal
%audiowrite('song_Mu_quantized.wav', mu_out, Fs);
%audiowrite('song_Mu_quantized_error.wav', mu_out - y, Fs);
%audiowrite('song_normal_quantised.wav', y_normal_quantized, Fs);
%audiowrite('song_normal_quantised_error.wav', y_normal_quantized - y, Fs);
% audiowrite('kanye_Mu_quantized.wav', mu_out, Fs);
% audiowrite('kanye_Mu_quantized_error.wav', mu_error, Fs);
% audiowrite('kanye_A_quantized.wav', a_out, Fs);
% audiowrite('kanye_A_quantized_error.wav', a_error, Fs);
% audiowrite('kanye_normal_quantized.wav', y_normal_quantized, Fs);
% audiowrite('kanye_normal_quantized_error.wav', linear_error, Fs);
% audiowrite('kanye_a_mu_diff.wav', a_out - mu_out, Fs);
fprintf('Files written\n')

