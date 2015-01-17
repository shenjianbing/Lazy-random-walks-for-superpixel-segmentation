#include "mex.h"

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
  double *phi;
  mxLogical *contour;
  int iWidth, iHeight;
  int i, j, k, l;
  
  /* The input must be a noncomplex scalar double.*/
  iHeight = mxGetM(prhs[0]);
  iWidth = mxGetN(prhs[0]);

  /* Create matrix for the return argument. */
  plhs[0] = mxCreateLogicalMatrix(iHeight,iWidth);
  
  /* Assign pointers to each input and output. */
  phi = mxGetPr(prhs[0]);
  contour = mxGetLogicals(plhs[0]);

  for (i = 0; i < iWidth; i++)
  {
    for (j = 0; j < iHeight; j++)
    {
      if (phi[i*iHeight+j] >= 0)
      {
        bool bIsNeighbourBelowZero = false;

        for (k = -1; k <= 1; k++)
        {
          for (l = -1; l <= 1; l++)
          {
            if (i+k >= 0 && i+k < iWidth &&
                j+l >= 0 && j+l < iHeight &&
                phi[(i+k)*iHeight+j+l] < 0)
            {
              if (-phi[(i+k)*iHeight+j+l] < phi[i*iHeight+j])
              {
                contour[(i+k)*iHeight+j+l] = true;
              }
              else
              {
                contour[i*iHeight+j] = true;
              }

            }
          }
        }
        
//         if (bIsNeighbourBelowZero)
//         {
//           contour[i*iHeight+j] = true;
//         }
      }
    }
  }
}
