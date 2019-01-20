#ifndef ALREADY_INCLUDED_OUTPUT
#define ALREADY_INCLUDED_OUTPUT

/*
 * Copyright (c) 2002 - 2005 Magnus Lind.
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software, alter it and re-
 * distribute it freely for any non-commercial, non-profit purpose subject to
 * the following restrictions:
 *
 *   1. The origin of this software must not be misrepresented; you must not
 *   claim that you wrote the original software. If you use this software in a
 *   product, an acknowledgment in the product documentation would be
 *   appreciated but is not required.
 *
 *   2. Altered source versions must be plainly marked as such, and must not
 *   be misrepresented as being the original software.
 *
 *   3. This notice may not be removed or altered from any distribution.
 *
 *   4. The names of this software and/or it's copyright holders may not be
 *   used to endorse or promote products derived from this software without
 *   specific prior written permission.
 *
 */

#include "membuf.h"
#include "flags.h"
#include <stdio.h>

struct _output_ctx {
    unsigned char bitbuf;
    unsigned char bitcount;
    int pos;
    int start;
    struct membuf *buf;
    int flags_proto;
};

typedef struct _output_ctx output_ctx[1];
typedef struct _output_ctx *output_ctxp;

void output_ctx_init(output_ctx ctx,    /* IN/OUT */
                     int flags_proto, /* IN */
                     struct membuf *out);       /* IN/OUT */

unsigned int output_get_pos(output_ctx ctx);    /* IN */

void output_byte(output_ctx ctx,        /* IN/OUT */
                 unsigned char byte);   /* IN */

void output_word(output_ctx ctx,        /* IN/OUT */
                 unsigned short int word);      /* IN */

void output_bits_flush(output_ctx ctx,  /* IN/OUT */
                       int add_marker_bit);     /* IN */

int output_bits_alignment(output_ctx ctx);      /* IN */

void output_bits(output_ctx ctx,        /* IN/OUT */
                 int count,     /* IN */
                 int val);      /* IN */

void output_gamma_code(output_ctx ctx,  /* IN/OUT */
                       int code);       /* IN */
#endif
