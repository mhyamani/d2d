#include "experimentaldata8_BBFCE271B4718DC74AC5C63B1AC8330B.h"
#include <cvodes/cvodes.h>
#include <cvodes/cvodes_dense.h>
#include <cvodes/cvodes_sparse.h>
#include <nvector/nvector_serial.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>
#include <sundials/sundials_sparse.h>
#include <cvodes/cvodes_klu.h>
#include <udata.h>
#include <math.h>
#include <mex.h>
#include <arInputFunctionsC.h>





 void fy_experimentaldata8_BBFCE271B4718DC74AC5C63B1AC8330B(double t, int nt, int it, int ntlink, int itlink, int ny, int nx, int nz, int iruns, double *y, double *p, double *u, double *x, double *z){
  y[ny*nt*iruns+it+nt*0] = 1.0;
  y[ny*nt*iruns+it+nt*1] = z[nz*ntlink*iruns+itlink+ntlink*0];
  y[ny*nt*iruns+it+nt*2] = z[nz*ntlink*iruns+itlink+ntlink*1];
  y[ny*nt*iruns+it+nt*3] = z[nz*ntlink*iruns+itlink+ntlink*2];

  return;
}


 void fystd_experimentaldata8_BBFCE271B4718DC74AC5C63B1AC8330B(double t, int nt, int it, int ntlink, int itlink, double *ystd, double *y, double *p, double *u, double *x, double *z){
  ystd[it+nt*0] = 1.0;
  ystd[it+nt*1] = p[17];
  ystd[it+nt*2] = p[16];
  ystd[it+nt*3] = p[18];

  return;
}


 void fsy_experimentaldata8_BBFCE271B4718DC74AC5C63B1AC8330B(double t, int nt, int it, int ntlink, int itlink, double *sy, double *p, double *u, double *x, double *z, double *su, double *sx, double *sz){
  sy[it+nt*1] = sz[itlink+ntlink*0];
  sy[it+nt*2] = sz[itlink+ntlink*1];
  sy[it+nt*3] = sz[itlink+ntlink*2];
  sy[it+nt*5] = sz[itlink+ntlink*3];
  sy[it+nt*6] = sz[itlink+ntlink*4];
  sy[it+nt*7] = sz[itlink+ntlink*5];
  sy[it+nt*9] = sz[itlink+ntlink*6];
  sy[it+nt*10] = sz[itlink+ntlink*7];
  sy[it+nt*11] = sz[itlink+ntlink*8];
  sy[it+nt*13] = sz[itlink+ntlink*9];
  sy[it+nt*14] = sz[itlink+ntlink*10];
  sy[it+nt*15] = sz[itlink+ntlink*11];
  sy[it+nt*17] = sz[itlink+ntlink*12];
  sy[it+nt*18] = sz[itlink+ntlink*13];
  sy[it+nt*19] = sz[itlink+ntlink*14];
  sy[it+nt*21] = sz[itlink+ntlink*15];
  sy[it+nt*22] = sz[itlink+ntlink*16];
  sy[it+nt*23] = sz[itlink+ntlink*17];
  sy[it+nt*25] = sz[itlink+ntlink*18];
  sy[it+nt*26] = sz[itlink+ntlink*19];
  sy[it+nt*27] = sz[itlink+ntlink*20];
  sy[it+nt*29] = sz[itlink+ntlink*21];
  sy[it+nt*30] = sz[itlink+ntlink*22];
  sy[it+nt*31] = sz[itlink+ntlink*23];
  sy[it+nt*33] = sz[itlink+ntlink*24];
  sy[it+nt*34] = sz[itlink+ntlink*25];
  sy[it+nt*35] = sz[itlink+ntlink*26];
  sy[it+nt*37] = sz[itlink+ntlink*27];
  sy[it+nt*38] = sz[itlink+ntlink*28];
  sy[it+nt*39] = sz[itlink+ntlink*29];
  sy[it+nt*41] = sz[itlink+ntlink*30];
  sy[it+nt*42] = sz[itlink+ntlink*31];
  sy[it+nt*43] = sz[itlink+ntlink*32];
  sy[it+nt*45] = sz[itlink+ntlink*33];
  sy[it+nt*46] = sz[itlink+ntlink*34];
  sy[it+nt*47] = sz[itlink+ntlink*35];
  sy[it+nt*49] = sz[itlink+ntlink*36];
  sy[it+nt*50] = sz[itlink+ntlink*37];
  sy[it+nt*51] = sz[itlink+ntlink*38];
  sy[it+nt*53] = sz[itlink+ntlink*39];
  sy[it+nt*54] = sz[itlink+ntlink*40];
  sy[it+nt*55] = sz[itlink+ntlink*41];
  sy[it+nt*57] = sz[itlink+ntlink*42];
  sy[it+nt*58] = sz[itlink+ntlink*43];
  sy[it+nt*59] = sz[itlink+ntlink*44];
  sy[it+nt*61] = sz[itlink+ntlink*45];
  sy[it+nt*62] = sz[itlink+ntlink*46];
  sy[it+nt*63] = sz[itlink+ntlink*47];

  return;
}


 void fsystd_experimentaldata8_BBFCE271B4718DC74AC5C63B1AC8330B(double t, int nt, int it, int ntlink, int itlink, double *systd, double *p, double *y, double *u, double *x, double *z, double *sy, double *su, double *sx, double *sz){
  systd[it+nt*66] = 1.0;
  systd[it+nt*69] = 1.0;
  systd[it+nt*75] = 1.0;

  return;
}


 void fy_scale_experimentaldata8_BBFCE271B4718DC74AC5C63B1AC8330B(double t, int nt, int it, int ntlink, int itlink, int ny, int nx, int nz, int iruns, double *y_scale, double *p, double *u, double *x, double *z, double *dfzdx){
  y_scale[ny*nt*iruns+it+nt*1] = dfzdx[nx*ntlink*iruns+itlink+ntlink*0];
  y_scale[ny*nt*iruns+it+nt*2] = dfzdx[nx*ntlink*iruns+itlink+ntlink*1];
  y_scale[ny*nt*iruns+it+nt*3] = dfzdx[nx*ntlink*iruns+itlink+ntlink*2];
  y_scale[ny*nt*iruns+it+nt*5] = dfzdx[nx*ntlink*iruns+itlink+ntlink*3];
  y_scale[ny*nt*iruns+it+nt*6] = dfzdx[nx*ntlink*iruns+itlink+ntlink*4];
  y_scale[ny*nt*iruns+it+nt*7] = dfzdx[nx*ntlink*iruns+itlink+ntlink*5];
  y_scale[ny*nt*iruns+it+nt*9] = dfzdx[nx*ntlink*iruns+itlink+ntlink*6];
  y_scale[ny*nt*iruns+it+nt*10] = dfzdx[nx*ntlink*iruns+itlink+ntlink*7];
  y_scale[ny*nt*iruns+it+nt*11] = dfzdx[nx*ntlink*iruns+itlink+ntlink*8];
  y_scale[ny*nt*iruns+it+nt*13] = dfzdx[nx*ntlink*iruns+itlink+ntlink*9];
  y_scale[ny*nt*iruns+it+nt*14] = dfzdx[nx*ntlink*iruns+itlink+ntlink*10];
  y_scale[ny*nt*iruns+it+nt*15] = dfzdx[nx*ntlink*iruns+itlink+ntlink*11];
  y_scale[ny*nt*iruns+it+nt*17] = dfzdx[nx*ntlink*iruns+itlink+ntlink*12];
  y_scale[ny*nt*iruns+it+nt*18] = dfzdx[nx*ntlink*iruns+itlink+ntlink*13];
  y_scale[ny*nt*iruns+it+nt*19] = dfzdx[nx*ntlink*iruns+itlink+ntlink*14];
  y_scale[ny*nt*iruns+it+nt*21] = dfzdx[nx*ntlink*iruns+itlink+ntlink*15];
  y_scale[ny*nt*iruns+it+nt*22] = dfzdx[nx*ntlink*iruns+itlink+ntlink*16];
  y_scale[ny*nt*iruns+it+nt*23] = dfzdx[nx*ntlink*iruns+itlink+ntlink*17];
  y_scale[ny*nt*iruns+it+nt*25] = dfzdx[nx*ntlink*iruns+itlink+ntlink*18];
  y_scale[ny*nt*iruns+it+nt*26] = dfzdx[nx*ntlink*iruns+itlink+ntlink*19];
  y_scale[ny*nt*iruns+it+nt*27] = dfzdx[nx*ntlink*iruns+itlink+ntlink*20];
  y_scale[ny*nt*iruns+it+nt*29] = dfzdx[nx*ntlink*iruns+itlink+ntlink*21];
  y_scale[ny*nt*iruns+it+nt*30] = dfzdx[nx*ntlink*iruns+itlink+ntlink*22];
  y_scale[ny*nt*iruns+it+nt*31] = dfzdx[nx*ntlink*iruns+itlink+ntlink*23];
  y_scale[ny*nt*iruns+it+nt*33] = dfzdx[nx*ntlink*iruns+itlink+ntlink*24];
  y_scale[ny*nt*iruns+it+nt*34] = dfzdx[nx*ntlink*iruns+itlink+ntlink*25];
  y_scale[ny*nt*iruns+it+nt*35] = dfzdx[nx*ntlink*iruns+itlink+ntlink*26];
  y_scale[ny*nt*iruns+it+nt*37] = dfzdx[nx*ntlink*iruns+itlink+ntlink*27];
  y_scale[ny*nt*iruns+it+nt*38] = dfzdx[nx*ntlink*iruns+itlink+ntlink*28];
  y_scale[ny*nt*iruns+it+nt*39] = dfzdx[nx*ntlink*iruns+itlink+ntlink*29];
  y_scale[ny*nt*iruns+it+nt*41] = dfzdx[nx*ntlink*iruns+itlink+ntlink*30];
  y_scale[ny*nt*iruns+it+nt*42] = dfzdx[nx*ntlink*iruns+itlink+ntlink*31];
  y_scale[ny*nt*iruns+it+nt*43] = dfzdx[nx*ntlink*iruns+itlink+ntlink*32];

  return;
}


