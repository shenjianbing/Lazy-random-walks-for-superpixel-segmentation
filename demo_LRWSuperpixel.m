% function [ output_args ] = demo_LazyRWSuperpixel( input_args )
% DEMO Summary of this function goes here

% clear all;
close all;
addpath('algorithms');
addpath('mex');
% matlabpool local 4
% maxNumCompThreads(8);
% setenv('OMP_NUM_THREADS', '8');

%% parameter setting
Nsp=200; %num of sp
Thres=1.35; %threshold for split
beta=30; %gaussian parameter 
alpha=0.9992; %Lazy parameter
nItrs_max = 10;% limit for the number of iterations
img = imread(strcat('290.jpg'));
img = imresize(img,0.25);
img=im2double(img);
[X,Y,Z]=size(img);
gray_img=rgb2gray(img);

%% seed generate
N_init = round(Nsp/4); % initialize the number of seed to 1/4 of target seeds number
expSuperPixelDist = sqrt(numel(gray_img)/N_init);
normSigma = floor(expSuperPixelDist / 2.5);
[speed] = get_speed_based_on_gradient(gray_img,normSigma); %used for seeds relocate
% Place initial seeds and compute the initial signed distanece
seeds = get_initial_seeds(gray_img, N_init, speed);
%% energy optimize
tic
[label_img, center_points, ~]=energy_opt(img,seeds,alpha,beta,Thres, Nsp, nItrs_max);
disp(['total time elapsed:' num2str(toc)]);
%% results of each image
[bmap] = seg2bmap(label_img,Y,X);
idx = find(bmap>0);
bmapOnImg = img(:,:,1);
bmapOnImg(idx) = 1;
if Z==3
    temp=img(:,:,2);
    temp(idx)=0;
bmapOnImg(:,:,2) = temp;
    temp=img(:,:,3);
    temp(idx)=0;
bmapOnImg(:,:,3) = temp;
end

figure('name','bmap');imshow(bmapOnImg); 
imwrite(bmapOnImg,'result.bmp'); 