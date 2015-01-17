function [prob, labels_idx] = LRW(W,seeds,labels,alpha,N)
% Do lazy random walk
%input:
%         W--adjacency matrix
%         seeds--seeds coordinate
%         labels--labels correspond to seeds
%         alpha-- lazy parameter
%         N-- total number of pixels in image
%Output:
%         labels_idx--assigned labels for each pixel
%         prob-- max probability of pixels belongs to corresponding labels
%pre-processing
K=length(labels);
I = sparse(1:N,1:N,ones(N,1)); 
D_inv = sparse(1:N,1:N,1./sum(W)); % get 
lines = zeros(N,K);
for k=1:K,
    label_idx = find(labels(:)==k);
    Mk = size(label_idx,1);
    lines(seeds(label_idx(:)),k) = 1/Mk;%average of probabilities,lines=1/Mk*blk
    clear label_idx;
end;
iD_inv=sqrt(D_inv);clear D_inv;
S=iD_inv*W*iD_inv; 
cmtime_cmp=(I-alpha*S)\lines;
%% normalization
likelihoods = zeros(N,K);
for k=1:K,
    likelihoods(:,k) = cmtime_cmp(:,k)/sum(cmtime_cmp(:,k));%normalize Z==sum(R(:,k))?
end;
probs = sparse(1:N,1:N,1./sum(likelihoods,2))*likelihoods;%the probability of each pixel belongs to each label
%% Estimate posteriors and labels
 [prob,labels_idx] = max(probs,[],2); 
% figure;imshow(prob);

end
