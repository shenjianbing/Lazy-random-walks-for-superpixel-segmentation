#include <math.h>
#include "mex.h"

#define min( x, y ) ((x) > (y) ? (x) : (y))
#define max( x, y ) ((x) < (y) ? (x) : (y))

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
  double *img, *x, *y, *N;
  int iWidth, iHeight;
  int i, j, k, l;
  
  /* The input must be a noncomplex scalar double.*/
  iWidth = mxGetM(prhs[0]);
  iHeight = mxGetN(prhs[0]);

  /* Create matrix for the return argument. */
  plhs[0] = mxCreateDoubleMatrix(iWidth,iHeight, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(iWidth,iHeight, mxREAL);

  /* Assign pointers to each input and output. */
  img = mxGetPr(prhs[0]);
  N = mxGetPr(prhs[1]);
  x = mxGetPr(plhs[0]);
  y = mxGetPr(plhs[1]);
  
  for (j = (int)(*N); j < iHeight-(int)(*N); j++)
  {
    for (i = (int)(*N); i < iWidth-(int)(*N); i++)
    {
       double dMinValue = INT_MAX; 
       for (k = -(int)(*N); k <= (int)(*N); k++)
       {
          for (l = -(int)(*N); l <= (int)(*N); l++)
          {
             int iIndex = (j+k)*iWidth+i+l;
             
             if (img[iIndex] < dMinValue)
             {
                dMinValue = img[iIndex];
                x[j*iWidth+i] = i+l+1;
                y[j*iWidth+i] = j+k+1;
             }
          }
       }
    }
  }
}
