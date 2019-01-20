/*
 * Copyright (c) 2002 - 2018 Magnus Lind.
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

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "log.h"
#include "search.h"
#include "membuf.h"
#include "progress.h"

void search_buffer(match_ctx ctx,       /* IN */
                   encode_match_f * f,  /* IN */
                   encode_match_data emd,       /* IN */
                   int flags_notrait,           /* IN */
                   int max_sequence_length,     /* IN */
                   int pass,   /* IN */
                   struct search_node **result)/* OUT */
{
    struct progress prog[1];
    struct search_node *sn_arr;
    const_matchp mp = NULL;
    struct search_node *snp;
    struct search_node *best_copy_snp;
    int best_copy_len;

    struct search_node *best_rle_snp;

    int use_literal_sequences = !(flags_notrait & TFLAG_LIT_SEQ);
    int skip_len0123_mirrors = flags_notrait & TFLAG_LEN0123_SEQ_MIRRORS;
    int len = ctx->len + 1;

    progress_init(prog, "finding.shortest.path.",len, 0);

    sn_arr = malloc(len * sizeof(struct search_node));
    memset(sn_arr, 0, len * sizeof(struct search_node));

    --len;
    snp = &sn_arr[len];
    snp->index = len;
    snp->match->offset = 0;
    snp->match->len = 0;
    snp->total_offset = 0;
    snp->total_score = 0;
    snp->prev = NULL;

    best_copy_snp = snp;
    best_copy_len = 0;

    best_rle_snp = NULL;

    /* think twice about changing this code,
     * it works the way it is. The last time
     * I examined this code I was certain it was
     * broken and broke it myself, trying to fix it. */
    while (len > 0 && (mp = matches_get(ctx, len - 1)) != NULL)
    {
        float prev_score;
        float prev_offset_sum;

        if (use_literal_sequences)
        {
            /* check if we can do even better with copy */
            snp = &sn_arr[len];
            if(best_copy_snp->total_score+best_copy_len * 8.0 -
               snp->total_score > 0.0 ||
               best_copy_len > max_sequence_length)
            {
                /* found a better copy endpoint */
                LOG(LOG_DEBUG,
                    ("best copy start moved to index %d\n", snp->index));
                best_copy_snp = snp;
                best_copy_len = 0;
            } else
            {
                float copy_score = best_copy_len * 8.0 + (1.0 + 17.0 + 17.0);
                float total_copy_score = best_copy_snp->total_score +
                                         copy_score;

                LOG(LOG_DEBUG,
                    ("total score %0.1f, copy total score %0.1f\n",
                     snp->total_score, total_copy_score));

                if (snp->total_score > total_copy_score &&
                    best_copy_len <= max_sequence_length &&
                    !(skip_len0123_mirrors &&
                      /* must be < 2 due to PBIT_IMPL_1LITERAL adjustment */
                      best_copy_len > 255 && (best_copy_len & 255) < 2))
                {
                    match local_mp;
                    /* here it is good to just copy instead of crunch */

                    LOG(LOG_DEBUG,
                        ("copy index %d, len %d, total %0.1f, copy %0.1f\n",
                         snp->index, best_copy_len,
                         snp->total_score, total_copy_score));

                    local_mp->len = best_copy_len;
                    local_mp->offset = 0;
                    local_mp->next = NULL;
                    snp->total_score = total_copy_score;
                    snp->total_offset = best_copy_snp->total_offset;
                    snp->prev = best_copy_snp;
                    *snp->match = *local_mp;
                }
            }
            /* end of copy optimization */
        }

        /* check if we can do rle */
        snp = &sn_arr[len];
        if(best_rle_snp == NULL ||
           snp->index + 65535 < best_rle_snp->index ||
           snp->index + ctx->rle_r[snp->index] < best_rle_snp->index)
        {
            /* best_rle_snp can't be reached by rle from snp, reset it*/
            if(ctx->rle[snp->index] > 0)
            {
                best_rle_snp = snp;
                LOG(LOG_DEBUG, ("resetting best_rle at index %d, len %d\n",
                                 snp->index, ctx->rle[snp->index]));
            }
            else
            {
                best_rle_snp = NULL;
            }
        }
        else if(ctx->rle[snp->index] > 0 &&
                snp->index + ctx->rle_r[snp->index] >= best_rle_snp->index)
        {
            float best_rle_score;
            float total_best_rle_score;
            float snp_rle_score;
            float total_snp_rle_score;
            match rle_mp;

            LOG(LOG_DEBUG, ("challenger len %d, index %d, "
                             "ruling len %d, index %d\n",
                             ctx->rle_r[snp->index], snp->index,
                             ctx->rle_r[best_rle_snp->index],
                             best_rle_snp->index));

            /* snp and best_rle_snp is the same rle area,
             * let's see which is best */
            rle_mp->len = ctx->rle[best_rle_snp->index];
            rle_mp->offset = 1;
            best_rle_score = f(rle_mp, emd, NULL);
            total_best_rle_score = best_rle_snp->total_score +
                best_rle_score;

            rle_mp->len = ctx->rle[snp->index];
            rle_mp->offset = 1;
            snp_rle_score = f(rle_mp, emd, NULL);
            total_snp_rle_score = snp->total_score + snp_rle_score;

            if(total_snp_rle_score <= total_best_rle_score)
            {
                /* yes, the snp is a better rle than best_rle_snp */
                LOG(LOG_DEBUG, ("prospect len %d, index %d, (%0.1f+%0.1f) "
                                 "ruling len %d, index %d (%0.1f+%0.1f)\n",
                                 ctx->rle[snp->index], snp->index,
                                 snp->total_score, snp_rle_score,
                                 ctx->rle[best_rle_snp->index],
                                 best_rle_snp->index,
                                 best_rle_snp->total_score, best_rle_score));
                best_rle_snp = snp;
                LOG(LOG_DEBUG, ("setting current best_rle: "
                                 "index %d, len %d\n",
                                 snp->index, rle_mp->len));
            }
        }
        if(best_rle_snp != NULL && best_rle_snp != snp)
        {
            float rle_score;
            float total_rle_score;
            /* check if rle is better */
            match local_mp;
            local_mp->len = best_rle_snp->index - snp->index;
            local_mp->offset = 1;

            rle_score = f(local_mp, emd, NULL);
            total_rle_score = best_rle_snp->total_score + rle_score;

            LOG(LOG_DEBUG, ("comparing index %d (%0.1f) with "
                             "rle index %d, len %d, total score %0.1f %0.1f\n",
                             snp->index, snp->total_score,
                             best_rle_snp->index, local_mp->len,
                             best_rle_snp->total_score, rle_score));

            if(snp->total_score > total_rle_score)
            {
                /*here it is good to do rle instead of crunch */
                LOG(LOG_DEBUG,
                    ("rle index %d, len %d, total %0.1f, rle %0.1f\n",
                     snp->index, local_mp->len,
                     snp->total_score, total_rle_score));

                snp->total_score = total_rle_score;
                snp->total_offset = best_rle_snp->total_offset + 1;
                snp->prev = best_rle_snp;

                *snp->match = *local_mp;
            }
        }
        /* end of rle optimization */

        LOG(LOG_DUMP,
            ("matches for index %d with total score %0.1f\n",
             len - 1, snp->total_score));

        prev_score = sn_arr[len].total_score;
        prev_offset_sum = sn_arr[len].total_offset;
        while (mp != NULL)
        {
            matchp next;
            int end_len;
            match tmp;
            int bucket_len_start;
            float score;

            next = mp->next;
            end_len = 1;
            *tmp = *mp;
            tmp->next = NULL;
            bucket_len_start = 0;
            for(tmp->len = mp->len; tmp->len >= end_len; --(tmp->len))
            {
                float total_score;
                unsigned int total_offset;
                struct encode_match_buckets match_buckets = {{0, 0}, {0, 0}};

                LOG(LOG_DUMP, ("mp[%d, %d], tmp[%d, %d]\n",
                               mp->offset, mp->len,
                               tmp->offset, tmp->len));
                if (bucket_len_start == 0 ||
                    tmp->len < 4 ||
                    tmp->len < bucket_len_start ||
                    (skip_len0123_mirrors && tmp->len > 255 &&
                     (tmp->len & 255) < 4))
                {
                    score = f(tmp, emd, &match_buckets);
                    bucket_len_start = match_buckets.len.start;
                }

                total_score = prev_score + score;
                total_offset = prev_offset_sum + tmp->offset;
                snp = &sn_arr[len - tmp->len];

                LOG(LOG_DUMP,
                    ("[%05d] cmp [%05d, %05d score %.1f + %.1f] with %.1f",
                     len, tmp->offset, tmp->len,
                     prev_score, score, snp->total_score));

                if (total_score < 100000000.0 &&
                    (snp->match->len == 0 ||
                     total_score < snp->total_score ||
                     (total_score == snp->total_score &&
                      total_offset < snp->total_offset &&
                      ((pass & 1) == 0 ||
                       (snp->match->len == 1 && snp->match->offset > 8) ||
                       tmp->offset > 48 ||
                       tmp->len > 15))))
                {
                    LOG(LOG_DUMP, (", replaced"));
                    snp->index = len - tmp->len;

                    *snp->match = *tmp;
                    snp->total_offset = total_offset;
                    snp->total_score = total_score;
                    snp->prev = &sn_arr[len];
                }
                LOG(LOG_DUMP, ("\n"));
            }
            LOG(LOG_DUMP, ("tmp->len %d, ctx->rle[%d] %d\n",
                           tmp->len, len - tmp->len,
                           ctx->rle[len - tmp->len]));

            mp = next;
        }

        /* slow way to get to the next node for cur */
        --len;
        ++best_copy_len;

        progress_bump(prog, len);
    }
    if(len > 0 && mp == NULL)
    {
        LOG(LOG_ERROR, ("No matches at len %d.\n", len));
    }
    LOG(LOG_NORMAL, ("\n"));

    progress_free(prog);

    *result = sn_arr;
}

void matchp_snp_get_enum(const struct search_node *snp, /* IN */
                         matchp_snp_enum snpe)  /* IN/OUT */
{
    snpe->startp = snp;
    snpe->currp = snp;
}

const_matchp matchp_snp_enum_get_next(void *matchp_snp_enum)
{
    matchp_snp_enump snpe;
    const_matchp val;

    snpe = matchp_snp_enum;

    val = NULL;
    while (snpe->currp != NULL && val == NULL)
    {
        val = snpe->currp->match;
        snpe->currp = snpe->currp->prev;
    }

    if (snpe->currp == NULL)
    {
        snpe->currp = snpe->startp;
    }
    return val;
}
