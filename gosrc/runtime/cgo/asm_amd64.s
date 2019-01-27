// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"

// 被 C 代码调用，由 cmd/cgo 生成。
// func crosscall2(fn func(a unsafe.Pointer, n int32, ctxt uintptr), a unsafe.Pointer, n int32, ctxt uintptr)
// 保存 C 被调用方保存的寄存器, 并使用三个参数调用 fn。
#ifndef GOOS_windows
TEXT crosscall2(SB),NOSPLIT,$0x50-0 /* keeps stack pointer 32-byte aligned */
#else
TEXT crosscall2(SB),NOSPLIT,$0x110-0 /* also need to save xmm6 - xmm15 */
#endif
	MOVQ	BX, 0x18(SP)
	MOVQ	R12, 0x28(SP)
	MOVQ	R13, 0x30(SP)
	MOVQ	R14, 0x38(SP)
	MOVQ	R15, 0x40(SP)

#ifdef GOOS_windows
	// Win64 save RBX, RBP, RDI, RSI, RSP, R12, R13, R14, R15 and XMM6 -- XMM15.
	MOVQ	DI, 0x48(SP)
	MOVQ	SI, 0x50(SP)
	MOVUPS	X6, 0x60(SP)
	MOVUPS	X7, 0x70(SP)
	MOVUPS	X8, 0x80(SP)
	MOVUPS	X9, 0x90(SP)
	MOVUPS	X10, 0xa0(SP)
	MOVUPS	X11, 0xb0(SP)
	MOVUPS	X12, 0xc0(SP)
	MOVUPS	X13, 0xd0(SP)
	MOVUPS	X14, 0xe0(SP)
	MOVUPS	X15, 0xf0(SP)

	MOVQ	DX, 0x0(SP)	/* arg */
	MOVQ	R8, 0x8(SP)	/* argsize (includes padding) */
	MOVQ	R9, 0x10(SP)	/* ctxt */

	CALL	CX	/* fn */

	MOVQ	0x48(SP), DI
	MOVQ	0x50(SP), SI
	MOVUPS	0x60(SP), X6
	MOVUPS	0x70(SP), X7
	MOVUPS	0x80(SP), X8
	MOVUPS	0x90(SP), X9
	MOVUPS	0xa0(SP), X10
	MOVUPS	0xb0(SP), X11
	MOVUPS	0xc0(SP), X12
	MOVUPS	0xd0(SP), X13
	MOVUPS	0xe0(SP), X14
	MOVUPS	0xf0(SP), X15
#else
	MOVQ	SI, 0x0(SP)	/* arg */
	MOVQ	DX, 0x8(SP)	/* argsize (includes padding) */
	MOVQ	CX, 0x10(SP)	/* ctxt */

	CALL	DI	/* fn */
#endif

	MOVQ	0x18(SP), BX
	MOVQ	0x28(SP), R12
	MOVQ	0x30(SP), R13
	MOVQ	0x38(SP), R14
	MOVQ	0x40(SP), R15

	RET
