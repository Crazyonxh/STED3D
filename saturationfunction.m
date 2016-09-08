function [ eta ] = saturationfunction(Edfield,Ispeak)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
eta=1./(1+Edfield.^2/Ispeak);

end

