/*-
 * SPDX-License-Identifier: BSD-2-Clause-FreeBSD
 *
 * Copyright (c) 2020 Oleksandr Tymoshenko <gonzo@FreeBSD.org>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * 
 * $FreeBSD$
 */

#ifndef	__IMX8MQ_CCM_H__
#define	__IMX8MQ_CCM_H__

#define	IMX8MQ_CLK_DUMMY	0
#define	IMX8MQ_CLK_32K		1
#define	IMX8MQ_CLK_25M		2
#define	IMX8MQ_CLK_27M		3
#define	IMX8MQ_CLK_EXT1		4
#define	IMX8MQ_CLK_EXT2		5
#define	IMX8MQ_CLK_EXT3		6
#define	IMX8MQ_CLK_EXT4		7

#define	IMX8MQ_ARM_PLL_REF_SEL	8
#define	IMX8MQ_ARM_PLL_REF_DIV	9
#define	IMX8MQ_ARM_PLL		10
#define	IMX8MQ_ARM_PLL_BYPASS	11
#define	IMX8MQ_ARM_PLL_OUT	12

#define	IMX8MQ_GPU_PLL_REF_SEL	13
#define	IMX8MQ_GPU_PLL_REF_DIV	14
#define	IMX8MQ_GPU_PLL		15
#define	IMX8MQ_GPU_PLL_BYPASS	16
#define	IMX8MQ_GPU_PLL_OUT	17

#define	IMX8MQ_VPU_PLL_REF_SEL	18
#define	IMX8MQ_VPU_PLL_REF_DIV	19
#define	IMX8MQ_VPU_PLL		20
#define	IMX8MQ_VPU_PLL_BYPASS	21
#define	IMX8MQ_VPU_PLL_OUT	22

#define	IMX8MQ_AUDIO_PLL1_REF_SEL	23
#define	IMX8MQ_AUDIO_PLL1_REF_DIV	24
#define	IMX8MQ_AUDIO_PLL1		25
#define	IMX8MQ_AUDIO_PLL1_BYPASS	26
#define	IMX8MQ_AUDIO_PLL1_OUT		27

#define	IMX8MQ_AUDIO_PLL2_REF_SEL	28
#define	IMX8MQ_AUDIO_PLL2_REF_DIV	29
#define	IMX8MQ_AUDIO_PLL2		30
#define	IMX8MQ_AUDIO_PLL2_BYPASS	31
#define	IMX8MQ_AUDIO_PLL2_OUT		32

#define	IMX8MQ_VIDEO_PLL1_REF_SEL	33
#define	IMX8MQ_VIDEO_PLL1_REF_DIV	34
#define	IMX8MQ_VIDEO_PLL1		35
#define	IMX8MQ_VIDEO_PLL1_BYPASS	36
#define	IMX8MQ_VIDEO_PLL1_OUT		37

#define	IMX8MQ_SYS3_PLL1_REF_SEL	54
#define	IMX8MQ_SYS3_PLL1		56

#define	IMX8MQ_DRAM_PLL1_REF_SEL	62

#define	IMX8MQ_SYS1_PLL_40M	70
#define	IMX8MQ_SYS1_PLL_80M	71
#define	IMX8MQ_SYS1_PLL_100M	72
#define	IMX8MQ_SYS1_PLL_133M	73
#define	IMX8MQ_SYS1_PLL_160M	74
#define	IMX8MQ_SYS1_PLL_200M	75
#define	IMX8MQ_SYS1_PLL_266M	76
#define	IMX8MQ_SYS1_PLL_400M	77
#define	IMX8MQ_SYS1_PLL_800M	78

#define	IMX8MQ_SYS2_PLL_50M	79
#define	IMX8MQ_SYS2_PLL_100M	80
#define	IMX8MQ_SYS2_PLL_125M	81
#define	IMX8MQ_SYS2_PLL_166M	82
#define	IMX8MQ_SYS2_PLL_200M	83
#define	IMX8MQ_SYS2_PLL_250M	84
#define	IMX8MQ_SYS2_PLL_333M	85
#define	IMX8MQ_SYS2_PLL_500M	86
#define	IMX8MQ_SYS2_PLL_1000M	87

#define	IMX8MQ_CLK_ENET_AXI	104
#define	IMX8MQ_CLK_USB_BUS	110

#define	IMX8MQ_CLK_AHB		116

#define	IMX8MQ_CLK_ENET_REF	137
#define	IMX8MQ_CLK_ENET_TIMER	138
#define	IMX8MQ_CLK_ENET_PHY_REF	139
#define	IMX8MQ_CLK_USDHC1	142
#define	IMX8MQ_CLK_USDHC2	143
#define	IMX8MQ_CLK_I2C1		144
#define	IMX8MQ_CLK_I2C2		145
#define	IMX8MQ_CLK_I2C3		146
#define	IMX8MQ_CLK_I2C4		147
#define	IMX8MQ_CLK_UART1	148
#define	IMX8MQ_CLK_UART2	149
#define	IMX8MQ_CLK_UART3	150
#define	IMX8MQ_CLK_UART4	151
#define	IMX8MQ_CLK_USB_CORE_REF	152
#define	IMX8MQ_CLK_USB_PHY_REF	153

#define	IMX8MQ_CLK_ENET1_ROOT		182
#define	IMX8MQ_CLK_I2C1_ROOT		184
#define	IMX8MQ_CLK_I2C2_ROOT		185
#define	IMX8MQ_CLK_I2C3_ROOT		186
#define	IMX8MQ_CLK_I2C4_ROOT		187
#define	IMX8MQ_CLK_UART1_ROOT		202
#define	IMX8MQ_CLK_UART2_ROOT		203
#define	IMX8MQ_CLK_UART3_ROOT		204
#define	IMX8MQ_CLK_UART4_ROOT		205
#define	IMX8MQ_CLK_USB1_CTRL_ROOT	206
#define	IMX8MQ_CLK_USB2_CTRL_ROOT	207
#define	IMX8MQ_CLK_USB1_PHY_ROOT	208
#define	IMX8MQ_CLK_USB2_PHY_ROOT	209
#define	IMX8MQ_CLK_USDHC1_ROOT		210
#define	IMX8MQ_CLK_USDHC2_ROOT		211

#define	IMX8MQ_SYS1_PLL_OUT		231
#define	IMX8MQ_SYS2_PLL_OUT		232
#define	IMX8MQ_SYS3_PLL_OUT		233

#define	IMX8MQ_CLK_IPG_ROOT		236

#define	IMX8MQ_CLK_TMU_ROOT		246

#define	IMX8MQ_CLK_GPIO1_ROOT		259
#define	IMX8MQ_CLK_GPIO2_ROOT		260
#define	IMX8MQ_CLK_GPIO3_ROOT		261
#define	IMX8MQ_CLK_GPIO4_ROOT		262
#define	IMX8MQ_CLK_GPIO5_ROOT		263

#define	IMX8MQ_VIDEO2_PLL1_REF_SEL	266

#define	IMX8MQ_SYS1_PLL_40M_CG		267
#define	IMX8MQ_SYS1_PLL_80M_CG		268
#define	IMX8MQ_SYS1_PLL_100M_CG		269
#define	IMX8MQ_SYS1_PLL_133M_CG		270
#define	IMX8MQ_SYS1_PLL_160M_CG		271
#define	IMX8MQ_SYS1_PLL_200M_CG		272
#define	IMX8MQ_SYS1_PLL_266M_CG		273
#define	IMX8MQ_SYS1_PLL_400M_CG		274
#define	IMX8MQ_SYS1_PLL_800M_CG		275
#define	IMX8MQ_SYS2_PLL_50M_CG		276
#define	IMX8MQ_SYS2_PLL_100M_CG		277
#define	IMX8MQ_SYS2_PLL_125M_CG		278
#define	IMX8MQ_SYS2_PLL_166M_CG		279
#define	IMX8MQ_SYS2_PLL_200M_CG		280
#define	IMX8MQ_SYS2_PLL_250M_CG		281
#define	IMX8MQ_SYS2_PLL_333M_CG		282
#define	IMX8MQ_SYS2_PLL_500M_CG		283
#define	IMX8MQ_SYS2_PLL_1000M_CG	284

#endif