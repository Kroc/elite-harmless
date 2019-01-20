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

#include "../src/log.h"
#include "../src/exo_util.h"
#include "../src/6502emu.h"
#include "../src/areatrace.h"
#include "../src/int.h"
#include "../src/membuf_io.h"

#include <stdlib.h>

struct mem_ctx
{
    u8 *mem;
    struct areatrace at;
};

static void mem_access_write(struct mem_access *this, u16 address, u8 value)
{
    struct mem_ctx *ctx = this->ctx;
    ctx->mem[address] = value;
    areatrace_access(&ctx->at, address);
}

static u8 mem_access_read(struct mem_access *this, u16 address)
{
    struct mem_ctx *ctx = this->ctx;
    return ctx->mem[address];
}

void save_single(const char *in_name, struct membuf *mem, int start, int end)
{
    struct membuf mb_name;
    const char *out_name;

    membuf_init(&mb_name);

    membuf_printf(&mb_name, "%s.out", in_name);
    out_name = (const char *)membuf_get(&mb_name);

    membuf_truncate(mem, end);
    membuf_trim(mem, start);

    write_file(out_name, mem);

    membuf_free(&mb_name);
}

void test_single(const char *prg_name, const char *data_name,
                 int *cyclesp, int *in_lenp, int *out_lenp)
{
    struct cpu_ctx r;
    struct load_info prg_info;
    struct load_info data_info;
    struct membuf mem_mb;
    u8 *mem;
    struct mem_ctx mem_ctx;
    int start;
    int end;

    membuf_init(&mem_mb);
    membuf_atleast(&mem_mb, 65536);
    mem = membuf_get(&mem_mb);
    memset(mem, 0, 65536);
    mem_ctx.mem = mem;

    areatrace_init(&mem_ctx.at);

    prg_info.basic_txt_start = 0x0801;
    data_info.basic_txt_start = 0x0801;
    load_located(prg_name, mem, &prg_info);

    /* no start address from load*/
    if(prg_info.run == -1)
    {
        /* look for sys line */
        prg_info.run = find_sys(mem + prg_info.basic_txt_start, 0x9e, NULL);
    }
    if(prg_info.run == -1)
    {
        LOG(LOG_ERROR, ("Error, can't find entry point.\n"));
        exit(-1);
    }

    LOG(LOG_DEBUG, ("run %04x\n", prg_info.run));

    load_located(data_name, mem, &data_info);

    /* communicate the data region to the prg */
    mem[2] = data_info.start & 255;
    mem[3] = data_info.start >> 8;
    mem[4] = data_info.end & 255;
    mem[5] = data_info.end >> 8;

    r.cycles = 0;
    r.mem.ctx = &mem_ctx;
    r.mem.read = mem_access_read;
    r.mem.write = mem_access_write;
    r.pc = prg_info.run;
    r.sp = '\xff';
    r.flags = 0;

    /* setting up decrunch */
    while(r.sp >= 0x10)
    {
        next_inst(&r);
    }

    /* save traced area */
    areatrace_merge_overlapping(&mem_ctx.at);
    areatrace_get_largest(&mem_ctx.at, &start, &end);

    save_single(data_name, &mem_mb, start, end);

    areatrace_free(&mem_ctx.at);
    membuf_free(&mem_mb);

    if (cyclesp != NULL)
    {
        *cyclesp = r.cycles;
    }
    if (in_lenp != NULL)
    {
        *in_lenp = data_info.end - data_info.start;
    }
    if (out_lenp != NULL)
    {
        *out_lenp = end - start;
    }
}

int main(int argc, char *argv[])
{
    int i;
    int cycles;
    int inlen;
    int outlen;
    int cycles_sum = 0;
    int inlen_sum = 0;
    int outlen_sum = 0;
    const char *prg_name;

    /* init logging */
    LOG_INIT_CONSOLE(LOG_TERSE);

    prg_name = argv[1];

    LOG(LOG_TERSE, ("|File name                   "
                    "|Size    |Reduced |Cycles    |C/B out|C/B in |\n"));
    LOG(LOG_TERSE, ("|----------------------------"
                    "|--------|--------|----------|-------|-------|\n"));
    for (i = 2; i < argc; ++i)
    {
        test_single(prg_name, argv[i], &cycles, &inlen, &outlen);
        LOG(LOG_TERSE,
            ("|%-28s|%8d|%7.2f%%|%10d|%7.2f|%7.2f|\n",
             argv[i], inlen, 100.0 * (outlen - inlen) / outlen, cycles,
             (float)cycles / outlen, (float)cycles / inlen));
        cycles_sum += cycles;
        inlen_sum += inlen;
        outlen_sum += outlen;
    }

    if (argc > 3)
    {
        LOG(LOG_TERSE, ("|----------------------------"
                        "|--------|--------|----------|-------|-------|\n"));
        LOG(LOG_TERSE,
            ("|%-28s|%8d|%7.2f%%|%10d|%7.2f|%7.2f|\n",
             "Total", inlen_sum, 100.0 * (outlen_sum - inlen_sum) / outlen_sum,
             cycles_sum, (float)cycles_sum / outlen_sum,
             (float)cycles_sum / inlen_sum));
    }

    return 0;
}
