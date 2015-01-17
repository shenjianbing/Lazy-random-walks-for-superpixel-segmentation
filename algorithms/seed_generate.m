function [ labels idx ] = seed_generate( img,seeds )
%SEED_GENERATE Summary of this function goes here
%   Detailed explanation goes here

[X Y Z]=size(img);
img=rgb2gray(img);
K=length(seeds);

labels=1:K;
ind = sub2ind(size(img),seeds(:,1),seeds(:,2));
% idx=(seeds(:,2)-1)*X+seeds(:,1);
idx=ind;
end

