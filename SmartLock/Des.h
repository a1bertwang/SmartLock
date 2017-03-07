//
//  Des.h
//  SmartLock
//
//  Created by A1bert on 2017/3/1.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#ifndef Des_h
#define Des_h

#include <stdio.h>

struct parm {
    unsigned char keya[8];
    unsigned char  ekey[16][48];
    unsigned char  dkey[16][48];
} ;
static unsigned char desargorithm(unsigned char *inparm, unsigned char *outparm,
                                  struct parm *pmp, unsigned char encrypt);
static void morioip(unsigned char *inarea);
static void moriof(unsigned char j);
static void morioe(void);
static void morios(void);
static void moriop(void);
static void morioiip(void);
static void AUOC050(unsigned char *getkey, struct parm *pmp);
static void moriomkey(unsigned char *key64, struct parm *pmp);
static void moriopc1(unsigned char *key64, unsigned char *l28, unsigned char *r28);
static void moriolshift(unsigned char *l28, unsigned char *r28, unsigned char j);
static void moriopc2(struct parm *pmp, unsigned char *l28, unsigned char *r28, unsigned char jj);
static void morioinparam(unsigned char *getkey, unsigned char *key64);

extern void des_encode(unsigned char des_key[8], unsigned char *in, unsigned char *out);

extern void des_decode(unsigned char des_key[8], unsigned char *in, unsigned char *out);

void des_encode_var(uint8_t *des_key,uint8_t *dest,uint8_t *dest_len,uint8_t *src,uint8_t src_len);

void des_uncode_var(uint8_t *des_key,uint8_t *dest,uint8_t *dest_len,uint8_t *src,uint8_t src_len);

#endif /* Des_h */
