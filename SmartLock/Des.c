//
//  Des.c
//  SmartLock
//
//  Created by A1bert on 2017/3/1.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#include "Des.h"

#define TRUE 1
#define FALSE 0

//desº”√‹Ω‚√‹
struct parm  *parmp;
static const unsigned char tabip_t[64] = {
    58, 50, 42, 34, 26, 18, 10,  2,
    60, 52, 44, 36, 28, 20, 12,  4,
    62, 54, 46, 38, 30, 22, 14,  6,
    64, 56, 48, 40, 32, 24, 16,  8,
    57, 49, 41, 33, 25, 17,  9,  1,
    59, 51, 43, 35, 27, 19, 11,  3,
    61, 53, 45, 37, 29, 21, 13,  5,
    63, 55, 47, 39, 31, 23, 15,  7};

static const unsigned char tabllP_t[64] = {
    40,  8, 48, 16, 56, 24, 64, 32,
    39,  7, 47, 15, 55, 23, 63, 31,
    38,  6, 46, 14, 54, 22, 62, 30,
    37,  5, 45, 13, 53, 21, 61, 29,
    36,  4, 44, 12, 52, 20, 60, 28,
    35,  3, 43, 11, 51, 19, 59, 27,
    34,  2, 42, 10, 50, 18, 58, 26,
    33,  1, 41,  9, 49, 17, 57, 25};

static const unsigned char tabe_t[48] = {
    32,  1,  2,  3,  4,  5,
    4,  5,  6,  7,  8,  9,
    8,  9, 10, 11, 12, 13,
    12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32,  1};

static const unsigned char tabs_t[8][4][16] = {
    {{
        14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7},
        {0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8},
        {4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0},
        {15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13    }
    },
    {{
        15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10},
        {3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5},
        {0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15},
        {13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9    }
    },
    {{
        10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8},
        {13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1},
        {13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7},
        {1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12    }
    },
    {{
        7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15},
        {13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9},
        {10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4},
        {3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14    }
    },
    {{
        2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9},
        {14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6},
        {4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14},
        {11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3    }
    },
    {{
        12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11},
        {10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8},
        {9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6},
        {4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13    }
    },
    {{
        4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1},
        {13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6},
        {1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2},
        {6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12    }
    },
    {{
        13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7},
        {1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2},
        {7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8},
        {2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11    }
    }
};

static const unsigned char tabp_t[32] = {
    16,  7, 20, 21,
    29, 12, 28, 17,
    1, 15, 23, 26,
    5, 18, 31, 10,
    2,  8, 24, 14,
    32, 27,  3,  9,
    19, 13, 30,  6,
    22, 11,  4, 25};

/*static const int tabpc1_t[56] = {
 57, 49, 41, 33, 25, 17,  9,
 1, 58, 50, 42, 34, 26, 18,
 10,  2, 59, 51, 43, 35, 27,
 19, 11,  3, 60, 52, 44, 36,
 63, 55, 47, 39, 31, 23, 15,
 7, 62, 54, 46, 38, 30, 22,
 14,  6, 61, 53, 45, 37, 29,
 21, 13,  5, 28, 20, 12,  4};

 static const int tabnls_t[16]={
 1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1};

 static const int tabtabpc2_t[48] = {
 14, 17, 11, 24,  1,  5,
 3, 28, 15,  6, 21, 10,
 23, 19, 12,  4, 26,  8,
 16,  7, 27, 20, 13,  2,
 41, 52, 31, 37, 47, 55,
 30, 40, 51, 45, 33, 48,
 44, 49, 39, 56, 34, 53,
 46, 42, 50, 36, 29, 32};
 */

static  unsigned char l_[32],r_[32],frk_[32],e_[48],srk_[48],so_[8];

static const unsigned char tttpc1_t[56] = {
    57, 49, 41, 33, 25, 17,  9,
    1, 58, 50, 42, 34, 26, 18,
    10,  2, 59, 51, 43, 35, 27,
    19, 11,  3, 60, 52, 44, 36,
    63, 55, 47, 39, 31, 23, 15,
    7, 62, 54, 46, 38, 30, 22,
    14,  6, 61, 53, 45, 37, 29,
    21, 13,  5, 28, 20, 12,  4};

static const unsigned char tttnls_t[16]={
    1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1};

static const unsigned char ttttabpc2_t[48] = {
    14, 17, 11, 24,  1,  5,
    3, 28, 15,  6, 21, 10,
    23, 19, 12,  4, 26,  8,
    16,  7, 27, 20, 13,  2,
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32};

static unsigned char *outarea;

unsigned char desargorithm(unsigned char *inparm, unsigned char *outparm,
                           struct parm *pmp, unsigned char encrypt)
{

    //           int count=0;
    //           int count2=0;
    unsigned char w, j, k;

    parmp  = pmp;

    outarea = outparm;
    //    printf(outparm);
    //    printf("kankan");
    //    printf(outarea);
    morioip(inparm);
    for (j=0; j<16; j++) {
        if(encrypt) moriof(j);
        else moriof(15-j);
        for (k=0; k<32; k++) {
            w = l_[k];
            l_[k] = r_[k];
            r_[k] = w ^ frk_[k];
        }
    }
    morioiip();
    return 0;
}

void morioip(unsigned char *inarea)
{
    unsigned char j,k,dl,wk[64];

    for (j=0; j<8; j++) {
        dl = inarea[j];
        for (k=0; k<8; k++) {
            wk[8*j+k] = dl>>(7-k) & 1;
        }
    }
    for (j=0; j<64; j++) {
        dl = tabip_t[j]-1;
        if (j<32)
            l_[j] = wk[dl];
        else
            r_[j-32] = wk[dl];
    }
    return;
}
void moriof(unsigned char j)
{
    unsigned char k;

    morioe();
    for (k=0; k<48; k++) {
        srk_[k] = e_[k] ^ parmp->ekey[j][k];
    }

    morios();
    moriop();

    return;
}

void morioe()
{
    unsigned char k, el;
    for (k=0; k<48; k++) {
        el = tabe_t[k] - 1;
        e_[k] = r_[el];
    }
    return;
}

void morios()
{
    unsigned char j, k, l, x, y;
    for (j=0; j<8; j++) {
        k = j * 6;
        y = srk_[k] << 1 | srk_[k+5];
        x = 0;
        for (l=1; l<=4; l++) {
            x |= srk_[k+l]<<(4-l);
        }
        so_[j] = tabs_t[j][y][x];
    }

    return;
}

void moriop()
{
    unsigned char wk[32], j, k, pl;

    for (j=0; j<8; j++) {
        pl = so_[j];
        for (k=0; k<4; k++) {
            wk[4*j+k] = pl>>(3-k) & 1;
        }
    }

    for (j=0; j<32; j++) {
        pl = tabp_t[j] - 1;
        frk_[j] = wk[pl];
    }

    return;
}

void morioiip()
{
    unsigned char lr_[64], wk[64], j, k, dl;

    for (k=0; k<64; k++) {
        if (k<32)
            lr_[k] = r_[k];
        else
            lr_[k] = l_[k-32];
    }

    for (k=0; k<64; k++) {
        dl = tabllP_t[k]-1;
        wk[k] = lr_[dl];
    }

    for (j=0; j<8; j++) {
        outarea[j] = 0;
        for (k=0; k<8; k++) {
            outarea[j] |= wk[8*j+k] << (7-k);
        }
    }

    return;
}

void AUOC050(unsigned char *getkey, struct parm *pmp)
{
    unsigned char key64[64];
    //memcpy(pmp->keya,getkey,8);
    unsigned char i;
    for (i = 0 ; i < 8 ; i++) {
        pmp->keya[i] = getkey[i];
    }
    morioinparam(getkey, key64);
    moriomkey(key64, pmp);
    return;
}

void moriomkey(unsigned char *key64, struct parm *pmp)
{
    unsigned char j;
    unsigned char l28[30], r28[30];

    moriopc1(key64,l28, r28);
    for(j=0; j<16; j++) {
        moriolshift(l28, r28, j);
        moriopc2(pmp, l28, r28, j);
    }

    return;
}

void moriopc1(unsigned char *key64, unsigned char *l28, unsigned char *r28)
{
    unsigned char j, k;

    for(j=0; j<56; j++) {
        k = tttpc1_t[j] -1;
        if (j < 28) {
            l28[j] = (unsigned char)key64[k];
        }
        else {
            r28[j-28] = (unsigned char)key64[k];
        }
    }

    return;
}

void moriolshift(unsigned char *l28, unsigned char *r28, unsigned char j)
{
    unsigned char k, s;
    s = tttnls_t[j];
    l28[28] = l28[0];
    r28[28] = r28[0];
    l28[29] = l28[1];
    r28[29] = r28[1];

    for(k=0; k<28; k++) {
        l28[k] = l28[k+s];
        r28[k] = r28[k+s];
    }
    return;
}

void moriopc2(struct parm *pmp, unsigned char *l28, unsigned char *r28, unsigned char jj)
{
    unsigned char wk[56], k, p2;
    for(k=0; k<56; k++) {
        if (k < 28)
            wk[k] = l28[k];
        else
            wk[k] = r28[k-28];
    }
    for(k=0; k<48; k++) {
        p2 = ttttabpc2_t[k] - 1;
        pmp->ekey[jj][k] = wk[p2];
    }
    return;
}

void morioinparam(unsigned char *getkey, unsigned char *key64)
{
    unsigned char i, k, k1;
    for (i=0; i<8; i++) {
        k1 = getkey[i];
        for (k=0; k<8; k++) {
            key64[8*i+k] = k1 >>(7-k) & 1;
        }
    }
    return;
}

/*****************************************************************************
 * Name : des_encode
 * Descripe:
 *   ?in??DES????,???????
 * Paramater:
 *   [in]des_key    : ?????
 *   [in]in            : ??????
 *   [out]out        : ??????
 * Return value:?
 *****************************************************************************/
void des_encode(unsigned char des_key[8], unsigned char *in, unsigned char *out)//desº”√‹
{
    struct parm key_area;
    AUOC050(des_key, &key_area);
    desargorithm(in, out, &key_area, TRUE);
    return;
}

/*****************************************************************************
 * Name : des_decode
 * Descripe:
 *   ?in??DES????,???????
 * Paramater:
 *   [in]des_key    : ?????
 *   [in]in            : ??????
 *   [out]out        : ??????
 * Return value:?
 *****************************************************************************/
void des_decode(unsigned char des_key[8], unsigned char *in, unsigned char *out)//desΩ‚√‹
{
    struct parm key_area;
    AUOC050(des_key, &key_area);
    desargorithm(in, out, &key_area, FALSE);
    return;
}




void des_encode_var(uint8_t *des_key,uint8_t *dest,uint8_t *dest_len,uint8_t *src,uint8_t src_len)
{
    //  printf("1212121");
    uint8_t i;
    uint8_t len=0;
    if((src_len%8)!=0)
    {
        len=(src_len/8+1)*8;
        for(i=(src_len+src_len%8);i<len;i++)
        {
            src[i]=0;
        }
    }
    else
    {
        len=src_len;
    }
    for(i=0;i<len/8;i++)
    {
        des_encode(des_key,src+i*8,dest+i*8);
    }
    *dest_len=len;
}
void des_uncode_var(uint8_t *des_key,uint8_t *dest,uint8_t *dest_len,uint8_t *src,uint8_t src_len)
{
    uint8_t i;
    for(i=0;i<src_len/8;i++)
    {
        des_decode(des_key, src+i*8, dest+i*8);
    }
    *dest_len=src_len;
}
