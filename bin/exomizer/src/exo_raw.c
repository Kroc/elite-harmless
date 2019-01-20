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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include "log.h"
#include "getflag.h"
#include "membuf.h"
#include "membuf_io.h"
#include "exo_helper.h"
#include "exo_util.h"

static
void print_usage(const char *appl, enum log_level level,
                 const char *default_out_name)
{
    LOG(level, ("usage: %s [option]... infile\n", appl));
    LOG(level,
        ("  -b            crunch/decrunch backwards\n"
         "  -r            write outfile in reverse order\n"
         "  -d            decrunch (instead of crunch)\n"));
    print_crunch_flags(level, default_out_name);
}

#define DEFAULT_OUTFILE "a.out"

int
main(int argc, char *argv[])
{
    char flags_arr[64];
    int decrunch_mode = 0;
    int backwards_mode = 0;
    int reverse_mode = 0;
    int c, infilec;
    char **infilev;

    struct crunch_options options[1] = { CRUNCH_OPTIONS_DEFAULT };
    struct common_flags flags[1] = { {NULL, DEFAULT_OUTFILE} };

    struct membuf inbuf[1];
    struct membuf outbuf[1];

    const char *appl = fixup_appl(argv[0]);

    flags->options = options;

    /* init logging */
    LOG_INIT_CONSOLE(LOG_NORMAL);

    LOG(LOG_DUMP, ("flagind %d\n", flagind));
    sprintf(flags_arr, "bdr%s", CRUNCH_FLAGS);
    while ((c = getflag(argc, argv, flags_arr)) != -1)
    {
        LOG(LOG_DUMP, (" flagind %d flagopt '%c'\n", flagind, c));
        switch (c)
        {
        case 'b':
            backwards_mode = 1;
            break;
        case 'r':
            reverse_mode = 1;
            break;
        case 'd':
            decrunch_mode = 1;
            break;
        default:
            handle_crunch_flags(c, flagarg, print_usage, appl, flags);
        }
    }

    infilev = argv + flagind;
    infilec = argc - flagind;

    if (infilec != 1)
    {
        LOG(LOG_ERROR, ("Error: exactly one input file must be given.\n"));
        print_usage(appl, LOG_NORMAL, DEFAULT_OUTFILE);
        exit(1);
    }

    membuf_init(inbuf);
    membuf_init(outbuf);

    read_file(infilev[0], inbuf);

    if(decrunch_mode)
    {
        struct decrunch_options dopts;
        dopts.direction = !backwards_mode;
        dopts.flags_proto = options->flags_proto;

        if (dopts.direction == 0)
        {
            LOG(LOG_NORMAL, ("Decrunching infile \"%s\" to outfile \"%s\" "
                             " backwards.\n", infilev[0], flags->outfile));
        }
        else
        {
            LOG(LOG_NORMAL, ("Decrunching infile \"%s\" to outfile \"%s\".\n",
                             infilev[0], flags->outfile));
        }

        decrunch(LOG_NORMAL, inbuf, outbuf, &dopts);
    }
    else
    {
        struct crunch_info info = STATIC_CRUNCH_INFO_INIT;
        if(backwards_mode)
        {
            LOG(LOG_NORMAL, ("Crunching infile \"%s\" to outfile \"%s\" "
                             "backwards.\n", infilev[0], flags->outfile));
            crunch_backwards(inbuf, outbuf, options, &info);
        }
        else
        {
            LOG(LOG_NORMAL, ("Crunching infile \"%s\" to outfile \"%s\".\n",
                             infilev[0], flags->outfile));
            crunch(inbuf, outbuf, options, &info);
        }

        LOG(LOG_NORMAL, (" Literal sequences are %sused",
                         info.traits_used & TFLAG_LIT_SEQ ? "" : "not "));
        LOG(LOG_NORMAL, (", length 1 sequences are %sused",
                         info.traits_used & TFLAG_LEN1_SEQ ? "" : "not "));
        LOG(LOG_NORMAL, (", length 0123 mirrors are %sused",
                         info.traits_used & TFLAG_LEN0123_SEQ_MIRRORS ?
                         "" : "not "));
        LOG(LOG_NORMAL, (" and the safety offset is %d.\n",
                         info.needed_safety_offset));
    }

    if(reverse_mode)
    {
        reverse_buffer(membuf_get(outbuf), membuf_memlen(outbuf));
    }

    write_file(flags->outfile, outbuf);

    membuf_free(outbuf);
    membuf_free(inbuf);

    LOG_FREE;

    return 0;
}
