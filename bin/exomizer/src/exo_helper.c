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
#include "output.h"
#include "membuf.h"
#include "match.h"
#include "search.h"
#include "optimal.h"
#include "exodec.h"
#include "exo_helper.h"
#include "exo_util.h"
#include "getflag.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static struct crunch_options default_options[1] = { CRUNCH_OPTIONS_DEFAULT };

void do_output(match_ctx ctx,
               struct search_node *snp,
               encode_match_data emd,
               const struct crunch_options *options,
               struct membuf *outbuf,
               struct crunch_info *infop)
{
    int pos;
    int pos_diff;
    int max_diff;
    int diff;
    int traits_used = 0;
    int max_len = 0;
    output_ctxp old;
    output_ctx out;
    struct search_node *initial_snp;
    int initial_len;
    int alignment = 0;
    int measure_alignment;

    old = emd->out;
    emd->out = out;

    initial_len = membuf_memlen(outbuf);
    initial_snp = snp;
    measure_alignment = options->flags_proto & PFLAG_BITS_ALIGN_START;
    for (;;)
    {
        membuf_truncate(outbuf, initial_len);
        snp = initial_snp;
        output_ctx_init(out, options->flags_proto, outbuf);

        output_bits(out, alignment, 0);

        pos = output_get_pos(out);

        pos_diff = pos;
        max_diff = 0;

        LOG(LOG_DUMP, ("pos $%04X\n", out->pos));
        output_gamma_code(out, 16);
        output_bits(out, 1, 0); /* 1 bit out */

        diff = output_get_pos(out) - pos_diff;
        if(diff > max_diff)
        {
            max_diff = diff;
        }

        LOG(LOG_DUMP, ("pos $%04X\n", out->pos));
        LOG(LOG_DUMP, ("------------\n"));

        while (snp != NULL)
        {
            const_matchp mp;

            mp = snp->match;
            if (mp != NULL && mp->len > 0)
            {
                if (mp->offset == 0)
                {
                    int splitLitSeq =
                        snp->prev->match->len == 0 &&
                        (options->flags_proto & PFLAG_IMPL_1LITERAL);
                    int i = 0;
                    if (mp->len > 1)
                    {
                        int len = mp->len;
                        if (splitLitSeq)
                        {
                            --len;
                        }
                        for(; i < len; ++i)
                        {
                            output_byte(out, ctx->buf[snp->index + i]);
                        }
                        output_bits(out, 16, len);
                        output_gamma_code(out, 17);
                        output_bits(out, 1, 0);
                        /* literal sequence */
                        LOG(LOG_DUMP, ("[%d] literal copy len %d\n", out->pos,
                                       len));
                        traits_used |= TFLAG_LIT_SEQ;
                        if (len > max_len)
                        {
                            max_len = len;
                        }
                    }
                    if (i < mp->len)
                    {
                        /* literal */
                        LOG(LOG_DUMP, ("[%d] literal $%02X\n", out->pos,
                                       ctx->buf[snp->index + i]));
                        output_byte(out, ctx->buf[snp->index + i]);
                        if (!splitLitSeq)
                        {
                            output_bits(out, 1, 1);
                        }
                    }
                } else
                {
                    LOG(LOG_DUMP, ("[%d] sequence offset = %d, len = %d\n",
                                    out->pos, mp->offset, mp->len));
                    optimal_encode(mp, emd, NULL);
                    output_bits(out, 1, 0);
                    if (mp->len == 1)
                    {
                        traits_used |= TFLAG_LEN1_SEQ;
                    }
                    else
                    {
                        int lo = mp->len & 255;
                        int hi = mp->len & ~255;
                        if (hi > 0 && (lo == 1 || lo == 2 || lo == 3))
                        {
                            traits_used |= TFLAG_LEN0123_SEQ_MIRRORS;
                        }
                    }
                    if (mp->len > max_len)
                    {
                        max_len = mp->len;
                    }
                }

                pos_diff += mp->len;
                diff = output_get_pos(out) - pos_diff;
                if(diff > max_diff)
                {
                    max_diff = diff;
                }
            }
            LOG(LOG_DUMP, ("------------\n"));
            snp = snp->prev;
        }

        LOG(LOG_DUMP, ("pos $%04X\n", out->pos));
        if (options->output_header)
        {
            /* output header here */
            optimal_out(out, emd);
            LOG(LOG_DUMP, ("pos $%04X\n", out->pos));
        }

        if (!measure_alignment)
        {
            break;
        }
        alignment = output_bits_alignment(out);
        measure_alignment = 0;
    }
    output_bits_flush(out, !(options->flags_proto & PFLAG_BITS_ALIGN_START));

    emd->out = old;

    if(infop != NULL)
    {
        infop->traits_used = traits_used;
        infop->max_len = max_len;
        infop->needed_safety_offset = max_diff;
    }
}

struct search_node*
do_compress(match_ctx ctx, encode_match_data emd,
            const struct crunch_options *options,
            struct membuf *enc) /* IN */
{
    matchp_cache_enum mpce;
    matchp_snp_enum snpe;
    struct search_node *snp = NULL;
    int pass;
    float size;
    float old_size;
    char prev_enc[100];

    pass = 1;
    prev_enc[0] = '\0';

    LOG(LOG_NORMAL, (" pass %d: ", pass));
    if(options->exported_encoding != NULL)
    {
        LOG(LOG_NORMAL, ("importing %s\n", options->exported_encoding));
        optimal_encoding_import(emd, options->exported_encoding);
    }
    else
    {
        LOG(LOG_NORMAL, ("optimizing ..\n"));
        matchp_cache_get_enum(ctx, mpce);
        optimal_optimize(emd, matchp_cache_enum_get_next, mpce);
    }
    optimal_encoding_export(emd, enc);
    strcpy(prev_enc, membuf_get(enc));

    old_size = 100000000.0;

    for (;;)
    {
        if (snp != NULL)
        {
            free(snp);
        }
        snp = NULL;
        search_buffer(ctx, optimal_encode, emd,
                      options->flags_notrait,
                      options->max_len,
                      pass, &snp);
        if (snp == NULL)
        {
            LOG(LOG_ERROR, ("error: search_buffer() returned NULL\n"));
            exit(1);
        }

        size = snp->total_score;
        LOG(LOG_NORMAL, ("  size %0.1f bits ~%d bytes\n",
                         size, (((int) size) + 7) >> 3));

        if (size >= old_size)
        {
            break;
        }

        old_size = size;
        ++pass;

        if(pass > options->max_passes)
        {
            break;
        }

        optimal_free(emd);
        optimal_init(emd, options->flags_notrait, options->flags_proto);

        LOG(LOG_NORMAL, (" pass %d: optimizing ..\n", pass));

        matchp_snp_get_enum(snp, snpe);
        optimal_optimize(emd, matchp_snp_enum_get_next, snpe);

        optimal_encoding_export(emd, enc);
        if (strcmp(membuf_get(enc), prev_enc) == 0)
        {
            break;
        }
        strcpy(prev_enc, membuf_get(enc));
    }

    return snp;
}

void crunch_backwards(struct membuf *inbuf,
                      struct membuf *outbuf,
                      const struct crunch_options *options, /* IN */
                      struct crunch_info *infop) /* OUT */
{
    match_ctx ctx;
    encode_match_data emd;
    struct search_node *snp;
    struct crunch_info info;
    int outlen;
    int inlen;
    struct membuf exported_enc = STATIC_MEMBUF_INIT;

    if(options == NULL)
    {
        options = default_options;
    }

    inlen = membuf_memlen(inbuf);
    outlen = membuf_memlen(outbuf);
    emd->out = NULL;
    optimal_init(emd, options->flags_notrait, options->flags_proto);

    LOG(LOG_NORMAL,
        ("\nPhase 1: Instrumenting file"
         "\n-----------------------------\n"));
    LOG(LOG_NORMAL, (" Length of indata: %d bytes.\n", inlen));

    match_ctx_init(ctx, inbuf, options->max_len, options->max_offset,
                   options->favor_speed);

    LOG(LOG_NORMAL, (" Instrumenting file, done.\n"));

    emd->out = NULL;
    optimal_init(emd, options->flags_notrait, options->flags_proto);

    LOG(LOG_NORMAL,
        ("\nPhase 2: Calculating encoding"
         "\n-----------------------------\n"));
    snp = do_compress(ctx, emd, options, &exported_enc);
    LOG(LOG_NORMAL, (" Calculating encoding, done.\n"));

    LOG(LOG_NORMAL,
        ("\nPhase 3: Generating output file"
         "\n------------------------------\n"));
    LOG(LOG_NORMAL, (" Enc: %s\n", (char*)membuf_get(&exported_enc)));
    do_output(ctx, snp, emd, options, outbuf, &info);
    outlen = membuf_memlen(outbuf) - outlen;
    LOG(LOG_NORMAL, (" Length of crunched data: %d bytes.\n", outlen));

    LOG(LOG_BRIEF, (" Crunched data reduced %d bytes (%0.2f%%)\n",
                    inlen - outlen, 100.0 * (inlen - outlen) / inlen));

    optimal_free(emd);
    free(snp);
    match_ctx_free(ctx);
    membuf_free(&exported_enc);

    if(infop != NULL)
    {
        *infop = info;
    }
}

void reverse_buffer(char *start, int len)
{
    char *end = start + len - 1;
    char tmp;

    while (start < end)
    {
        tmp = *start;
        *start = *end;
        *end = tmp;

        ++start;
        --end;
    }
}

void crunch(struct membuf *inbuf,
            struct membuf *outbuf,
            const struct crunch_options *options, /* IN */
            struct crunch_info *info) /* OUT */
{
    int outpos;
    reverse_buffer(membuf_get(inbuf), membuf_memlen(inbuf));
    outpos = membuf_memlen(outbuf);

    crunch_backwards(inbuf, outbuf, options, info);

    reverse_buffer(membuf_get(inbuf), membuf_memlen(inbuf));
    reverse_buffer((char*)membuf_get(outbuf) + outpos,
                   membuf_memlen(outbuf) - outpos);
}

void decrunch(int level,
              struct membuf *inbuf,
              struct membuf *outbuf,
              struct decrunch_options *dopts)
{
    struct dec_ctx ctx[1];
    struct membuf enc_buf[1] = {STATIC_MEMBUF_INIT};
    int outpos;

    if (dopts->direction == 0)
    {
        reverse_buffer(membuf_get(inbuf), membuf_memlen(inbuf));
    }
    outpos = membuf_memlen(outbuf);

    dec_ctx_init(ctx, inbuf, outbuf, dopts->flags_proto, enc_buf);

    LOG(level, (" Encoding: %s\n", (char*)membuf_get(enc_buf)));

    membuf_free(enc_buf);
    dec_ctx_decrunch(ctx);
    dec_ctx_free(ctx);

    if (dopts->direction == 0)
    {
        reverse_buffer(membuf_get(inbuf), membuf_memlen(inbuf));
        reverse_buffer((char*)membuf_get(outbuf) + outpos,
                       membuf_memlen(outbuf) - outpos);
    }
}

void print_license(void)
{
    LOG(LOG_WARNING,
        ("----------------------------------------------------------------------------\n"
         "Exomizer v3.0.2 Copyright (c) 2002-2019 Magnus Lind. (magli143@gmail.com)\n"
         "----------------------------------------------------------------------------\n"));
    LOG(LOG_WARNING,
        ("This software is provided 'as-is', without any express or implied warranty.\n"
         "In no event will the authors be held liable for any damages arising from\n"
         "the use of this software.\n"
         "Permission is granted to anyone to use this software, alter it and re-\n"
         "distribute it freely for any non-commercial, non-profit purpose subject to\n"
         "the following restrictions:\n\n"));
    LOG(LOG_WARNING,
        ("   1. The origin of this software must not be misrepresented; you must not\n"
         "   claim that you wrote the original software. If you use this software in a\n"
         "   product, an acknowledgment in the product documentation would be\n"
         "   appreciated but is not required.\n"
         "   2. Altered source versions must be plainly marked as such, and must not\n"
         "   be misrepresented as being the original software.\n"
         "   3. This notice may not be removed or altered from any distribution.\n"));
    LOG(LOG_WARNING,
        ("   4. The names of this software and/or it's copyright holders may not be\n"
         "   used to endorse or promote products derived from this software without\n"
         "   specific prior written permission.\n"
         "----------------------------------------------------------------------------\n"
         "The files processed and/or generated by using this software are not covered\n"
         "nor affected by this license in any way.\n"));
}

void print_base_flags(enum log_level level, const char *default_outfile)
{
    LOG(level,
        ("  -o <outfile>  sets the outfile name, default is \"%s\"\n",
         default_outfile));
    LOG(level,
        ("  -q            quiet mode, disables all display output\n"
         "  -B            brief mode, disables most display output\n"
         "  -v            displays version and the usage license\n"
         "  --            treats all following arguments as non-options\n"
         "  -?            displays this help screen\n"));
}

void print_crunch_flags(enum log_level level, const char *default_outfile)
{
    LOG(level,
        ("  -c            compatibility mode, disables the use of literal sequences\n"
         "  -C            favor compression speed over ratio\n"
         "  -e <encoding> uses the given encoding for crunching\n"
         "  -E            don't write the encoding to the outfile\n"));
    LOG(level,
        ("  -m <offset>   sets the maximum sequence offset, default is 65535\n"
         "  -M <length>   sets the maximum sequence length, default is 65535\n"
         "  -p <passes>   limits the number of optimization passes, default is 65535\n"
         "  -T <options>  bitfield that controls bit stream traits. [0-7]\n"
         "  -P <options>  bitfield that controls bit stream format. [0-31]\n"));
    print_base_flags(level, default_outfile);
}

void handle_base_flags(int flag_char, /* IN */
                       const char *flag_arg, /* IN */
                       print_usage_f *print_usage, /* IN */
                       const char *appl, /* IN */
                       const char **default_outfilep) /* IN */
{
    switch(flag_char)
    {
    case 'o':
        *default_outfilep = flag_arg;
        break;
    case 'q':
        LOG_SET_LEVEL(LOG_WARNING);
        break;
    case 'B':
        LOG_SET_LEVEL(LOG_BRIEF);
        break;
    case 'v':
        print_license();
        exit(0);
    default:
        if (flagflag != '?')
        {
            LOG(LOG_ERROR,
                ("error, invalid option \"-%c\"", flagflag));
            if (flagarg != NULL)
            {
                LOG(LOG_ERROR, (" with argument \"%s\"", flagarg));
            }
            LOG(LOG_ERROR, ("\n"));
        }
        print_usage(appl, LOG_WARNING, *default_outfilep);
        exit(0);
    }
}

void handle_crunch_flags(int flag_char, /* IN */
                         const char *flag_arg, /* IN */
                         print_usage_f *print_usage, /* IN */
                         const char *appl, /* IN */
                         struct common_flags *flags) /* OUT */
{
    struct crunch_options *options = flags->options;
    switch(flag_char)
    {
    case 'c':
        options->flags_notrait |= TFLAG_LIT_SEQ;
        break;
    case 'C':
        options->favor_speed = 1;
        break;
    case 'e':
        options->exported_encoding = flag_arg;
        break;
    case 'E':
        options->output_header = 0;
        break;
    case 'm':
        if (str_to_int(flag_arg, &options->max_offset) != 0 ||
            options->max_offset < 0 || options->max_offset >= 65536)
        {
            LOG(LOG_ERROR,
                ("Error: invalid offset for -m option, "
                 "must be in the range of [0 - 65535]\n"));
            print_usage(appl, LOG_NORMAL, flags->outfile);
            exit(1);
        }
        break;
    case 'M':
        if (str_to_int(flag_arg, &options->max_len) != 0 ||
            options->max_len < 0 || options->max_len >= 65536)
        {
            LOG(LOG_ERROR,
                ("Error: invalid offset for -n option, "
                 "must be in the range of [0 - 65535]\n"));
            print_usage(appl, LOG_NORMAL, flags->outfile);
            exit(1);
        }
        break;
    case 'p':
        if (str_to_int(flag_arg, &options->max_passes) != 0 ||
            options->max_passes < 1 || options->max_passes >= 65536)
        {
            LOG(LOG_ERROR,
                ("Error: invalid value for -p option, "
                 "must be in the range of [1 - 65535]\n"));
            print_usage(appl, LOG_NORMAL, flags->outfile);
            exit(1);
        }
        break;
    case 'T':
        if (str_to_int(flag_arg, &options->flags_notrait) != 0 ||
            options->flags_notrait < 0 || options->flags_notrait > 7)
        {
            LOG(LOG_ERROR,
                ("Error: invalid value for -T option, "
                 "must be in the range of [0 - 7]\n"));
            print_usage(appl, LOG_NORMAL, flags->outfile);
            exit(1);
        }
        break;
    case 'P':
        {
            int op = 0;
            int flags_proto;
            if (*flag_arg == '+')
            {
                op = 1;
                ++flag_arg;
            }
            else if (*flag_arg == '-')
            {
                op = 2;
                ++flag_arg;
            }
            if (str_to_int(flag_arg, &flags_proto) != 0 ||
                options->flags_proto < 0 || options->flags_proto > 31)
            {
                LOG(LOG_ERROR,
                    ("Error: invalid value for -P option, "
                     "must be in the range of [0 - 31]\n"));
                print_usage(appl, LOG_NORMAL, flags->outfile);
                exit(1);
            }
            if (op == 1)
            {
                options->flags_proto |= flags_proto;
            }
            else if (op == 2)
            {
                options->flags_proto &= ~flags_proto;
            }
            else
            {
                options->flags_proto = flags_proto;
            }
        }
        break;
    default:
        handle_base_flags(flag_char, flag_arg, print_usage,
                          appl, &flags->outfile);
    }
}
