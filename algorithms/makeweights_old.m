function weights=makeweights_old(edges,vals,valScale, gradients,geomScale,EPSILON)
%Function weights=makeweights(edges,vals,valScale,points,geomScale,EPSILON)
%computes weights for a point and edge list based upon element values and 
%Euclidean distance.  The user controls the parameters valScale and 
%geomScale that bias the weights toward distance or pixel values, 
%respectively. 
%
%Inputs:    edges - An Mx2 list of M edges indexing into points
%           vals - An NxK list of nodal values 
%           valScale - The scale parameter for vals (e.g., 20)
%           points - Optional NxP list of N vertex locations in P 
%               dimensions           
%           geomScale - Optional scale parameter for points (required if
%               points are specified)
%           EPSILON - Optional value of the minimum allowable weight, used
%               to ensure numerical stability.  Default: EPSILON = 1e-5.
%
%Outputs:   weights - An Mx1 vector indexed by edge containing the weights 
%           corresponding to that edge
%
%Note1: The L2 norm is used to compute intensity difference of 
%color vectors.  Therefore, the colors vectors should be pre-converted to 
%best color space (e.g., LUV) for the problem.
%
%Constants
if nargin < 6
    EPSILON = 1e-5;%%Optional value of the minimum allowable weight, used
%               to ensure numerical stability.  Default: EPSILON = 1e-5.
end
%Compute intensity differences

sigma=sqrt(length(vals)/100)/2;
% x=1:length(vals);
Gsigma=exp(-(vals.^2)/sigma^2);
%% Compute geomDistances, if desired
   gamma=0.12;
Ex=gradients./(Gsigma.*gradients +  gamma * ones(length(gradients),1));
 v=1;
  dist=exp(Ex/v);
  geomDistances=abs(dist(edges(:,1),:)- dist(edges(:,2),:));
 geomDistances=normalize(geomDistances);
geomScale=50;
%Compute Gaussian weights
weights =exp(-(geomScale*geomDistances ))+EPSILON;
