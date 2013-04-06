#include <matrix.h>
#include <math.h>
#include <mex.h>

int coord(int m, int n, int rows){
    return n * rows + m;
}

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[])
{
    unsigned short int *img12bits, *img16bits;
    int cols, rows, n, m;

    /*if (!mxIsDouble(F_ARG))
    {
        mexErrMsgTxt("Input data should be double. \n");
    }*/

    /* input */
    cols      = mxGetN(prhs[0]);
    rows      = mxGetM(prhs[0]);
    img12bits =  (unsigned short int*) mxGetPr(prhs[0]);
    
    /* output */
    plhs[0]       = mxCreateNumericMatrix(rows, cols, mxUINT16_CLASS, mxREAL);
    img16bits     = (unsigned short int*) mxGetData(plhs[0]);

    for(m = 0; m < rows; m++)
    {
        for(n = 0; n < cols; n++)
        {
            img16bits[coord(m, n, rows)] = img12bits[coord(m, n, rows)] * 16;
        }
    }
    return;
}
