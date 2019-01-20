#ifndef EXO_HELPER_ALREADY_INCLUDED
#define EXO_HELPER_ALREADY_INCLUDED

/*
 * Copyright (c) 2005, 2013, 2015 Magnus Lind.
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

#include "log.h"
#include "membuf.h"
#include "search.h"
#include "optimal.h"
#include "flags.h"

#define DECRUNCH_OPTIONS_DEFAULT {PFLAG_BITS_ORDER_BE | \
                                  PFLAG_BITS_COPY_GT_7 | \
                                  PFLAG_IMPL_1LITERAL, \
                                  1}

#define CRUNCH_OPTIONS_DEFAULT {NULL, 65535, 65535, 65535, 0, 1, \
                                PFLAG_BITS_ORDER_BE | \
                                PFLAG_BITS_COPY_GT_7 | \
                                PFLAG_IMPL_1LITERAL, \
                                0}

struct common_flags
{
    struct crunch_options *options;
    const char *outfile;
};

#define CRUNCH_FLAGS "cCe:Em:M:p:P:T:o:qBv"
#define BASE_FLAGS "o:qBv"

void print_crunch_flags(enum log_level level, const char *default_outfile);

void print_base_flags(enum log_level level, const char *default_outfile);

typedef void print_usage_f(const char *appl, enum log_level level,
                           const char *default_outfile);

void handle_crunch_flags(int flag_char, /* IN */
                         const char *flag_arg, /* IN */
                         print_usage_f *print_usage, /* IN */
                         const char *appl, /* IN */
                         struct common_flags *options); /* OUT */

void handle_base_flags(int flag_char, /* IN */
                       const char *flag_arg, /* IN */
                       print_usage_f *print_usage, /* IN */
                       const char *appl, /* IN */
                       const char **default_outfilep); /* OUT */

struct crunch_options
{
    const char *exported_encoding;
    int max_passes;
    int max_len;
    int max_offset;
    int favor_speed;
    int output_header;
    int flags_proto;
    int flags_notrait;
};

#define STATIC_CRUNCH_INFO_INIT {0, 0, 0}
struct crunch_info
{
    int traits_used;
    int max_len;
    int needed_safety_offset;
};

void print_license(void);

void crunch_backwards(struct membuf *inbuf,
                      struct membuf *outbuf,
                      const struct crunch_options *options, /* IN */
                      struct crunch_info *info); /* OUT */

void crunch(struct membuf *inbuf,
            struct membuf *outbuf,
            const struct crunch_options *options, /* IN */
            struct crunch_info *info); /* OUT */

struct decrunch_options
{
    /* see crunch_options flags field */
    int flags_proto;
    /* 0 backward, 1 forward */
    int direction;
};

void decrunch(int level,
              struct membuf *inbuf,
              struct membuf *outbuf,
              struct decrunch_options *dopts);

void reverse_buffer(char *start, int len);

#endif
