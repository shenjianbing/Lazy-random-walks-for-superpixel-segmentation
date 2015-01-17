function [ dx dy dxx dyy dxy ] = weight_function( m )
%WEIGHT_FUNCTION Summary of this function goes here
%   Detailed explanation goes here
 [x y]=size(m);
 dxx=zeros(x,y);
 dyy=zeros(x,y);
[dx dy]=gradient(m);
 temp=diff(m,2,1);
 dyy(2:x-1,:)=temp;
 temp=diff(m,2,2);
 dxx(:,2:y-1)=temp;
 dxy=dx+dy./2;

end

