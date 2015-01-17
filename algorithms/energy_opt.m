function [label_img, center_points, numIterations]=energy_opt(img, center_points , alpha,sigma, Thres , Nsp, nItrs_max)
%Iteratively optimize the superpixel result
%input:
%         img--original image
%         center_points-- initial seeds position
%         alpha-- lazy parameter
%         sigma-- gaussian parameter
%         Thres-- threshold for split
%         Nsp-- num of superpixels
%         nItrs_max--limit for the number of iterations 
%Output:
%         label_img-- a label matrix with each element(label) correspond to image pixel.
%         center_points-- final result superpixel's center points
%         numIterations-- num of iterations took to optimize the energy
%         function

%% pre-define
[X Y Z]=size(img); N = X*Y; % image size
phi=0.8;
if Z > 1,
    Lab = colorspace('Lab<-', img); % convert color space           
end;
imgVals = reshape(Lab,N,Z); clear Lab;
[~, edges] = lattice(X,Y,1);
weights = makeweights(edges,imgVals,sigma);
W = adjacency(edges,weights,N); clear edges weights;
 %% get lbp value
[~, LBP] = lbp(rgb2gray(img),1,8,getmapping(8,'u2'),'h');
area_aver=sum(sum(LBP))/Nsp; %average area of superpixels
%% optimization
numIterations=0;
Ncenters=length(center_points);
 % if num of centers is bigger than user specialized Nsp or the number of iterations exceed the limit, break
while Ncenters<Nsp && numIterations<= nItrs_max
    %%%LazyRW
   [labels, seeds_idx ] = seed_transform(img,center_points); % get the index and label of each seed from coordinate
   st=clock;
   [prob ,labels_idx] = LRW(W,seeds_idx,labels,alpha,N); % do lazy random walk
   fprintf(' took %.2f second\n',etime(clock,st));  
   label_img = reshape(labels_idx,X,Y); 
%    figure;imagesc(label_img);
   prob_map=reshape(prob,X,Y);
   Cmt=1-prob_map;          %commute time
   Wx_all=exp(-Cmt/phi);% compute W_x
   centers_new=[];
   numIterations=numIterations+1;
   %%center relocate and sp split
   Ncenters=length(center_points); % the number of superpixels at present
   for i=1:Ncenters
        %%% center relocation
        [r,c]=find(label_img==i);
         Cmt_s=Cmt(label_img==i);
         Wx=Wx_all(label_img==i);
         mask=repmat(center_points(i,:),length(r),1); 
         dists=sqrt(sum((mask-[r c]).^2,2));
         % exclude the center point,avoid NaN value
         idx_centre=dists==0;
         Cmt_s(idx_centre)=[];
         r(idx_centre)=[];
         c(idx_centre)=[];
         dists(idx_centre)=[];
         Wx(idx_centre)=[];
         mass=sum(Wx.*(Cmt_s./dists));
         %compute new location of seed
        cp_new(1)=sum(Wx.*(Cmt_s./dists).*r)/mass;
        cp_new(2)=sum(Wx.*(Cmt_s./dists).*c)/mass;
        % detect the shift distance of centre points, if <1.5,then continue
        if sqrt(sum((round(cp_new)-center_points(i,:)).^2))<=1.5
            area_l=sum(LBP(label_img==i));% compute the area of superpixel i
            lbpratio=area_l/area_aver;
            % determing whether to split or not by Thres parameter
            if lbpratio>=Thres
                  % do split
                mask(end,:)=[];
                %compute pca convariance matrix M
                M=ones(2,2);
                temp_Cs=Cmt_s.^2./dists.^2;
                crd_diff=[r c]-mask;
                M(1)=sum(temp_Cs.*crd_diff(:,1).^2);
                M(2)=sum(temp_Cs.*crd_diff(:,1).*crd_diff(:,2));
                M(3)=M(2);
                M(4)=sum(temp_Cs.*crd_diff(:,2).^2);
                [U,~,~] = svd(M); %  get the eigenvector of convariance matrix M
               temp_split=crd_diff*U(:,1);
               mass1=sum(Cmt_s(temp_split>0)./dists(temp_split>0));
               mass2=sum(Cmt_s(temp_split<0)./dists(temp_split<0));
               % compute the two smaller new superpixels
                c1(1)=sum((Cmt_s(temp_split>0)./dists(temp_split>0)).*r(temp_split>0))/mass1;
                c1(2)=sum((Cmt_s(temp_split>0)./dists(temp_split>0)).*c(temp_split>0))/mass1;
                c2(1)=sum((Cmt_s(temp_split<0)./dists(temp_split<0)).*r(temp_split<0))/mass2;
                c2(2)=sum((Cmt_s(temp_split<0)./dists(temp_split<0)).*c(temp_split<0))/mass2;
                centers_new=[centers_new;c1;c2]; % add two smaller superpixels to the new_superpixels set
               else
                 centers_new=[centers_new;cp_new]; 
             end
         else
            centers_new=[centers_new;cp_new]; 
         end %if
    end %for
center_points=round(centers_new); % update the center points of superpixels
clear centers_new;
end %While
%% final result
[labels, seeds_idx ] = seed_transform(img,center_points); % get the index and label of each seed
st=clock;
%generate final label result from optimized seed location
[~, labels_idx] = LRW(W,seeds_idx,labels,alpha,N);
fprintf('final took %.2f second\n',etime(clock,st));  
label_img = reshape(labels_idx,X,Y);
end