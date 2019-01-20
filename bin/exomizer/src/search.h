#ifndef ALREADY_INCLUDED_SEARCH
#define ALREADY_INCLUDED_SEARCH

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

#include "match.h"
#include "output.h"

struct encode_int_bucket {
    unsigned short start;
    unsigned short end;
};

struct encode_match_buckets {
    struct encode_int_bucket len;
    struct encode_int_bucket offset;
};

struct search_node {
    int index;
    match match;
    unsigned int total_offset;
    float total_score;
    struct search_node *prev;
};

struct _encode_match_data {
    output_ctxp out;
    void *priv;
};

typedef struct _encode_match_data encode_match_data[1];
typedef struct _encode_match_data *encode_match_datap;

/* example of what may be used for priv data
 * field in the encode_match_data struct */
typedef
float encode_int_f(int val, void *priv, output_ctxp out,
                   struct encode_int_bucket *eibp);       /* IN */

struct _encode_match_priv {
    int flags_proto;
    int flags_notrait;
    int lit_num;
    int seq_num;
    int rle_num;
    float lit_bits;
    float seq_bits;
    float rle_bits;

    encode_int_f *offset_f;
    encode_int_f *len_f;
    void *offset_f_priv;
    void *len_f_priv;

    output_ctxp out;
};

typedef struct _encode_match_priv encode_match_priv[1];
typedef struct _encode_match_priv *encode_match_privp;
/* end of example */

typedef
float encode_match_f(const_matchp mp,
                     encode_match_data emd,     /* IN */
                     struct encode_match_buckets *embp);    /* OUT */

void search_node_dump(const struct search_node *snp);        /* IN */

/* Dont forget to free the (*result) after calling */
void search_buffer(match_ctx ctx,       /* IN */
                   encode_match_f * f,  /* IN */
                   encode_match_data emd,       /* IN */
                   int flags_notrait,           /* IN */
                   int max_sequence_length,     /* IN */
                   int pass,   /* IN */
                   struct search_node **result);       /* IN */

struct _matchp_snp_enum {
    const struct search_node *startp;
    const struct search_node *currp;
};

typedef struct _matchp_snp_enum matchp_snp_enum[1];
typedef struct _matchp_snp_enum *matchp_snp_enump;

void matchp_snp_get_enum(const struct search_node *snp,   /* IN */
                         matchp_snp_enum snpe); /* IN/OUT */

const_matchp matchp_snp_enum_get_next(void *matchp_snp_enum);

#endif
