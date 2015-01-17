function weights=makeweights(edges,vals,valScale,points,geomScale,EPSILON)
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

%Constants
if nargin < 6
    EPSILON = 1e-5;
end

%Compute intensity differences
if valScale > 0
    valDistances=sqrt(sum((vals(edges(:,1),:)- ...
        vals(edges(:,2),:)).^2,2));
    valDistances=normalize(valDistances); %Normalize to [0,1]
else
    valDistances=zeros(size(edges,1),1);
    valScale=0;
end

%Compute geomDistances, if desired
if (nargin > 5) & (geomScale ~= 0)
    geomDistances=sqrt(abs(sum((points(edges(:,1),:)- ...
        points(edges(:,2),:)).^2,2)));
    geomDistances=normalize(geomDistances); %Normalize to [0,1]
else
    geomDistances=zeros(size(edges,1),1);
    geomScale=0;
end

%Compute Gaussian weights
weights=exp(-(geomScale*geomDistances + valScale*valDistances))+ EPSILON;
