/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Header file for the Macro compiler
 *
 * Copyright 1999 Ryszard Glab
 * www - http://www.harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version, with one exception:
 *
 * The exception is that if you link the Harbour Runtime Library (HRL)
 * and/or the Harbour Virtual Machine (HVM) with other files to produce
 * an executable, this does not by itself cause the resulting executable
 * to be covered by the GNU General Public License. Your use of that
 * executable is in no way restricted on account of linking the HRL
 * and/or HVM code into it.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA (or visit
 * their web site at http://www.gnu.org/).
 *
 */

#ifndef HB_MACRO_H_
#define HB_MACRO_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <ctype.h>
#include <time.h>

/* Standard parameters passed to macro aware functions
 */
#define HB_MACRO_DECL   void * pMacro
#define HB_MACRO_PARAM  pMacro

#include "hbsetup.h"
#include "extend.h"
#include "ctoharb.h"
#include "pcode.h"      /* pcode values */
#include "itemapi.h"
#include "errorapi.h"
#include "expropt.h"

typedef struct HB_PCODE_INFO_
{
  BYTE * pCode;           /* pointer to a memory block where pcode is stored */
  ULONG  lPCodeSize;      /* total memory size for pcode */
  ULONG  lPCodePos;       /* actual pcode offset */
  struct HB_PCODE_INFO_ *pPrev;
  HB_CBVAR_PTR pLocals;
} HB_PCODE_INFO, * HB_PCODE_INFO_PTR;

typedef struct HB_MACRO_
{
  char * string;          /* compiled string */
  ULONG length;           /* length of the string */
  ULONG pos;              /* current position inside of compiled string */
  int   Flags;            /* some flags we may need */
  int status;             /* status of compilation */
  HB_PCODE_INFO_PTR pCodeInfo;  /* pointer to pcode buffer and info */
  void * pParseInfo;      /* data needed by the parser - it should be 'void *' to allow different implementation of macr compiler */
  BOOL bName10;           /* are we limiting identifier names to 10 chars ? */
  BOOL bShortCuts;        /* are we using logical shorcuts (in OR/AND)  */
  PHB_SYMB pSymbols;      /* local symbol table */
} HB_MACRO, * HB_MACRO_PTR;

#define HB_MACRO_OK           0   /* macro compiled successfully */
#define HB_MACRO_FAILURE      1   /* syntax error */
#define HB_MACRO_TOO_COMPLEX  2   /* compiled expression is too complex */


/* Global functions
 */
void hb_macroError( int, HB_MACRO_DECL );
int hb_compParse( HB_MACRO_PTR );

void hb_compGenPCode1( BYTE, HB_MACRO_DECL );
void hb_compGenPCode3( BYTE, BYTE, BYTE, HB_MACRO_DECL );
void hb_compGenPCodeN( BYTE * pBuffer, ULONG ulSize, HB_MACRO_DECL );

/* Size of pcode buffer incrementation
 */
#define HB_PCODE_SIZE  512

/* Bison requires (void *) pointer  - some code needs HB_MACRO_PTR pointer
 */
#define HB_MACRO_DATA     ( (HB_MACRO_PTR) HB_MACRO_PARAM )
#define HB_PCODE_DATA     ( HB_MACRO_DATA->pCodeInfo )

#endif
