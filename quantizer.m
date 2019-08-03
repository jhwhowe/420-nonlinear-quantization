function [ y_quantized ] = quantizer( y_C, numBits )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

y_quantized = zeros(numel(y_C), 1);

QSteps = 2 ^ (numBits - 1);
stepSize = 1/QSteps;

for i = 1:numel(y_C)
    % limit the signal
%     if y_C(i) > 1 - stepSize
%         y_C(i) = 1 - stepSize
%     elseif y_C(i) < -1
%         y_C(i) = -1
%     end
    % quantize
    y_quantized(i) = stepSize .* floor((y_C(i) / stepSize) + 1/2);
end

end

