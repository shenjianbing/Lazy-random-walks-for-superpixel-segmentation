function [ labels, idx ] = seed_transform( img,seeds )
%input:
%         img--original image
%         seeds--seeds coordinate
%Output:
%         labels--assigned labels for each seed point
%         idx--the index number of seeds in the image
img=rgb2gray(img);
K=length(seeds);
labels=1:K;
idx = sub2ind(size(img),seeds(:,1),seeds(:,2));
end

