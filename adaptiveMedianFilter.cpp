#include <matrix.h>
#include <math.h>
#include <mex.h>

int coord(int m, int n, int rows){
    return n * rows + m;
}

void quickSort(unsigned short int *flat, int size)
{
    int i;
    for(i = 0; i < size; i++)
    {
        mexPrintf("%d \t", flat[i]);
    }
    mexPrintf("\n");
}

void walkArray(unsigned short int *image, int m, int n, int rows, int size)
{
    int i, j;
    int c = 0;
    int max, min;
    unsigned short int *flat;

    flat = (unsigned short int*) mxCreateNumericMatrix(1, 9, mxUINT16_CLASS, mxREAL);
    
    flat[0] = image[coord(m, n, rows)];
    flat[1] = image[coord(m, n + 1, rows)];
    flat[2] = image[coord(m, n + 2, rows)];
    flat[3] = image[coord(m + 1, n, rows)];
    flat[4] = image[coord(m + 1, n + 1, rows)];
    flat[5] = image[coord(m + 1, n + 2, rows)];
    flat[6] = image[coord(m + 2, n, rows)];
    flat[7] = image[coord(m + 2, n + 1, rows)];
    flat[8] = image[coord(m + 2, n + 2, rows)];

    /*
    for(i = m; i < (m + size); i++)
    {
        for(j = n; j < (n + size); j++)
        {
            flat[c] = image[coord(i, j, rows)];
            mexPrintf("%d \t",c);
            c = c + 1;
        }
        mexPrintf("\n");
    }
    mexPrintf("-<>-<>-\n");
    */

    quickSort(flat, 9);
}

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[])
{
    unsigned short int *input, *output;
    mwSize cols, rows, n, m;
    mwSize sizeOfWindow = 3;
    mwSize maxSizeOfWindow = 7;

    /* input */
    cols            = mxGetN(prhs[0]);
    rows            = mxGetM(prhs[0]);
    input           = (unsigned short int*) mxGetPr(prhs[0]);

    /* output */
    plhs[0]       = mxCreateNumericMatrix(rows, cols, mxUINT16_CLASS, mxREAL);
    output        = (unsigned short int*) mxGetData(plhs[0]);

    for(m = 49; m < 51; m++)
    {
        for(n = 49; n < 51; n++)
        {
            walkArray(input, m, n, rows, sizeOfWindow);
        }
    }
    
    return;
}
