/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Runtime library regression tests
 *
 * Copyright 1999 Victor Szel <info@szelvesz.hu>
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

/* TRANSFORM() tests mostly written by Eddie Runia <eddie@runia.com> */
/* EMPTY() tests written by Eddie Runia <eddie@runia.com> */
/* :class* tests written by Dave Pearson <davep@hagbard.demon.co.uk> */

/* NOTE: Always compile with /n switch */
/* NOTE: It's worth to make tests with and without the /z switch */
/* NOTE: Guard all Harbour extensions with __HARBOUR__ #ifdefs */

/* TODO: Add checks for string parameters with embedded NUL character */
/* TODO: Add test cases for other string functions */
/* TODO: Incorporate tests from test/working/string*.prg */
/* TODO: String overflow on + and - tests */
/* TODO: Tests with MEMO type ? */
/* TODO: Tests with Log(0) type of invalid values */

#include "error.ch"
#include "fileio.ch"

#translate TEST_LINE( <x>, <result> ) => TEST_CALL( #<x>, {|| <x> }, <result> )

#ifndef __HARBOUR__
   #ifndef __XPP__
      #ifndef __FLAGSHIP__ /* QUESTION: is this the correct constant ? */
         #ifndef __VO__ /* QUESTION: is this the correct constant ? */
            #define __CLIPPER__
         #endif
      #endif
   #endif
#endif

#define TEST_RESULT_COL1_WIDTH  1
#define TEST_RESULT_COL2_WIDTH  20
#define TEST_RESULT_COL3_WIDTH  40
#define TEST_RESULT_COL4_WIDTH  55
#define TEST_RESULT_COL5_WIDTH  55

STATIC s_nPass
STATIC s_nFail
STATIC s_cFileName
STATIC s_nFhnd
STATIC s_cNewLine
STATIC s_nCount
STATIC s_lShowAll
STATIC s_lShortcut
STATIC s_aSkipList
STATIC s_nStartTime
STATIC s_nEndTime

STATIC scString
STATIC scStringM
STATIC scStringE
STATIC scStringZ
STATIC scStringW
STATIC snIntZ
STATIC snDoubleZ
STATIC snIntP
STATIC snIntP1
STATIC snLongP
STATIC snDoubleP
STATIC snIntN
STATIC snLongN
STATIC snDoubleN
STATIC snDoubleI
STATIC sdDate
STATIC sdDateE
STATIC slFalse
STATIC slTrue
STATIC soObject
STATIC suNIL
STATIC sbBlock
STATIC sbBlockC
STATIC saArray
STATIC saAllTypes

MEMVAR mxNotHere /* Please don't declare this variable, since it's used to test undeclared MEMVAR situations. */
MEMVAR mcLongerNameThen10Chars
MEMVAR mcString
MEMVAR mcStringE
MEMVAR mcStringZ
MEMVAR mcStringW
MEMVAR mnIntZ
MEMVAR mnDoubleZ
MEMVAR mnIntP
MEMVAR mnLongP
MEMVAR mnDoubleP
MEMVAR mnDoubleI
MEMVAR mnIntN
MEMVAR mnLongN
MEMVAR mnDoubleN
MEMVAR mdDate
MEMVAR mdDateE
MEMVAR mlFalse
MEMVAR mlTrue
MEMVAR moObject
MEMVAR muNIL
MEMVAR mbBlock
MEMVAR mbBlockC
MEMVAR maArray

FUNCTION Main( cPar1, cPar2 )

   /* Initialize test */

   IF cPar1 == NIL
      cPar1 := ""
   ENDIF
   IF cPar2 == NIL
      cPar2 := ""
   ENDIF

   TEST_BEGIN( cPar1 + " " + cPar2 )

   Main_HVM()
   Main_MATH()
   Main_DATE()
   Main_STRINGS()
#ifdef __HARBOUR__
   New_STRINGS()
   Long_STRINGS()
#endif
   Main_FILE()
   Main_MISC()
#ifdef __HARBOUR__
   Main_OPOVERL()
#endif
   Main_LAST()

   /* Show results, return ERRORLEVEL and exit */

   TEST_END()

   RETURN NIL

STATIC FUNCTION Main_HVM()
   LOCAL nA, nB, nC

/* NOTE: CA-Cl*pper PP fails on these
   TEST_LINE( "1" .AND. "2"                   , "E BASE 1066 Argument error conditional " )
   TEST_LINE( "1" .AND. .F.                   , .F.                                       )
   TEST_LINE( "A" > 1                         , "E BASE 1075 Argument error > F:S"                )
*/

   /* VALTYPE() */

   TEST_LINE( ValType(  scString  )           , "C"   )
   TEST_LINE( ValType(  scStringE )           , "C"   )
   TEST_LINE( ValType(  scStringZ )           , "C"   )
   TEST_LINE( ValType(  snIntZ    )           , "N"   )
   TEST_LINE( ValType(  snDoubleZ )           , "N"   )
   TEST_LINE( ValType(  snIntP    )           , "N"   )
   TEST_LINE( ValType(  snLongP   )           , "N"   )
   TEST_LINE( ValType(  snDoubleP )           , "N"   )
   TEST_LINE( ValType(  snIntN    )           , "N"   )
   TEST_LINE( ValType(  snLongN   )           , "N"   )
   TEST_LINE( ValType(  snDoubleN )           , "N"   )
   TEST_LINE( ValType(  snDoubleI )           , "N"   )
   TEST_LINE( ValType(  sdDateE   )           , "D"   )
   TEST_LINE( ValType(  slFalse   )           , "L"   )
   TEST_LINE( ValType(  slTrue    )           , "L"   )
   TEST_LINE( ValType(  soObject  )           , "O"   )
   TEST_LINE( ValType(  suNIL     )           , "U"   )
   TEST_LINE( ValType(  sbBlock   )           , "B"   )
   TEST_LINE( ValType(  saArray   )           , "A"   )
   TEST_LINE( ValType( { 1, 2, 3 } )          , "A"   )
#ifdef __HARBOUR__
   TEST_LINE( ValType( @scString  )           , "C"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @scStringE )           , "C"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @scStringZ )           , "C"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snIntZ    )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snDoubleZ )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snIntP    )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snLongP   )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snDoubleP )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snIntN    )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snLongN   )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snDoubleN )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @snDoubleI )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @sdDateE   )           , "D"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @slFalse   )           , "L"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @slTrue    )           , "L"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @soObject  )           , "O"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @suNIL     )           , "U"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @sbBlock   )           , "B"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @saArray   )           , "A"   ) /* Bug in CA-Cl*pper, it will return "U" */
#endif
   TEST_LINE( ValType(  mcString  )           , "C"   )
   TEST_LINE( ValType(  mcStringE )           , "C"   )
   TEST_LINE( ValType(  mcStringZ )           , "C"   )
   TEST_LINE( ValType(  mnIntZ    )           , "N"   )
   TEST_LINE( ValType(  mnDoubleZ )           , "N"   )
   TEST_LINE( ValType(  mnIntP    )           , "N"   )
   TEST_LINE( ValType(  mnLongP   )           , "N"   )
   TEST_LINE( ValType(  mnDoubleP )           , "N"   )
   TEST_LINE( ValType(  mnIntN    )           , "N"   )
   TEST_LINE( ValType(  mnLongN   )           , "N"   )
   TEST_LINE( ValType(  mnDoubleN )           , "N"   )
   TEST_LINE( ValType(  mnDoubleI )           , "N"   )
   TEST_LINE( ValType(  mdDateE   )           , "D"   )
   TEST_LINE( ValType(  mlFalse   )           , "L"   )
   TEST_LINE( ValType(  mlTrue    )           , "L"   )
   TEST_LINE( ValType(  moObject  )           , "O"   )
   TEST_LINE( ValType(  muNIL     )           , "U"   )
   TEST_LINE( ValType(  mbBlock   )           , "B"   )
   TEST_LINE( ValType(  maArray   )           , "A"   )
#ifdef __HARBOUR__
   TEST_LINE( ValType( @mcString  )           , "C"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mcStringE )           , "C"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mcStringZ )           , "C"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnIntZ    )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnDoubleZ )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnIntP    )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnLongP   )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnDoubleP )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnIntN    )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnLongN   )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnDoubleN )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mnDoubleI )           , "N"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mdDateE   )           , "D"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mlFalse   )           , "L"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mlTrue    )           , "L"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @moObject  )           , "O"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @muNIL     )           , "U"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @mbBlock   )           , "B"   ) /* Bug in CA-Cl*pper, it will return "U" */
   TEST_LINE( ValType( @maArray   )           , "A"   ) /* Bug in CA-Cl*pper, it will return "U" */
#endif

   /* Special internal messages */

/* Harbour compiler not yet handles these */
#ifndef __HARBOUR__
   TEST_LINE( NIL:className                   , "NIL"       )
#endif                                                      )
   TEST_LINE( "":className                    , "CHARACTER" )
   TEST_LINE( 0:className                     , "NUMERIC"   )
   TEST_LINE( SToD( "" ):className            , "DATE"      )
   TEST_LINE( .F.:className                   , "LOGICAL"   )
   TEST_LINE( {|| nil }:className             , "BLOCK"     )
   TEST_LINE( {}:className                    , "ARRAY"     )
   TEST_LINE( ErrorNew():className            , "ERROR"     )
/* Harbour compiler not yet handles these */
#ifndef __HARBOUR__
   TEST_LINE( NIL:classH                      , 0           )
#endif
   TEST_LINE( "":classH                       , 0           )
   TEST_LINE( 0:classH                        , 0           )
   TEST_LINE( SToD( "" ):classH               , 0           )
   TEST_LINE( .F.:classH                      , 0           )
   TEST_LINE( {|| nil }:classH                , 0           )
   TEST_LINE( {}:classH                       , 0           )
   TEST_LINE( ErrorNew():classH > 0           , .T.         )

/* Harbour compiler not yet handles these */
#ifndef __HARBOUR__
   TEST_LINE( suNIL:className                 , "NIL"       )
#endif
   TEST_LINE( scString:className              , "CHARACTER" )
   TEST_LINE( snIntP:className                , "NUMERIC"   )
   TEST_LINE( sdDateE:className               , "DATE"      )
   TEST_LINE( slFalse:className               , "LOGICAL"   )
   TEST_LINE( sbBlock:className               , "BLOCK"     )
   TEST_LINE( saArray:className               , "ARRAY"     )
   TEST_LINE( soObject:className              , "ERROR"     )
/* Harbour compiler not yet handles these */
#ifndef __HARBOUR__
   TEST_LINE( suNIL:classH                    , 0           )
#endif
   TEST_LINE( scString:classH                 , 0           )
   TEST_LINE( snIntP:classH                   , 0           )
   TEST_LINE( sdDateE:classH                  , 0           )
   TEST_LINE( slFalse:classH                  , 0           )
   TEST_LINE( sbBlock:classH                  , 0           )
   TEST_LINE( saArray:classH                  , 0           )
   TEST_LINE( soObject:classH > 0             , .T.         )

   /* (operators) */

   /* <= */

   TEST_LINE( 2                <= 1                , .F.                                               )
   TEST_LINE( 1                <= 2                , .T.                                               )
   TEST_LINE( 2.0              <= 2                , .T.                                               )
   TEST_LINE( 2                <= 2.0              , .T.                                               )
   TEST_LINE( 2.5              <= 3.7              , .T.                                               )
   TEST_LINE( 3.7              <= 2.5              , .F.                                               )
   TEST_LINE( .F.              <= .F.              , .T.                                               )
   TEST_LINE( .T.              <= .F.              , .F.                                               )
   TEST_LINE( .F.              <= .T.              , .T.                                               )
   TEST_LINE( SToD("")         <= SToD("")         , .T.                                               )
   TEST_LINE( SToD("")         <= SToD("19800101") , .T.                                               )
   TEST_LINE( SToD("19800101") <= SToD("")         , .F.                                               )
   TEST_LINE( ""               <= "AAA"            , .T.                                               )
   TEST_LINE( "AAA"            <= ""               , .T.                                               )
   TEST_LINE( "AAA"            <= "AA"             , .T.                                               )
   TEST_LINE( "AAA"            <= Chr(255)         , .T.                                               )
   TEST_LINE( Chr(150)         <= Chr(255)         , .T.                                               )
   TEST_LINE( "A"              <= "a"              , .T.                                               )
   TEST_LINE( "A"              <= "Z"              , .T.                                               )
   TEST_LINE( "Z"              <= " "              , .F.                                               )
   TEST_LINE( Chr(0)           <= " "              , .T.                                               )
   TEST_LINE( "Hallo"          <= "Hello"          , .T.                                               )
   TEST_LINE( "Hello"          <= "Hello"          , .T.                                               )
   TEST_LINE( "Hell"           <= "Hello"          , .T.                                               )
   TEST_LINE( "Hellow"         <= "Hello"          , .T.                                               )
   TEST_LINE( "J"              <= "Hello"          , .F.                                               )
   TEST_LINE( ""               <= "Hello"          , .T.                                               )
   TEST_LINE( "J"              <= ""               , .T.                                               )
   TEST_LINE( ""               <= ""               , .T.                                               )

   /* < */

   TEST_LINE( 2                <  1                , .F.                                               )
   TEST_LINE( 1                <  2                , .T.                                               )
   TEST_LINE( 2.0              <  2                , .F.                                               )
   TEST_LINE( 2                <  2.0              , .F.                                               )
   TEST_LINE( 2.5              <  3.7              , .T.                                               )
   TEST_LINE( 3.7              <  2.5              , .F.                                               )
   TEST_LINE( .F.              <  .F.              , .F.                                               )
   TEST_LINE( .T.              <  .F.              , .F.                                               )
   TEST_LINE( .F.              <  .T.              , .T.                                               )
   TEST_LINE( SToD("")         <  SToD("")         , .F.                                               )
   TEST_LINE( SToD("")         <  SToD("19800101") , .T.                                               )
   TEST_LINE( SToD("19800101") <  SToD("")         , .F.                                               )
   TEST_LINE( ""               <  "AAA"            , .T.                                               )
   TEST_LINE( "AAA"            <  ""               , .F.                                               )
   TEST_LINE( "AAA"            <  "AA"             , .F.                                               )
   TEST_LINE( "AAA"            <  Chr(255)         , .T.                                               )
   TEST_LINE( Chr(150)         <  Chr(255)         , .T.                                               )
   TEST_LINE( "A"              <  "a"              , .T.                                               )
   TEST_LINE( "A"              <  "Z"              , .T.                                               )
   TEST_LINE( "Z"              <  "A"              , .F.                                               )
   TEST_LINE( Chr(0)           <  " "              , .T.                                               )
   TEST_LINE( "Hallo"          <  "Hello"          , .T.                                               )
   TEST_LINE( "Hello"          <  "Hello"          , .F.                                               )
   TEST_LINE( "Hell"           <  "Hello"          , .T.                                               )
   TEST_LINE( "Hellow"         <  "Hello"          , .F.                                               )
   TEST_LINE( "J"              <  "Hello"          , .F.                                               )
   TEST_LINE( ""               <  "Hello"          , .T.                                               )
   TEST_LINE( "J"              <  ""               , .F.                                               )
   TEST_LINE( ""               <  ""               , .F.                                               )

   /* >= */

   TEST_LINE( 2                >= 1                , .T.                                               )
   TEST_LINE( 1                >= 2                , .F.                                               )
   TEST_LINE( 2.0              >= 2                , .T.                                               )
   TEST_LINE( 2                >= 2.0              , .T.                                               )
   TEST_LINE( 2.5              >= 3.7              , .F.                                               )
   TEST_LINE( 3.7              >= 2.5              , .T.                                               )
   TEST_LINE( .F.              >= .F.              , .T.                                               )
   TEST_LINE( .T.              >= .F.              , .T.                                               )
   TEST_LINE( .F.              >= .T.              , .F.                                               )
   TEST_LINE( SToD("")         >= SToD("")         , .T.                                               )
   TEST_LINE( SToD("")         >= SToD("19800101") , .F.                                               )
   TEST_LINE( SToD("19800101") >= SToD("")         , .T.                                               )
   TEST_LINE( ""               >= "AAA"            , .F.                                               )
   TEST_LINE( "AAA"            >= ""               , .T.                                               )
   TEST_LINE( "AAA"            >= "AA"             , .T.                                               )
   TEST_LINE( "AAA"            >= Chr(255)         , .F.                                               )
   TEST_LINE( Chr(150)         >= Chr(255)         , .F.                                               )
   TEST_LINE( "A"              >= "a"              , .F.                                               )
   TEST_LINE( "A"              >= "Z"              , .F.                                               )
   TEST_LINE( "Z"              >= "A"              , .T.                                               )
   TEST_LINE( Chr(0)           >= " "              , .F.                                               )
   TEST_LINE( "Hallo"          >= "Hello"          , .F.                                               )
   TEST_LINE( "Hello"          >= "Hello"          , .T.                                               )
   TEST_LINE( "Hell"           >= "Hello"          , .F.                                               )
   TEST_LINE( "Hellow"         >= "Hello"          , .T.                                               )
   TEST_LINE( "J"              >= "Hello"          , .T.                                               )
   TEST_LINE( ""               >= "Hello"          , .F.                                               )
   TEST_LINE( "J"              >= ""               , .T.                                               )
   TEST_LINE( ""               >= ""               , .T.                                               )

   /* > */

   TEST_LINE( 2                >  1                , .T.                                               )
   TEST_LINE( 1                >  2                , .F.                                               )
   TEST_LINE( 2.0              >  2                , .F.                                               )
   TEST_LINE( 2                >  2.0              , .F.                                               )
   TEST_LINE( 2.5              >  3.7              , .F.                                               )
   TEST_LINE( 3.7              >  2.5              , .T.                                               )
   TEST_LINE( .F.              >  .F.              , .F.                                               )
   TEST_LINE( .T.              >  .F.              , .T.                                               )
   TEST_LINE( .F.              >  .T.              , .F.                                               )
   TEST_LINE( SToD("")         >  SToD("")         , .F.                                               )
   TEST_LINE( SToD("")         >  SToD("19800101") , .F.                                               )
   TEST_LINE( SToD("19800101") >  SToD("")         , .T.                                               )
   TEST_LINE( ""               >  "AAA"            , .F.                                               )
   TEST_LINE( "AAA"            >  ""               , .F.                                               )
   TEST_LINE( "AAA"            >  "AA"             , .F.                                               )
   TEST_LINE( "AAA"            >  Chr(255)         , .F.                                               )
   TEST_LINE( Chr(150)         >  Chr(255)         , .F.                                               )
   TEST_LINE( "A"              >  "a"              , .F.                                               )
   TEST_LINE( "A"              >  "Z"              , .F.                                               )
   TEST_LINE( "Z"              >  "A"              , .T.                                               )
   TEST_LINE( Chr(0)           >  " "              , .F.                                               )
   TEST_LINE( "Hallo"          >  "Hello"          , .F.                                               )
   TEST_LINE( "Hello"          >  "Hello"          , .F.                                               )
   TEST_LINE( "Hell"           >  "Hello"          , .F.                                               )
   TEST_LINE( "Hellow"         >  "Hello"          , .F.                                               )
   TEST_LINE( "J"              >  "Hello"          , .T.                                               )
   TEST_LINE( ""               >  "Hello"          , .F.                                               )
   TEST_LINE( "J"              >  ""               , .F.                                               )
   TEST_LINE( ""               >  ""               , .F.                                               )

   /* =, == */

   SET EXACT ON
   TEST_LINE( "123" = "123  "                 , .T.                                               )
   TEST_LINE( " 123" = "123"                  , .F.                                               )
   TEST_LINE( "123" = "12345"                 , .F.                                               )
   TEST_LINE( "12345" = "123"                 , .F.                                               )
   TEST_LINE( "123" = ""                      , .F.                                               )
   TEST_LINE( "" = "123"                      , .F.                                               )
   TEST_LINE( "A" == "A"                      , .T.                                               )
   TEST_LINE( "Z" == "A"                      , .F.                                               )
   TEST_LINE( "A" == "A "                     , .F.                                               )
   TEST_LINE( "AA" == "A"                     , .F.                                               )
   SET EXACT OFF
   TEST_LINE( "123" = "123  "                 , .F.                                               )
   TEST_LINE( " 123" = "123"                  , .F.                                               )
   TEST_LINE( "123" = "12345"                 , .F.                                               )
   TEST_LINE( "12345" = "123"                 , .T.                                               )
   TEST_LINE( "123" = ""                      , .T.                                               )
   TEST_LINE( "" = "123"                      , .F.                                               )
   TEST_LINE( "A" == "A"                      , .T.                                               )
   TEST_LINE( "Z" == "A"                      , .F.                                               )
   TEST_LINE( "A" == "A "                     , .F.                                               )
   TEST_LINE( "AA" == "A"                     , .F.                                               )
   TEST_LINE( "Hallo"          == "Hello"     , .F.                                               )
   TEST_LINE( "Hello"          == "Hello"     , .T.                                               )
   TEST_LINE( "Hell"           == "Hello"     , .F.                                               )
   TEST_LINE( "Hellow"         == "Hello"     , .F.                                               )
   TEST_LINE( "J"              == "Hello"     , .F.                                               )
   TEST_LINE( ""               == "Hello"     , .F.                                               )
   TEST_LINE( "J"              == ""          , .F.                                               )
   TEST_LINE( ""               == ""          , .T.                                               )

   TEST_LINE( scString  = scString            , .T.                                               )
   TEST_LINE( scString  = scStringE           , .T.                                               )
   TEST_LINE( scString  = scStringZ           , .F.                                               )
   TEST_LINE( scStringE = scString            , .F.                                               )
   TEST_LINE( scStringE = scStringE           , .T.                                               )
   TEST_LINE( scStringE = scStringZ           , .F.                                               )
   TEST_LINE( scStringZ = scString            , .F.                                               )
   TEST_LINE( scStringZ = scStringE           , .T.                                               )
   TEST_LINE( scStringZ = scStringZ           , .T.                                               )

   /* != */

   SET EXACT ON
   TEST_LINE( "123" != "123  "                , .F.                                               )
   TEST_LINE( " 123" != "123"                 , .T.                                               )
   TEST_LINE( "123" != "12345"                , .T.                                               )
   TEST_LINE( "12345" != "123"                , .T.                                               )
   TEST_LINE( "123" != ""                     , .T.                                               )
   TEST_LINE( "" != "123"                     , .T.                                               )
   TEST_LINE( "A" != "A"                      , .F.                                               )
   TEST_LINE( "Z" != "A"                      , .T.                                               )
   TEST_LINE( "A" != "A "                     , .F.                                               )
   TEST_LINE( "AA" != "A"                     , .T.                                               )
   SET EXACT OFF
   TEST_LINE( "123" != "123  "                , .T.                                               )
   TEST_LINE( " 123" != "123"                 , .T.                                               )
   TEST_LINE( "123" != "12345"                , .T.                                               )
   TEST_LINE( "12345" != "123"                , .F.                                               )
   TEST_LINE( "123" != ""                     , .F.                                               )
   TEST_LINE( "" != "123"                     , .T.                                               )
   TEST_LINE( "A" != "A"                      , .F.                                               )
   TEST_LINE( "Z" != "A"                      , .T.                                               )
   TEST_LINE( "A" != "A "                     , .T.                                               )
   TEST_LINE( "AA" != "A"                     , .F.                                               )
   TEST_LINE( "Hallo"          != "Hello"     , .T.                                               )
   TEST_LINE( "Hello"          != "Hello"     , .F.                                               )
   TEST_LINE( "Hell"           != "Hello"     , .T.                                               )
   TEST_LINE( "Hellow"         != "Hello"     , .F.                                               )
   TEST_LINE( "J"              != "Hello"     , .T.                                               )
   TEST_LINE( ""               != "Hello"     , .T.                                               )
   TEST_LINE( "J"              != ""          , .F.                                               )
   TEST_LINE( ""               != ""          , .F.                                               )

   TEST_LINE( scString  != scString           , .F.                                               )
   TEST_LINE( scString  != scStringE          , .F.                                               )
   TEST_LINE( scString  != scStringZ          , .T.                                               )
   TEST_LINE( scStringE != scString           , .T.                                               )
   TEST_LINE( scStringE != scStringE          , .F.                                               )
   TEST_LINE( scStringE != scStringZ          , .T.                                               )
   TEST_LINE( scStringZ != scString           , .T.                                               )
   TEST_LINE( scStringZ != scStringE          , .F.                                               )
   TEST_LINE( scStringZ != scStringZ          , .F.                                               )

   /* == special */

   TEST_LINE( NIL == NIL                      , .T.                                               )
   TEST_LINE( scString == NIL                 , .F.                                               )
   TEST_LINE( scString == 1                   , "E BASE 1070 Argument error == F:S"               )
   TEST_LINE( soObject == ""                  , "E BASE 1070 Argument error == F:S"               )
   TEST_LINE( soObject == soObject            , .T.                                               )
   TEST_LINE( soObject == ErrorNew()          , .F.                                               )
   TEST_LINE( ErrorNew() == ErrorNew()        , .F.                                               )
   TEST_LINE( soObject == TBColumnNew()       , .F.                                               )
   TEST_LINE( saArray == saArray              , .T.                                               )
   TEST_LINE( {} == {}                        , .F.                                               )
   TEST_LINE( {|| NIL } == {|| NIL }          , "E BASE 1070 Argument error == F:S"               )

   /* = special */

   TEST_LINE( NIL = NIL                       , .T.                                               )
   TEST_LINE( scString = NIL                  , .F.                                               )
   TEST_LINE( scString = 1                    , "E BASE 1071 Argument error = F:S"                )
   TEST_LINE( soObject = ""                   , "E BASE 1071 Argument error = F:S"                )
   TEST_LINE( soObject = soObject             , "E BASE 1071 Argument error = F:S"                )
   TEST_LINE( soObject = ErrorNew()           , "E BASE 1071 Argument error = F:S"                )
   TEST_LINE( ErrorNew() = ErrorNew()         , "E BASE 1071 Argument error = F:S"                )
   TEST_LINE( soObject = TBColumnNew()        , "E BASE 1071 Argument error = F:S"                )
   TEST_LINE( saArray = saArray               , "E BASE 1071 Argument error = F:S"                )
   TEST_LINE( {} = {}                         , "E BASE 1071 Argument error = F:S"                )
   TEST_LINE( {|| NIL } = {|| NIL }           , "E BASE 1071 Argument error = F:S"                )

   /* != special */

   TEST_LINE( NIL != NIL                      , .F.                                               )
   TEST_LINE( scString != NIL                 , .T.                                               )
   TEST_LINE( scString != 1                   , "E BASE 1072 Argument error <> F:S"               )
   TEST_LINE( soObject != ""                  , "E BASE 1072 Argument error <> F:S"               )
   TEST_LINE( soObject != soObject            , "E BASE 1072 Argument error <> F:S"               )
   TEST_LINE( soObject != ErrorNew()          , "E BASE 1072 Argument error <> F:S"               )
   TEST_LINE( ErrorNew() != ErrorNew()        , "E BASE 1072 Argument error <> F:S"               )
   TEST_LINE( soObject != TBColumnNew()       , "E BASE 1072 Argument error <> F:S"               )
   TEST_LINE( saArray != saArray              , "E BASE 1072 Argument error <> F:S"               )
   TEST_LINE( {} != {}                        , "E BASE 1072 Argument error <> F:S"               )
   TEST_LINE( {|| NIL } != {|| NIL }          , "E BASE 1072 Argument error <> F:S"               )

   /* < special */

   TEST_LINE( NIL < NIL                       , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( scString < NIL                  , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( scString < 1                    , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( soObject < ""                   , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( soObject < soObject             , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( soObject < ErrorNew()           , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( ErrorNew() < ErrorNew()         , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( soObject < TBColumnNew()        , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( saArray < saArray               , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( {} < {}                         , "E BASE 1073 Argument error < F:S"                )
   TEST_LINE( {|| NIL } < {|| NIL }           , "E BASE 1073 Argument error < F:S"                )

   /* <= special */

   TEST_LINE( NIL <= NIL                      , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( scString <= NIL                 , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( scString <= 1                   , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( soObject <= ""                  , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( soObject <= soObject            , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( soObject <= ErrorNew()          , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( ErrorNew() <= ErrorNew()        , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( soObject <= TBColumnNew()       , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( saArray <= saArray              , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( {} <= {}                        , "E BASE 1074 Argument error <= F:S"               )
   TEST_LINE( {|| NIL } <= {|| NIL }          , "E BASE 1074 Argument error <= F:S"               )

   /* > special */

   TEST_LINE( NIL > NIL                       , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( scString > NIL                  , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( scString > 1                    , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( soObject > ""                   , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( soObject > soObject             , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( soObject > ErrorNew()           , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( ErrorNew() > ErrorNew()         , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( soObject > TBColumnNew()        , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( saArray > saArray               , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( {} > {}                         , "E BASE 1075 Argument error > F:S"                )
   TEST_LINE( {|| NIL } > {|| NIL }           , "E BASE 1075 Argument error > F:S"                )

   /* >= special */

   TEST_LINE( NIL >= NIL                      , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( scString >= NIL                 , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( scString >= 1                   , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( soObject >= ""                  , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( soObject >= soObject            , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( soObject >= ErrorNew()          , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( ErrorNew() >= ErrorNew()        , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( soObject >= TBColumnNew()       , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( saArray >= saArray              , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( {} >= {}                        , "E BASE 1076 Argument error >= F:S"               )
   TEST_LINE( {|| NIL } >= {|| NIL }          , "E BASE 1076 Argument error >= F:S"               )

   // NOTE: These are compiler tests.
   //       The expressions have to be written with no separators!
   TEST_LINE( mnIntP==10.OR.mnIntP==0         , .T.                                               )
   TEST_LINE( mnIntP==10.AND.mnLongP==0       , .F.                                               )

   TEST_LINE( NIL + 1                         , "E BASE 1081 Argument error + F:S" )
   TEST_LINE( NIL - 1                         , "E BASE 1082 Argument error - F:S" )

   TEST_LINE( scString + NIL                  , "E BASE 1081 Argument error + F:S" )
   TEST_LINE( scString - NIL                  , "E BASE 1082 Argument error - F:S" )

   TEST_LINE( 1 + NIL                         , "E BASE 1081 Argument error + F:S" )
   TEST_LINE( 1 - NIL                         , "E BASE 1082 Argument error - F:S" )

   TEST_LINE( "A" - "B"                       , "AB"                               )
   TEST_LINE( "A  " - "B"                     , "AB  "                             )
   TEST_LINE( "A  " - "B "                    , "AB   "                            )
   TEST_LINE( "A  " - " B"                    , "A B  "                            )
   TEST_LINE( "   " - "B "                    , "B    "                            )

   TEST_LINE( 1 / 0                           , "E BASE 1340 Zero divisor / F:S"   )
   TEST_LINE( 1 / NIL                         , "E BASE 1084 Argument error / F:S" )
   TEST_LINE( 1 * NIL                         , "E BASE 1083 Argument error * F:S" )
   TEST_LINE( 1 ** NIL                        , "E BASE 1088 Argument error ^ F:S" )
   TEST_LINE( 1 ^ NIL                         , "E BASE 1088 Argument error ^ F:S" )
   TEST_LINE( 1 % 0                           , "E BASE 1341 Zero divisor % F:S"   )
   TEST_LINE( 1 % NIL                         , "E BASE 1085 Argument error % F:S" )

   /* The order of these tests is relevant, don't change it */

   nA := 1
   nB := 2
   nC := 3

   TEST_LINE( nA                              , 1 )
   TEST_LINE( nB                              , 2 )
   TEST_LINE( nC                              , 3 )

   TEST_LINE( nA + nB                         , 3 )
   TEST_LINE( nB - nA                         , 1 )
   TEST_LINE( nB * nC                         , 6 )
   TEST_LINE( nB * nC / 2                     , 3 )
   TEST_LINE( nA += nB                        , 3 )
   TEST_LINE( nA                              , 3 )
   TEST_LINE( nA -= nB                        , 1 )
   TEST_LINE( nA                              , 1 )
   TEST_LINE( nA < nB                         , .T. )
   TEST_LINE( nA > nB                         , .F. )
   TEST_LINE( nA + nB <= nC                   , .T. )
   TEST_LINE( nA + nB >= nC                   , .T. )
   TEST_LINE( nA *= nB                        , 2 )
   TEST_LINE( nA /= nB                        , 1 )
   TEST_LINE( nA                              , 1 )
   TEST_LINE( nB ** 3                         , 8 )
   TEST_LINE( nB ^ 3                          , 8 )
   TEST_LINE( 8 % 3                           , 2 )
   TEST_LINE( nA++                            , 1 )
   TEST_LINE( nA                              , 2 )
   TEST_LINE( ++nA                            , 3 )
   TEST_LINE( nA                              , 3 )
   TEST_LINE( nA--                            , 3 )
   TEST_LINE( nA                              , 2 )
   TEST_LINE( --nA                            , 1 )
   TEST_LINE( nA                              , 1 )

   /* Operator precedence */

   TEST_LINE( 1 + 2 * 3 / 4 - 2 ** 2 ^ 3      , -61.50 )
   TEST_LINE( 1 + 2 * 3 / 4 - 2 ** 2 ^ 3 == 2 , .F. )

   /* */

   TEST_LINE( -Month(sdDate)                  , -1                                 )
   TEST_LINE( Str(-(Month(sdDate)))           , "        -1"                       )
   TEST_LINE( Str(-(Val("10")))               , "       -10"                       )
   TEST_LINE( Str(-(Val("100000")))           , "   -100000"                       )
   TEST_LINE( Str(-(Val("20.876")))           , "       -20.876"                   )
   TEST_LINE( -(0)                            , 0                                  )
   TEST_LINE( -(10)                           , -10                                )
   TEST_LINE( -(10.505)                       , -10.505                            )
   TEST_LINE( -(100000)                       , -100000                            )
   TEST_LINE( -(-10)                          , 10                                 )
   TEST_LINE( -("1")                          , "E BASE 1080 Argument error - F:S" )

   TEST_LINE( "AA" $ 1                        , "E BASE 1109 Argument error $ F:S" )
   TEST_LINE( scString $ 1                    , "E BASE 1109 Argument error $ F:S" )
   TEST_LINE( 1 $ "AA"                        , "E BASE 1109 Argument error $ F:S" )

   TEST_LINE( !   scStringE $ "XE"            , .T. )
   TEST_LINE( ! ( scStringE $ "XE" )          , .T. )
   TEST_LINE(     scStringE $ "XE"            , .F. )
   TEST_LINE( !   "X" $ "XE"                  , .F. )
   TEST_LINE( ! ( "X" $ "XE" )                , .F. )
   TEST_LINE(     "X" $ "XE"                  , .T. )
   TEST_LINE(     "X" $ Chr(0) + "X"          , .T. )
   TEST_LINE( ( "X" ) $ Chr(0) + "X"          , .T. )
   TEST_LINE( scString $ Chr(0) + scString    , .T. )

   TEST_LINE( scStringE $ "bcde"              , .F. )
   TEST_LINE( ( "" ) $ "bcde"                 , .F. )
   TEST_LINE(   ""   $ "bcde"                 , .F. ) /* Bug in CA-Cl*ppers compiler optimalizer, it will return .T. */
   TEST_LINE( "d" $ "bcde"                    , .T. )
   TEST_LINE( "D" $ "BCDE"                    , .T. )
   TEST_LINE( "a" $ "bcde"                    , .F. )
   TEST_LINE( "d" $ "BCDE"                    , .F. )
   TEST_LINE( "D" $ "bcde"                    , .F. )
   TEST_LINE( "de" $ "bcde"                   , .T. )
   TEST_LINE( "bd" $ "bcde"                   , .F. )
   TEST_LINE( "BD" $ "bcde"                   , .F. )

   IF TEST_OPT_Z()

   /* With the shortcut optimalization *ON* */

   TEST_LINE( 1 .AND. 2                       , "E BASE 1066 Argument error conditional " )
   TEST_LINE( NIL .AND. NIL                   , "E BASE 1066 Argument error conditional " )
   TEST_LINE( scString .AND. scString         , "E BASE 1066 Argument error conditional " )
   TEST_LINE( .T. .AND. 1                     , 1                                         )
   TEST_LINE( .T. .AND. 1.567                 , 1.567                                     )
   TEST_LINE( .T. .AND. scString              , "HELLO"                                   )
   TEST_LINE( .T. .AND. SToD("")              , SToD("        ")                          )
   TEST_LINE( .T. .AND. NIL                   , NIL                                       )
   TEST_LINE( .T. .AND. {}                    , "{.[0].}"                                 )
   TEST_LINE( .T. .AND. {|| NIL }             , "{||...}"                                 )
   TEST_LINE( .F. .AND. 1                     , .F.                                       )
   TEST_LINE( .F. .AND. 1.567                 , .F.                                       )
   TEST_LINE( .F. .AND. scString              , .F.                                       )
   TEST_LINE( .F. .AND. SToD("")              , .F.                                       )
   TEST_LINE( .F. .AND. NIL                   , .F.                                       )
   TEST_LINE( .F. .AND. {}                    , .F.                                       )
   TEST_LINE( .F. .AND. {|| NIL }             , .F.                                       )
   TEST_LINE( 1 .AND. .F.                     , .F.                                       )
   TEST_LINE( 1.567 .AND. .F.                 , .F.                                       )
   TEST_LINE( scString .AND. .F.              , .F.                                       )

   TEST_LINE( 1 .OR. 2                        , "E BASE 1066 Argument error conditional " )
   TEST_LINE( .F. .OR. 2                      , 2                                         )
   TEST_LINE( .F. .OR. 1.678                  , 1.678                                     )
   TEST_LINE( .F. .OR. scString               , "HELLO"                                   )
   TEST_LINE( .T. .OR. 2                      , .T.                                       )
   TEST_LINE( .T. .OR. 1.678                  , .T.                                       )
   TEST_LINE( .T. .OR. scString               , .T.                                       )
   TEST_LINE( 1 .OR. .F.                      , 1                                         )
   TEST_LINE( 1.0 .OR. .F.                    , 1.0                                       )
   TEST_LINE( scString .OR. .F.               , "HELLO"                                   )

   ELSE

   /* With the shortcut optimalization *OFF* (/z switch) */

   TEST_LINE( 1 .AND. 2                       , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( NIL .AND. NIL                   , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( scString .AND. scString         , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .T. .AND. 1                     , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .T. .AND. 1.567                 , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .T. .AND. scString              , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .T. .AND. SToD("")              , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .T. .AND. NIL                   , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .T. .AND. {}                    , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .T. .AND. {|| NIL }             , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .F. .AND. 1                     , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .F. .AND. 1.567                 , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .F. .AND. scString              , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .F. .AND. SToD("")              , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .F. .AND. NIL                   , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .F. .AND. {}                    , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( .F. .AND. {|| NIL }             , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( 1 .AND. .F.                     , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( 1.567 .AND. .F.                 , "E BASE 1078 Argument error .AND. F:S"    )
   TEST_LINE( scString .AND. .F.              , "E BASE 1078 Argument error .AND. F:S"    )

   TEST_LINE( 1 .OR. 2                        , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( .F. .OR. 2                      , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( .F. .OR. 1.678                  , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( .F. .OR. scString               , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( .T. .OR. 2                      , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( .T. .OR. 1.678                  , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( .T. .OR. scString               , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( 1 .OR. .F.                      , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( 1.0 .OR. .F.                    , "E BASE 1079 Argument error .OR. F:S"     )
   TEST_LINE( scString .OR. .F.               , "E BASE 1079 Argument error .OR. F:S"     )

   ENDIF

   TEST_LINE( .NOT. .T.                       , .F.                                       )
   TEST_LINE( .NOT. .F.                       , .T.                                       )
   TEST_LINE( .NOT. 1                         , "E BASE 1077 Argument error .NOT. F:S"    )

   TEST_LINE( iif( "A", ":T:", ":F:" )        , "E BASE 1066 Argument error conditional " )
   TEST_LINE( iif( .T., ":T:", ":F:" )        , ":T:"                                     )
   TEST_LINE( iif( .F., ":T:", ":F:" )        , ":F:"                                     )

   TEST_LINE( scString++                      , "E BASE 1086 Argument error ++ F:S"       )
   TEST_LINE( scString--                      , "E BASE 1087 Argument error -- F:S"       )

   TEST_LINE( mxNotHere                       , "E BASE 1003 Variable does not exist MXNOTHERE F:R" )
#ifdef __HARBOUR__
   TEST_LINE( __MVGET("MXUNDECL")             , "E BASE 1003 Variable does not exist MXUNDECL F:R" )
#else
   mxNotHere ="MXUNDECL"
   TEST_LINE( &mxNotHere.                     , "E BASE 1003 Variable does not exist MXUNDECL F:R" )
#endif

   TEST_LINE( saArray[ 0 ]                    , "E BASE 1132 Bound error array access "           )
   TEST_LINE( saArray[ 0 ] := 1               , "E BASE 1133 Bound error array assign "           )
   TEST_LINE( saArray[ 1000 ]                 , "E BASE 1132 Bound error array access "           )
   TEST_LINE( saArray[ 1000 ] := 1            , "E BASE 1133 Bound error array assign "           )
   TEST_LINE( saArray[ -1 ]                   , "E BASE 1132 Bound error array access "           )
   TEST_LINE( saArray[ -1 ] := 1              , "E BASE 1133 Bound error array assign "           )
   TEST_LINE( saArray[ "1" ]                  , "E BASE 1068 Argument error array access F:S"     )
   TEST_LINE( saArray[ "1" ] := 1             , "E BASE 1069 Argument error array assign "        )

   /* Alias */

   TEST_LINE( ("NOTHERE")->NOFIELD            , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( (mcString)->NOFIELD             , "E BASE 1002 Alias does not exist HELLO F:R"      )
   TEST_Line( ({})->NOFIELD                   , "E BASE 1065 Argument error & F:S"                )
   TEST_LINE( ({|| NIL })->NOFIELD            , "E BASE 1065 Argument error & F:S"                )
   TEST_LINE( (.T.)->NOFIELD                  , "E BASE 1065 Argument error & F:S"                )
   TEST_LINE( (.F.)->NOFIELD                  , "E BASE 1065 Argument error & F:S"                )
   TEST_LINE( (NIL)->NOFIELD                  , "E BASE 1065 Argument error & F:S"                )
   TEST_LINE( (1)->NOFIELD                    , "E BASE 1003 Variable does not exist NOFIELD F:R" )
   TEST_LINE( (1.5)->NOFIELD                  , "E BASE 1003 Variable does not exist NOFIELD F:R" )
   TEST_LINE( (SToD(""))->NOFIELD             , "E BASE 1065 Argument error & F:S"                )
   TEST_LINE( (ErrorNew())->NOFIELD           , "E BASE 1065 Argument error & F:S"                )

   TEST_LINE( ("NOTHERE")->(Eof())            , .T.                                               )
   TEST_LINE( (mcString)->(Eof())             , .T.                                               )
   TEST_LINE( ({})->(Eof())                   , .T.                                               )
   TEST_LINE( ({|| NIL })->(Eof())            , .T.                                               )
   TEST_LINE( (.T.)->(Eof())                  , .T.                                               )
   TEST_LINE( (.F.)->(Eof())                  , .T.                                               )
   TEST_LINE( (NIL)->(Eof())                  , .T.                                               )
   TEST_LINE( (1)->(Eof())                    , .T.                                               )
   TEST_LINE( (1.5)->(Eof())                  , .T.                                               )
   TEST_LINE( (SToD(""))->(Eof())             , .T.                                               )
   TEST_LINE( (ErrorNew())->(Eof())           , .T.                                               )

   TEST_LINE( NOTHERE->NOFIELD                , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->("NOFIELD")            , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->(mcString)             , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->({})                   , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->({|| NIL })            , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->(.T.)                  , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->(.F.)                  , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->(NIL)                  , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->(1)                    , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->(1.5)                  , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->(SToD(""))             , "E BASE 1002 Alias does not exist NOTHERE F:R"    )
   TEST_LINE( NOTHERE->(ErrorNew())           , "E BASE 1002 Alias does not exist NOTHERE F:R"    )

   TEST_LINE( 200->NOFIELD                    , "E BASE 1003 Variable does not exist NOFIELD F:R" )
   TEST_LINE( 200->("NOFIELD")                , "NOFIELD"                                         )
   TEST_LINE( 200->(mcString)                 , "HELLO"                                           )
   TEST_LINE( 200->({})                       , "{.[0].}"                                         )
   TEST_LINE( 200->({|| NIL })                , "{||...}"                                         )
   TEST_LINE( 200->(.T.)                      , .T.                                               )
   TEST_LINE( 200->(.F.)                      , .F.                                               )
   TEST_LINE( 200->(NIL)                      , NIL                                               )
   TEST_LINE( 200->(1)                        , 1                                                 )
   TEST_LINE( 200->(1.5)                      , 1.5                                               )
   TEST_LINE( 200->(SToD(""))                 , SToD("        ")                                  )
   TEST_LINE( 200->(ErrorNew())               , "ERROR Object"                                    )

   TEST_LINE( soObject:hello                  , "E BASE 1004 No exported method HELLO F:S"        )
   TEST_LINE( soObject:hello := 1             , "E BASE 1005 No exported variable HELLO F:S"      )

   /* LEN() */

   TEST_LINE( Len( NIL )                      , "E BASE 1111 Argument error LEN F:S"   )
   TEST_LINE( Len( 123 )                      , "E BASE 1111 Argument error LEN F:S"   )
   TEST_LINE( Len( "" )                       , 0                                      )
   TEST_LINE( Len( "123" )                    , 3                                      )
   TEST_LINE( Len( "123"+Chr(0)+"456 " )      , 8                                      )
   TEST_LINE( Len( saArray )                  , 1                                      )
#ifdef __HARBOUR__
   TEST_LINE( Len( Space( 1000000 ) )         , 1000000                                )
#else
   TEST_LINE( Len( Space( 40000 ) )           , 40000                                  )
#endif

   /* EMPTY() */

#ifdef __HARBOUR__
   TEST_LINE( Empty( @scString              ) , .F.                                    ) /* Bug in CA-Cl*pper, it will return .T. */
   TEST_LINE( Empty( @scStringE             ) , .T.                                    )
   TEST_LINE( Empty( @snIntP                ) , .F.                                    ) /* Bug in CA-Cl*pper, it will return .T. */
   TEST_LINE( Empty( @snIntZ                ) , .T.                                    )
#endif
   TEST_LINE( Empty( "Hallo"                ) , .F.                                    )
   TEST_LINE( Empty( ""                     ) , .T.                                    )
   TEST_LINE( Empty( "  "                   ) , .T.                                    )
   TEST_LINE( Empty( " "+Chr(0)             ) , .F.                                    )
   TEST_LINE( Empty( " "+Chr(13)+Chr(9)     ) , .T.                                    )
   TEST_LINE( Empty( "  A"                  ) , .F.                                    )
   TEST_LINE( Empty( " x "                  ) , .F.                                    )
   TEST_LINE( Empty( " x"+Chr(0)            ) , .F.                                    )
   TEST_LINE( Empty( " "+Chr(13)+"x"+Chr(9) ) , .F.                                    )
   TEST_LINE( Empty( 0                      ) , .T.                                    )
   TEST_LINE( Empty( -0                     ) , .T.                                    )
   TEST_LINE( Empty( 0.0                    ) , .T.                                    )
   TEST_LINE( Empty( 70000-70000            ) , .T.                                    )
   TEST_LINE( Empty( 1.5*1.5-2.25           ) , .T.                                    )
   TEST_LINE( Empty( 10                     ) , .F.                                    )
   TEST_LINE( Empty( 10.0                   ) , .F.                                    )
   TEST_LINE( Empty( 70000+70000            ) , .F.                                    )
   TEST_LINE( Empty( 1.5*1.5*2.25           ) , .F.                                    )
   TEST_LINE( Empty( SToD("18241010")       ) , .F.                                    )
   TEST_LINE( Empty( SToD("18250231")       ) , .T.                                    )
   TEST_LINE( Empty( SToD("99999999")       ) , .T.                                    )
   TEST_LINE( Empty( SToD("        ")       ) , .T.                                    )
   TEST_LINE( Empty( SToD("")               ) , .T.                                    )
   TEST_LINE( Empty( .T.                    ) , .F.                                    )
   TEST_LINE( Empty( .F.                    ) , .T.                                    )
   TEST_LINE( Empty( NIL                    ) , .T.                                    )
   TEST_LINE( Empty( {1}                    ) , .F.                                    )
   TEST_LINE( Empty( {}                     ) , .T.                                    )
   TEST_LINE( Empty( {0}                    ) , .F.                                    )
   TEST_LINE( Empty( {|x|x+x}               ) , .F.                                    )
   TEST_LINE( Empty( ErrorNew()             ) , .F.                                    )

   RETURN NIL

STATIC FUNCTION Main_MATH()

   /* LOG() */

   TEST_LINE( Log("A")                        , "E BASE 1095 Argument error LOG F:S"   )
   TEST_LINE( Str(Log(-1))                    , "***********************"              )
//   TEST_LINE( Str(Log(0))                     , "***********************"              )
   TEST_LINE( Str(Log(1))                     , "         0.00"                        )
   TEST_LINE( Str(Log(12))                    , "         2.48"                        )
   TEST_LINE( Str(Log(snIntP))                , "         2.30"                        )
#ifdef __HARBOUR__
   TEST_LINE( Str(Log(@snIntP))               , "         2.30"                        ) /* Bug in CA-Cl*pper, it returns: "E BASE 1095 Argument error LOG F:S" */
#endif

   /* SQRT() */

   TEST_LINE( Sqrt("A")                       , "E BASE 1097 Argument error SQRT F:S"  )
   TEST_LINE( Sqrt(-1)                        , 0                                      )
   TEST_LINE( Sqrt(0)                         , 0                                      )
   TEST_LINE( Sqrt(4)                         , 2                                      )
   TEST_LINE( Str(Sqrt(snIntP))               , "         3.16"                        )
#ifdef __HARBOUR__
   TEST_LINE( Str(Sqrt(@snIntP))              , "         3.16"                        ) /* Bug in CA-Cl*pper, it returns: "E BASE 1097 Argument error SQRT F:S" */
#endif
   TEST_LINE( Str(Sqrt(4),21,18)              , " 2.000000000000000000"                )
   TEST_LINE( Str(Sqrt(3),21,18)              , " 1.732050807568877193"                ) /* Bug in CA-Cl*pper 5.2e, it returns: " 1.732050807568877000" */

   /* ABS() */

   TEST_LINE( Abs("A")                        , "E BASE 1089 Argument error ABS F:S"   )
   TEST_LINE( Abs(0)                          , 0                                      )
   TEST_LINE( Abs(10)                         , 10                                     )
   TEST_LINE( Abs(-10)                        , 10                                     )
   TEST_LINE( Str(Abs(snIntN))                , "        10"                           )
#ifdef __HARBOUR__
   TEST_LINE( Str(Abs(@snIntN))               , "        10"                           ) /* Bug in CA-Cl*pper, it returns: "E BASE 1089 Argument error ABS F:S" */
#endif
   TEST_LINE( Abs(Month(sdDate))              , 1                                      )
   TEST_LINE( Abs(-Month(sdDate))             , 1                                      )
   TEST_LINE( Str(Abs(Month(sdDate)))         , "  1"                                  )
   TEST_LINE( Str(Abs(-Month(sdDate)))        , "         1"                           )
   TEST_LINE( Str(Abs(Val("0")))              , "0"                                    )
   TEST_LINE( Str(Abs(Val("-0")))             , " 0"                                   )
   TEST_LINE( Str(Abs(Val("150")))            , "150"                                  )
   TEST_LINE( Str(Abs(Val("-150")))           , "       150"                           )
   TEST_LINE( Str(Abs(Val("150.245")))        , "       150.245"                       )
   TEST_LINE( Str(Abs(Val("-150.245")))       , "       150.245"                       )
   TEST_LINE( Abs(0.1)                        , 0.1                                    )
   TEST_LINE( Abs(10.5)                       , 10.5                                   )
   TEST_LINE( Abs(-10.7)                      , 10.7                                   )
   TEST_LINE( Abs(10.578)                     , 10.578                                 )
   TEST_LINE( Abs(-10.578)                    , 10.578                                 )
   TEST_LINE( Abs(100000)                     , 100000                                 )
   TEST_LINE( Abs(-100000)                    , 100000                                 )

   /* EXP() */

   TEST_LINE( Exp("A")                        , "E BASE 1096 Argument error EXP F:S"   )
   TEST_LINE( Exp(0)                          , 1.00                                   )
   TEST_LINE( Str(Exp(15))                    , "   3269017.37"                        )
   TEST_LINE( Str(Exp(snIntZ))                , "         1.00"                        )
#ifdef __HARBOUR__
   TEST_LINE( Str(Exp(@snIntZ))               , "         1.00"                        ) /* Bug in CA-Cl*pper, it returns: "E BASE 1096 Argument error EXP F:S" */
#endif
   TEST_LINE( Round(Exp(1),2)                 , 2.72                                   )
   TEST_LINE( Str(Exp(1),20,10)               , "        2.7182818285"                 )
   TEST_LINE( Round(Exp(10),2)                , 22026.47                               )
   TEST_LINE( Str(Exp(10),20,10)              , "    22026.4657948067"                 )

   /* ROUND() */

   TEST_LINE( Round(snDoubleP, snIntZ)        , 11                                     )
#ifdef __HARBOUR__
   TEST_LINE( Round(@snDoubleP, @snIntZ)      , 11                                     ) /* Bug in CA-Cl*pper, it returns: "E BASE 1094 Argument error ROUND F:S" */
#endif
   TEST_LINE( Round(NIL, 0)                   , "E BASE 1094 Argument error ROUND F:S" )
   TEST_LINE( Round(0, NIL)                   , "E BASE 1094 Argument error ROUND F:S" )
   TEST_LINE( Round(0, 0)                     , 0                )
   TEST_LINE( Round(0, 2)                     , 0.00             )
   TEST_LINE( Round(0, -2)                    , 0                )
   TEST_LINE( Round(0.5, 0)                   , 1                )
   TEST_LINE( Round(0.5, 1)                   , 0.5              )
   TEST_LINE( Round(0.5, 2)                   , 0.50             )
   TEST_LINE( Round(0.5, -1)                  , 0                )
   TEST_LINE( Round(0.5, -2)                  , 0                )
   TEST_LINE( Round(0.50, 0)                  , 1                )
   TEST_LINE( Round(0.50, 1)                  , 0.5              )
   TEST_LINE( Round(0.50, 2)                  , 0.50             )
   TEST_LINE( Round(0.50, -1)                 , 0                )
   TEST_LINE( Round(0.50, -2)                 , 0                )
   TEST_LINE( Round(0.55, 0)                  , 1                )
   TEST_LINE( Round(0.55, 1)                  , 0.6              )
   TEST_LINE( Round(0.55, 2)                  , 0.55             )
   TEST_LINE( Round(0.55, -1)                 , 0                )
   TEST_LINE( Round(0.55, -2)                 , 0                )
   TEST_LINE( Round(0.557, 0)                 , 1                )
   TEST_LINE( Round(0.557, 1)                 , 0.6              )
   TEST_LINE( Round(0.557, 2)                 , 0.56             )
   TEST_LINE( Round(0.557, -1)                , 0                )
   TEST_LINE( Round(0.557, -2)                , 0                )
   TEST_LINE( Round(50, 0)                    , 50               )
   TEST_LINE( Round(50, 1)                    , 50.0             )
   TEST_LINE( Round(50, 2)                    , 50.00            )
   TEST_LINE( Round(50, -1)                   , 50               )
   TEST_LINE( Round(50, -2)                   , 100              )
   TEST_LINE( Round(10.50, 0)                 , 11               )
   TEST_LINE( Round(10.50, -1)                , 10               )
   TEST_LINE( Round(500000, 0)                , 500000           )
   TEST_LINE( Round(500000, 1)                , 500000.0         )
   TEST_LINE( Round(500000, 2)                , 500000.00        )
   TEST_LINE( Round(500000, -1)               , 500000           )
   TEST_LINE( Round(500000, -2)               , 500000           )
   TEST_LINE( Round(500000, -2)               , 500000           )
   TEST_LINE( Round(5000000000, 0)            , 5000000000       )
   TEST_LINE( Round(5000000000, 1)            , 5000000000.0     )
   TEST_LINE( Round(5000000000, 2)            , 5000000000.00    )
   TEST_LINE( Round(5000000000, -1)           , 5000000000       )
   TEST_LINE( Round(5000000000, -2)           , 5000000000       )
   TEST_LINE( Round(5000000000, -2)           , 5000000000       )
   TEST_LINE( Round(5000000000.129, 0)        , 5000000000       )
   TEST_LINE( Round(5000000000.129, 1)        , 5000000000.1     )
   TEST_LINE( Round(5000000000.129, 2)        , 5000000000.13    )
   TEST_LINE( Round(5000000000.129, -1)       , 5000000000       )
   TEST_LINE( Round(5000000000.129, -2)       , 5000000000       )
   TEST_LINE( Round(5000000000.129, -2)       , 5000000000       )
   TEST_LINE( Round(-0.5, 0)                  , -1               )
   TEST_LINE( Round(-0.5, 1)                  , -0.5             )
   TEST_LINE( Round(-0.5, 2)                  , -0.50            )
   TEST_LINE( Round(-0.5, -1)                 , 0                )
   TEST_LINE( Round(-0.5, -2)                 , 0                )
   TEST_LINE( Round(-0.50, 0)                 , -1               )
   TEST_LINE( Round(-0.50, 1)                 , -0.5             )
   TEST_LINE( Round(-0.50, 2)                 , -0.50            )
   TEST_LINE( Round(-0.50, -1)                , 0                )
   TEST_LINE( Round(-0.50, -2)                , 0                )
   TEST_LINE( Round(-0.55, 0)                 , -1               )
   TEST_LINE( Round(-0.55, 1)                 , -0.6             )
   TEST_LINE( Round(-0.55, 2)                 , -0.55            )
   TEST_LINE( Round(-0.55, -1)                , 0                )
   TEST_LINE( Round(-0.55, -2)                , 0                )
   TEST_LINE( Round(-0.557, 0)                , -1               )
   TEST_LINE( Round(-0.557, 1)                , -0.6             )
   TEST_LINE( Round(-0.557, 2)                , -0.56            )
   TEST_LINE( Round(-0.557, -1)               , 0                )
   TEST_LINE( Round(-0.557, -2)               , 0                )
   TEST_LINE( Round(-50, 0)                   , -50              )
   TEST_LINE( Round(-50, 1)                   , -50.0            )
   TEST_LINE( Round(-50, 2)                   , -50.00           )
   TEST_LINE( Round(-50, -1)                  , -50              )
   TEST_LINE( Round(-50, -2)                  , -100             )
   TEST_LINE( Round(-10.50, 0)                , -11              )
   TEST_LINE( Round(-10.50, -1)               , -10              )
   TEST_LINE( Round(-500000, 0)               , -500000          )
   TEST_LINE( Round(-500000, 1)               , -500000.0        )
   TEST_LINE( Round(-500000, 2)               , -500000.00       )
   TEST_LINE( Round(-500000, -1)              , -500000          )
   TEST_LINE( Round(-500000, -2)              , -500000          )
   TEST_LINE( Round(-500000, -2)              , -500000          )
   TEST_LINE( Round(-5000000000, 0)           , -5000000000      )
   TEST_LINE( Round(-5000000000, 1)           , -5000000000.0    )
   TEST_LINE( Round(-5000000000, 2)           , -5000000000.00   )
   TEST_LINE( Round(-5000000000, -1)          , -5000000000      )
   TEST_LINE( Round(-5000000000, -2)          , -5000000000      )
   TEST_LINE( Round(-5000000000, -2)          , -5000000000      )
   TEST_LINE( Round(-5000000000.129, 0)       , -5000000000      )
   TEST_LINE( Round(-5000000000.129, 1)       , -5000000000.1    )
   TEST_LINE( Round(-5000000000.129, 2)       , -5000000000.13   )
   TEST_LINE( Round(-5000000000.129, -1)      , -5000000000      )
   TEST_LINE( Round(-5000000000.129, -2)      , -5000000000      )
   TEST_LINE( Round(-5000000000.129, -2)      , -5000000000      )

   /* INT() */

   TEST_LINE( Int( NIL )                      , "E BASE 1090 Argument error INT F:S"  )
   TEST_LINE( Int( "A" )                      , "E BASE 1090 Argument error INT F:S" )
   TEST_LINE( Int( {} )                       , "E BASE 1090 Argument error INT F:S" )
   TEST_LINE( Int( 0 )                        , 0                                    )
   TEST_LINE( Int( 0.0 )                      , 0                                    )
   TEST_LINE( Int( 10 )                       , 10                                   )
   TEST_LINE( Int( snIntP )                   , 10                                   )
#ifdef __HARBOUR__
   TEST_LINE( Int( @snIntP )                  , 10                                   ) /* Bug in CA-Cl*pper, it returns: "E BASE 1090 Argument error INT F:S" */
#endif
   TEST_LINE( Int( -10 )                      , -10                                  )
   TEST_LINE( Int( 100000 )                   , 100000                               )
   TEST_LINE( Int( -100000 )                  , -100000                              )
   TEST_LINE( Int( 10.5 )                     , 10                                   )
   TEST_LINE( Int( -10.5 )                    , -10                                  )
   TEST_LINE( Str(Int(Val("100.290")))        , "100"                                )
   TEST_LINE( Str(Int(Val("  100.290")))      , "  100"                              )
   TEST_LINE( Str(Int(Val(" 100")))           , " 100"                               )
   TEST_LINE( Int(5000000000.90)              , 5000000000                           )
   TEST_LINE( Int(-5000000000.90)             , -5000000000                          )
   TEST_LINE( Int(5000000000)                 , 5000000000                           )
   TEST_LINE( Int(-5000000000)                , -5000000000                          )
   TEST_LINE( Int(5000000000) / 100000        , 50000                                )
   TEST_LINE( Int(-5000000000) / 100000       , -50000                               )

   /* MIN()/MAX() */

   TEST_LINE( Max(NIL, NIL)                           , "E BASE 1093 Argument error MAX F:S" )
   TEST_LINE( Max(10, NIL)                            , "E BASE 1093 Argument error MAX F:S" )
   TEST_LINE( Max(SToD("19800101"), 10)               , "E BASE 1093 Argument error MAX F:S" )
   TEST_LINE( Max(SToD("19800101"), SToD("19800101")) , SToD("19800101")                     )
   TEST_LINE( Max(SToD("19800102"), SToD("19800101")) , SToD("19800102")                     )
   TEST_LINE( Max(SToD("19800101"), SToD("19800102")) , SToD("19800102")                     )
   TEST_LINE( Max(snIntP, snLongP)                    , 100000                               )
#ifdef __HARBOUR__
   TEST_LINE( Max(@snIntP, @snLongP)                  , 100000                               ) /* Bug in CA-Cl*pper, it will return: "E BASE 1093 Argument error MAX F:S" */
#endif
   TEST_LINE( Min(NIL, NIL)                           , "E BASE 1092 Argument error MIN F:S" )
   TEST_LINE( Min(10, NIL)                            , "E BASE 1092 Argument error MIN F:S" )
   TEST_LINE( Min(SToD("19800101"), 10)               , "E BASE 1092 Argument error MIN F:S" )
   TEST_LINE( Min(SToD("19800101"), SToD("19800101")) , SToD("19800101")                     )
   TEST_LINE( Min(SToD("19800102"), SToD("19800101")) , SToD("19800101")                     )
   TEST_LINE( Min(SToD("19800101"), SToD("19800102")) , SToD("19800101")                     )
   TEST_LINE( Min(snIntP, snLongP)                    , 10                                   )
#ifdef __HARBOUR__
   TEST_LINE( Min(@snIntP, @snLongP)                  , 10                                   ) /* Bug in CA-Cl*pper, it will return: "E BASE 1092 Argument error MIN F:S" */
#endif

   /* Decimals handling */

   TEST_LINE( Str(Max(10, 12)             )   , "        12"                   )
   TEST_LINE( Str(Max(10.50, 10)          )   , "        10.50"                )
   TEST_LINE( Str(Max(10, 9.50)           )   , "        10"                   )
   TEST_LINE( Str(Max(100000, 10)         )   , "    100000"                   )
   TEST_LINE( Str(Max(20.50, 20.670)      )   , "        20.670"               )
   TEST_LINE( Str(Max(20.5125, 20.670)    )   , "        20.670"               )
   TEST_LINE( Str(Min(10, 12)             )   , "        10"                   )
   TEST_LINE( Str(Min(10.50, 10)          )   , "        10"                   )
   TEST_LINE( Str(Min(10, 9.50)           )   , "         9.50"                )
   TEST_LINE( Str(Min(100000, 10)         )   , "        10"                   )
   TEST_LINE( Str(Min(20.50, 20.670)      )   , "        20.50"                )
   TEST_LINE( Str(Min(20.5125, 20.670)    )   , "        20.5125"              )
   TEST_LINE( Str(Val("A")                )   , "0"                            )
   TEST_LINE( Str(Val("AAA0")             )   , "   0"                         )
   TEST_LINE( Str(Val("AAA2")             )   , "   0"                         )
   TEST_LINE( Str(Val("")                 )   , "         0"                   )
   TEST_LINE( Str(Val("0")                )   , "0"                            )
   TEST_LINE( Str(Val(" 0")               )   , " 0"                           )
   TEST_LINE( Str(Val("-0")               )   , " 0"                           )
   TEST_LINE( Str(Val("00")               )   , " 0"                           )
   TEST_LINE( Str(Val("1")                )   , "1"                            )
   TEST_LINE( Str(Val("15")               )   , "15"                           )
   TEST_LINE( Str(Val("200")              )   , "200"                          )
   TEST_LINE( Str(Val(" 200")             )   , " 200"                         )
   TEST_LINE( Str(Val("200 ")             )   , " 200"                         )
   TEST_LINE( Str(Val(" 200 ")            )   , "  200"                        )
   TEST_LINE( Str(Val("-200")             )   , "-200"                         )
   TEST_LINE( Str(Val(" -200")            )   , " -200"                        )
   TEST_LINE( Str(Val("-200 ")            )   , " -200"                        )
   TEST_LINE( Str(Val(" -200 ")           )   , "  -200"                       )
   TEST_LINE( Str(Val("15.0")             )   , "15.0"                         )
   TEST_LINE( Str(Val("15.00")            )   , "15.00"                        )
   TEST_LINE( Str(Val("15.000")           )   , "15.000"                       )
   TEST_LINE( Str(Val("15.001 ")          )   , "15.0010"                      )
   TEST_LINE( Str(Val("100000000")        )   , "100000000"                    )
   TEST_LINE( Str(Val("5000000000")       )   , "5000000000"                   )
   TEST_LINE( Str(10                      )   , "        10"                   )
   TEST_LINE( Str(15.0                    )   , "        15.0"                 )
   TEST_LINE( Str(10.1                    )   , "        10.1"                 )
   TEST_LINE( Str(15.00                   )   , "        15.00"                )
//   TEST_LINE( Str(Log(0)                  )   , "***********************"      )
   TEST_LINE( Str(100.2 * 200.12          )   , "     20052.024"               )
   TEST_LINE( Str(100.20 * 200.12         )   , "     20052.0240"              )
   TEST_LINE( Str(1000.2 * 200.12         )   , "    200160.024"               )
   TEST_LINE( Str(100/1000                )   , "         0.10"                )
   TEST_LINE( Str(100/100000              )   , "         0.00"                )
   TEST_LINE( Str(10 * 10                 )   , "       100"                   )
   TEST_LINE( Str(100 / 10                )   , "        10"                   )
   TEST_LINE( Str(100 / 13                )   , "         7.69"                )
   TEST_LINE( Str(100.0 / 10              )   , "        10.00"                )
   TEST_LINE( Str(100.0 / 10.00           )   , "        10.00"                )
   TEST_LINE( Str(100.0 / 10.000          )   , "        10.00"                )
   TEST_LINE( Str(100 / 10.00             )   , "        10.00"                )
   TEST_LINE( Str(100 / 10.000            )   , "        10.00"                )
   TEST_LINE( Str(100.00 / 10.0           )   , "        10.00"                )
   TEST_LINE( Str(sdDate - sdDateE        )   , "   2444240"                   )
   TEST_LINE( Str(sdDate - sdDate         )   , "         0"                   )
   TEST_LINE( Str(1234567890 * 1234567890 )   , " 1524157875019052100"         ) /* Bug in CA-Cl*pper, it returns: " 1524157875019052000" */

   RETURN NIL

STATIC FUNCTION Main_DATE()
   LOCAL cDate := "1999/11/25"

   /* YEAR() */

   TEST_LINE( Year(NIL)                       , "E BASE 1112 Argument error YEAR F:S"  )
   TEST_LINE( Year(100)                       , "E BASE 1112 Argument error YEAR F:S"  )
#ifdef __HARBOUR__
   TEST_LINE( Year(@sdDate)                   , 1980                                   ) /* Bug in CA-Cl*pper, it returns: "E BASE 1112 Argument error YEAR F:S" */
#endif
   TEST_LINE( Year(sdDate)                    , 1980                                   )
   TEST_LINE( Year(sdDateE)                   , 0                                      )
   TEST_LINE( Str(Year(SToD("19990905")))     , " 1999"                                )

   /* MONTH() */

   TEST_LINE( Month(NIL)                      , "E BASE 1113 Argument error MONTH F:S" )
   TEST_LINE( Month(100)                      , "E BASE 1113 Argument error MONTH F:S" )
#ifdef __HARBOUR__
   TEST_LINE( Month(@sdDate)                  , 1                                      ) /* Bug in CA-Cl*pper, it returns: "E BASE 1113 Argument error MONTH F:S" */
#endif
   TEST_LINE( Month(sdDate)                   , 1                                      )
   TEST_LINE( Month(sdDateE)                  , 0                                      )
   TEST_LINE( Str(Month(SToD("19990905")))    , "  9"                                  )

   /* DAY() */

   TEST_LINE( Day(NIL)                        , "E BASE 1114 Argument error DAY F:S"   )
   TEST_LINE( Day(100)                        , "E BASE 1114 Argument error DAY F:S"   )
#ifdef __HARBOUR__
   TEST_LINE( Day(@sdDate)                    , 1                                      ) /* Bug in CA-Cl*pper, it returns: "E BASE 1114 Argument error DAY F:S" */
#endif
   TEST_LINE( Day(sdDate)                     , 1                                      )
   TEST_LINE( Day(sdDateE)                    , 0                                      )
   TEST_LINE( Str(Day(SToD("19990905")))      , "  5"                                  )

   /* TIME() */

   TEST_LINE( Len(Time())                     , 8                                      )

   /* DOW() */

   TEST_LINE( Dow(NIL)                        , "E BASE 1115 Argument error DOW F:S"   )
   TEST_LINE( Dow(100)                        , "E BASE 1115 Argument error DOW F:S"   )
#ifdef __HARBOUR__
   TEST_LINE( Dow(@sdDate)                    , 3                                      ) /* Bug in CA-Cl*pper, it returns: "E BASE 1115 Argument error DOW F:S" */
#endif
   TEST_LINE( Dow(sdDate)                     , 3                                      )
   TEST_LINE( Dow(sdDateE)                    , 0                                      )
   TEST_LINE( Dow(SToD("20000222"))           , 3                                      )
   TEST_LINE( Dow(SToD("20000223"))           , 4                                      )
   TEST_LINE( Dow(SToD("20000224"))           , 5                                      )
   TEST_LINE( Dow(SToD("20000225"))           , 6                                      )
   TEST_LINE( Dow(SToD("20000226"))           , 7                                      )
   TEST_LINE( Dow(SToD("20000227"))           , 1                                      )
   TEST_LINE( Dow(SToD("20000228"))           , 2                                      )
   TEST_LINE( Dow(SToD("20000229"))           , 3                                      )
   TEST_LINE( Dow(SToD("20000230"))           , 0                                      )
   TEST_LINE( Dow(SToD("20000231"))           , 0                                      )
   TEST_LINE( Dow(SToD("20000301"))           , 4                                      )

   /* CMONTH() */

   TEST_LINE( CMonth(NIL)                     , "E BASE 1116 Argument error CMONTH F:S" )
   TEST_LINE( CMonth(100)                     , "E BASE 1116 Argument error CMONTH F:S" )
#ifdef __HARBOUR__
   TEST_LINE( CMonth(@sdDate)                 , "January"                               ) /* Bug in CA-Cl*pper, it returns: "E BASE 1116 Argument error CMONTH F:S" */
#endif
   TEST_LINE( CMonth(sdDate)                  , "January"                               )
   TEST_LINE( CMonth(sdDateE)                 , ""                                      )
   TEST_LINE( CMonth(SToD("19990101"))        , "January"                               )
   TEST_LINE( CMonth(SToD("19990201"))        , "February"                              )
   TEST_LINE( CMonth(SToD("19990301"))        , "March"                                 )
   TEST_LINE( CMonth(SToD("19990401"))        , "April"                                 )
   TEST_LINE( CMonth(SToD("19990501"))        , "May"                                   )
   TEST_LINE( CMonth(SToD("19990601"))        , "June"                                  )
   TEST_LINE( CMonth(SToD("19990701"))        , "July"                                  )
   TEST_LINE( CMonth(SToD("19990801"))        , "August"                                )
   TEST_LINE( CMonth(SToD("19990901"))        , "September"                             )
   TEST_LINE( CMonth(SToD("19991001"))        , "October"                               )
   TEST_LINE( CMonth(SToD("19991101"))        , "November"                              )
   TEST_LINE( CMonth(SToD("19991201"))        , "December"                              )

   /* CDOW() */

   TEST_LINE( CDow(NIL)                       , "E BASE 1117 Argument error CDOW F:S"  )
   TEST_LINE( CDow(100)                       , "E BASE 1117 Argument error CDOW F:S"  )
#ifdef __HARBOUR__
   TEST_LINE( CDow(@sdDate)                   , "Tuesday"                              ) /* Bug in CA-Cl*pper, it returns: "E BASE 1117 Argument error CDOW F:S" */
#endif
   TEST_LINE( CDow(sdDate)                    , "Tuesday"                              )
   TEST_LINE( CDow(sdDateE)                   , ""                                     )
   TEST_LINE( CDow(SToD("20000222"))          , "Tuesday"                              )
   TEST_LINE( CDow(SToD("20000223"))          , "Wednesday"                            )
   TEST_LINE( CDow(SToD("20000224"))          , "Thursday"                             )
   TEST_LINE( CDow(SToD("20000225"))          , "Friday"                               )
   TEST_LINE( CDow(SToD("20000226"))          , "Saturday"                             )
   TEST_LINE( CDow(SToD("20000227"))          , "Sunday"                               )
   TEST_LINE( CDow(SToD("20000228"))          , "Monday"                               )
   TEST_LINE( CDow(SToD("20000229"))          , "Tuesday"                              )
   TEST_LINE( CDow(SToD("20000230"))          , ""                                     )
   TEST_LINE( CDow(SToD("20000231"))          , ""                                     )
   TEST_LINE( CDow(SToD("20000301"))          , "Wednesday"                            )

   /* DTOC() */

   TEST_LINE( DToC(NIL)                       , "E BASE 1118 Argument error DTOC F:S"  )
   TEST_LINE( DToC(100)                       , "E BASE 1118 Argument error DTOC F:S"  )
   TEST_LINE( DToC("")                        , "E BASE 1118 Argument error DTOC F:S"  )
#ifdef __HARBOUR__
   TEST_LINE( DToC(@sdDate)                   , "1980.01.01"                           ) /* Bug in CA-Cl*pper, it returns: "E BASE 1118 Argument error DTOC F:S" */
#endif
   TEST_LINE( DToC(sdDate)                    , "1980.01.01"                           )
   TEST_LINE( DToC(sdDateE)                   , "    .  .  "                           )

   /* CTOD() */

   TEST_LINE( CToD(NIL)                       , "E BASE 1119 Argument error CTOD F:S"  )
   TEST_LINE( CToD(100)                       , "E BASE 1119 Argument error CTOD F:S"  )
   TEST_LINE( CToD("")                        , SToD("        ")                       )
#ifdef __HARBOUR__
   TEST_LINE( CToD(@cDate)                    , SToD("19991125")                       ) /* Bug in CA-Cl*pper, it returns: "E BASE 1119 Argument error CTOD F:S" */
#endif
   TEST_LINE( CToD(cDate)                     , SToD("19991125")                       )
   TEST_LINE( CToD("1999/11/25/10")           , SToD("19991125")                       )

   /* DTOS() */

   TEST_LINE( DToS(NIL)                       , "E BASE 1120 Argument error DTOS F:S"  )
   TEST_LINE( DToS(100)                       , "E BASE 1120 Argument error DTOS F:S"  )
#ifdef __HARBOUR__
   TEST_LINE( DToS(@sdDate)                   , "19800101"                             ) /* Bug in CA-Cl*pper, it returns: "E BASE 1120 Argument error DTOS F:S" */
#endif
   TEST_LINE( DToS(sdDate)                    , "19800101"                             )
   TEST_LINE( DToS(sdDateE)                   , "        "                             )

   RETURN NIL

STATIC FUNCTION Main_STRINGS()

   /* VAL() */

   TEST_LINE( Val( NIL )                      , "E BASE 1098 Argument error VAL F:S"   )
   TEST_LINE( Val( 10 )                       , "E BASE 1098 Argument error VAL F:S"   )

   /* CHR() */

   TEST_LINE( Chr( NIL )                      , "E BASE 1104 Argument error CHR F:S"   )
   TEST_LINE( Chr( "A" )                      , "E BASE 1104 Argument error CHR F:S"   )
   TEST_LINE( Chr( "ADDDDDD" )                , "E BASE 1104 Argument error CHR F:S"   )
   TEST_LINE( Chr( -10000000.0 )              , "�"                                    )
   TEST_LINE( Chr( -100000 )                  , "`"                                    )
   TEST_LINE( Chr( -65 )                      , "�"                                    )
   TEST_LINE( Chr( snIntP1 )                  , "A"                                    )
#ifdef __HARBOUR__
   TEST_LINE( Chr( @snIntP1 )                 , "A"                                    ) /* Bug in CA-Cl*pper, it returns: "E BASE 1104 Argument error CHR F:S" */
#endif
   TEST_LINE( Chr( 0 )                        , ""+Chr(0)+""                           )
   TEST_LINE( Chr( 0.1 )                      , ""+Chr(0)+""                           )
   TEST_LINE( Chr( -0.1 )                     , ""+Chr(0)+""                           )
   TEST_LINE( Chr( 66.4 )                     , "B"                                    )
   TEST_LINE( Chr( 66.5 )                     , "B"                                    )
   TEST_LINE( Chr( 66.6 )                     , "B"                                    )
   TEST_LINE( Chr( 255 )                      , "�"                                    )
   TEST_LINE( Chr( 256 )                      , ""+Chr(0)+""                           ) /* Due to a bug in CA-Cl*pper compiler optimizer, a wrong result will be calculated ar compile time: "" */
   TEST_LINE( Chr( ( 256 ) )                  , ""+Chr(0)+""                           ) /* Double paranthesis should be used here to avoid the optimizer of the CA-Cl*pper compiler */
   TEST_LINE( Chr( 257 )                      , ""                                    )
   TEST_LINE( Chr( ( 512 ) )                  , ""+Chr(0)+""                           ) /* Double paranthesis should be used here to avoid the optimizer of the CA-Cl*pper compiler */
   TEST_LINE( Chr( 1023 )                     , "�"                                    )
   TEST_LINE( Chr( ( 1024 ) )                 , ""+Chr(0)+""                           ) /* Double paranthesis should be used here to avoid the optimizer of the CA-Cl*pper compiler */
   TEST_LINE( Chr( 1025 )                     , ""                                    )
   TEST_LINE( Chr( 1000 )                     , "�"                                    )
   TEST_LINE( Chr( 100000 )                   , "�"                                    )
   TEST_LINE( Chr( 100000.0 )                 , "�"                                    )

   /* ASC() */

   TEST_LINE( Asc( NIL )                      , "E BASE 1107 Argument error ASC F:S" )
   TEST_LINE( Asc( 100 )                      , "E BASE 1107 Argument error ASC F:S" )
   TEST_LINE( Asc( 20000 )                    , "E BASE 1107 Argument error ASC F:S" )
   TEST_LINE( Asc( "HELLO" )                  , 72                                   )
   TEST_LINE( Asc( Chr(0) )                   , 0                                    )
   TEST_LINE( Asc( "a" )                      , 97                                   )
   TEST_LINE( Asc( "A" )                      , 65                                   )
   TEST_LINE( Asc( scString )                 , 72                                   )
#ifdef __HARBOUR__
   TEST_LINE( Asc( @scString )                , 72                                   ) /* Bug in CA-Cl*pper, it returns: "E BASE 1107 Argument error ASC F:S" */
#endif

   /* ISDIGIT() */

   TEST_LINE( IsDigit()                       , .F.              )
   TEST_LINE( IsDigit( 100 )                  , .F.              )
#ifdef __HARBOUR__
   TEST_LINE( IsDigit( @scString )            , .F.              ) /* Bug in CA-Cl*pper, it will always return .F. */
#endif
   TEST_LINE( IsDigit( "" )                   , .F.              )
   TEST_LINE( IsDigit( "A" )                  , .F.              )
   TEST_LINE( IsDigit( "AA" )                 , .F.              )
   TEST_LINE( IsDigit( "-" )                  , .F.              )
   TEST_LINE( IsDigit( "." )                  , .F.              )
   TEST_LINE( IsDigit( "0" )                  , .T.              )
   TEST_LINE( IsDigit( "9" )                  , .T.              )
   TEST_LINE( IsDigit( "123" )                , .T.              )
   TEST_LINE( IsDigit( "1" )                  , .T.              )
   TEST_LINE( IsDigit( "A1" )                 , .F.              )
   TEST_LINE( IsDigit( "1A" )                 , .T.              )

   /* ISALPHA() */

   TEST_LINE( IsAlpha()                       , .F.              )
   TEST_LINE( IsAlpha( 100 )                  , .F.              )
#ifdef __HARBOUR__
   TEST_LINE( IsAlpha( @scString )            , .T.              ) /* Bug in CA-Cl*pper, it will always return .F. */
#endif
   TEST_LINE( IsAlpha( "" )                   , .F.              )
   TEST_LINE( IsAlpha( "A" )                  , .T.              )
   TEST_LINE( IsAlpha( "AA" )                 , .T.              )
   TEST_LINE( IsAlpha( "-" )                  , .F.              )
   TEST_LINE( IsAlpha( "." )                  , .F.              )
   TEST_LINE( IsAlpha( "0" )                  , .F.              )
   TEST_LINE( IsAlpha( "9" )                  , .F.              )
   TEST_LINE( IsAlpha( "123" )                , .F.              )
   TEST_LINE( IsAlpha( "1" )                  , .F.              )
   TEST_LINE( IsAlpha( "A" )                  , .T.              )
   TEST_LINE( IsAlpha( "A1" )                 , .T.              )
   TEST_LINE( IsAlpha( "aa" )                 , .T.              )
   TEST_LINE( IsAlpha( "za" )                 , .T.              )
   TEST_LINE( IsAlpha( "Aa" )                 , .T.              )
   TEST_LINE( IsAlpha( "Za" )                 , .T.              )
   TEST_LINE( IsAlpha( "@"  )                 , .F.              )
   TEST_LINE( IsAlpha( "["  )                 , .F.              )
   TEST_LINE( IsAlpha( "`"  )                 , .F.              )
   TEST_LINE( IsAlpha( "{"  )                 , .F.              )

   /* ISUPPER() */

   TEST_LINE( IsUpper()                       , .F.              )
   TEST_LINE( IsUpper( 100 )                  , .F.              )
#ifdef __HARBOUR__
   TEST_LINE( IsUpper( @scString )            , .T.              ) /* Bug in CA-Cl*pper, it will always return .F. */
#endif
   TEST_LINE( IsUpper( "" )                   , .F.              )
   TEST_LINE( IsUpper( "6" )                  , .F.              )
   TEST_LINE( IsUpper( "A" )                  , .T.              )
   TEST_LINE( IsUpper( "AA" )                 , .T.              )
   TEST_LINE( IsUpper( "a" )                  , .F.              )
   TEST_LINE( IsUpper( "K" )                  , .T.              )
   TEST_LINE( IsUpper( "Z" )                  , .T.              )
   TEST_LINE( IsUpper( "z" )                  , .F.              )
   TEST_LINE( IsUpper( "�" )                  , .F.              )
   TEST_LINE( IsUpper( "�" )                  , .F.              )

   /* ISLOWER() */

   TEST_LINE( IsLower()                       , .F.              )
   TEST_LINE( IsLower( 100 )                  , .F.              )
#ifdef __HARBOUR__
   TEST_LINE( IsLower( @scString )            , .F.              ) /* Bug in CA-Cl*pper, it will always return .F. */
#endif
   TEST_LINE( IsLower( "" )                   , .F.              )
   TEST_LINE( IsLower( "6" )                  , .F.              )
   TEST_LINE( IsLower( "A" )                  , .F.              )
   TEST_LINE( IsLower( "AA" )                 , .F.              )
   TEST_LINE( IsLower( "a" )                  , .T.              )
   TEST_LINE( IsLower( "K" )                  , .F.              )
   TEST_LINE( IsLower( "Z" )                  , .F.              )
   TEST_LINE( IsLower( "z" )                  , .T.              )
   TEST_LINE( IsLower( "�" )                  , .F.              )
   TEST_LINE( IsLower( "�" )                  , .F.              )

   /* ALLTRIM() */

/* These lines will cause CA-Cl*pper 5.2e to trash memory and later crash, it was fixed in 5.3 */
#ifndef __CLIPPER__
   TEST_LINE( AllTrim( NIL )                  , "E BASE 2022 Argument error ALLTRIM F:S" ) /* CA-Cl*pper 5.2e/5.3 is not giving the same result for this one. */
   TEST_LINE( AllTrim( 100 )                  , "E BASE 2022 Argument error ALLTRIM F:S" ) /* CA-Cl*pper 5.2e/5.3 is not giving the same result for this one. */
#endif
#ifdef __HARBOUR__
   TEST_LINE( AllTrim(@scString)              , "HELLO"          ) /* CA-Cl*pper bug, it will terminate the program on this line. */
#endif
   TEST_LINE( AllTrim(scString)               , "HELLO"          )
   TEST_LINE( AllTrim("HELLO")                , "HELLO"          )
   TEST_LINE( AllTrim( "" )                   , ""               )
   TEST_LINE( AllTrim( "UA   " )              , "UA"             )
   TEST_LINE( AllTrim( "   UA" )              , "UA"             )
   TEST_LINE( AllTrim( "   UA  " )            , "UA"             )
   TEST_LINE( AllTrim( " "+Chr(0)+" UA  " )   , ""+Chr(0)+" UA"  )
   TEST_LINE( AllTrim( " "+Chr(9)+" UA  " )   , "UA"             )
   TEST_LINE( AllTrim( " "+Chr(9)+"U"+Chr(9)) , "U"+Chr(9)+""    )
   TEST_LINE( AllTrim( " "+Chr(9)+Chr(9))     , ""               )
   TEST_LINE( AllTrim( Chr(10)+"U"+Chr(10))   , "U"+Chr(10)+""   )
   TEST_LINE( AllTrim( Chr(13)+"U"+Chr(13))   , "U"+Chr(13)+""   )
   TEST_LINE( AllTrim( "A"+Chr(10))           , "A"+Chr(10)+""   )
   TEST_LINE( AllTrim( "A"+Chr(13))           , "A"+Chr(13)+""   )
   TEST_LINE( AllTrim( "  "+Chr(0)+"ABC"+Chr(0)+"  "), ""+Chr(0)+"ABC"+Chr(0)+"" )

   /* TRIM() */

   TEST_LINE( Trim( 100 )                     , "E BASE 1100 Argument error TRIM F:S" )
   TEST_LINE( Trim( NIL )                     , "E BASE 1100 Argument error TRIM F:S" )
#ifdef __HARBOUR__
   TEST_LINE( Trim(@scString)                 , "HELLO"                   ) /* CA-Cl*pper bug, it will throw an error here. */
#endif
   TEST_LINE( Trim(scString)                  , "HELLO"                   )
   TEST_LINE( Trim("HELLO")                   , "HELLO"                   )
   TEST_LINE( Trim( "" )                      , ""                        )
   TEST_LINE( Trim( "UA   " )                 , "UA"                      )
   TEST_LINE( Trim( "   UA" )                 , "   UA"                   )
   TEST_LINE( Trim( "   UA  " )               , "   UA"                   )
   TEST_LINE( Trim( " "+Chr(0)+" UA  " )      , " "+Chr(0)+" UA"          )
   TEST_LINE( Trim( " "+Chr(9)+" UA  " )      , " "+Chr(9)+" UA"          )
   TEST_LINE( Trim( " "+Chr(9)+"U"+Chr(9))    , " "+Chr(9)+"U"+Chr(9)+""  )
   TEST_LINE( Trim( " "+Chr(9)+Chr(9))        , " "+Chr(9)+""+Chr(9)+""   )
   TEST_LINE( Trim( Chr(10)+"U"+Chr(10))      , ""+Chr(10)+"U"+Chr(10)+"" )
   TEST_LINE( Trim( Chr(13)+"U"+Chr(13))      , ""+Chr(13)+"U"+Chr(13)+"" )
   TEST_LINE( Trim( "A"+Chr(10))              , "A"+Chr(10)+""            )
   TEST_LINE( Trim( "A"+Chr(13))              , "A"+Chr(13)+""            )
   TEST_LINE( Trim( "  "+Chr(0)+"ABC"+Chr(0)+"  "), "  "+Chr(0)+"ABC"+Chr(0)+"" )

   /* RTRIM() */

   TEST_LINE( RTrim( 100 )                    , "E BASE 1100 Argument error TRIM F:S" )
   TEST_LINE( RTrim( NIL )                    , "E BASE 1100 Argument error TRIM F:S" )
#ifdef __HARBOUR__
   TEST_LINE( RTrim(@scString)                , "HELLO"                   ) /* CA-Cl*pper bug, it will throw an error here. */
#endif
   TEST_LINE( RTrim(scString)                 , "HELLO"                   )
   TEST_LINE( RTrim("HELLO")                  , "HELLO"                   )
   TEST_LINE( RTrim( "" )                     , ""                        )
   TEST_LINE( RTrim( "UA   " )                , "UA"                      )
   TEST_LINE( RTrim( "   UA" )                , "   UA"                   )
   TEST_LINE( RTrim( "   UA  " )              , "   UA"                   )
   TEST_LINE( RTrim( " "+Chr(0)+" UA  " )     , " "+Chr(0)+" UA"          )
   TEST_LINE( RTrim( " "+Chr(9)+" UA  " )     , " "+Chr(9)+" UA"          )
   TEST_LINE( RTrim( " "+Chr(9)+"U"+Chr(9))   , " "+Chr(9)+"U"+Chr(9)+""  )
   TEST_LINE( RTrim( " "+Chr(9)+Chr(9))       , " "+Chr(9)+""+Chr(9)+""   )
   TEST_LINE( RTrim( Chr(10)+"U"+Chr(10))     , ""+Chr(10)+"U"+Chr(10)+"" )
   TEST_LINE( RTrim( Chr(13)+"U"+Chr(13))     , ""+Chr(13)+"U"+Chr(13)+"" )
   TEST_LINE( RTrim( "A"+Chr(10))             , "A"+Chr(10)+""            )
   TEST_LINE( RTrim( "A"+Chr(13))             , "A"+Chr(13)+""            )
   TEST_LINE( RTrim( "  "+Chr(0)+"ABC"+Chr(0)+"  "), "  "+Chr(0)+"ABC"+Chr(0)+"" )

   /* LTRIM() */

   TEST_LINE( LTrim( 100 )                    , "E BASE 1101 Argument error LTRIM F:S" )
   TEST_LINE( LTrim( NIL )                    , "E BASE 1101 Argument error LTRIM F:S" )
#ifdef __HARBOUR__
   TEST_LINE( LTrim(@scString)                , "HELLO"                   ) /* CA-Cl*pper bug, it will throw an error here. */
#endif
   TEST_LINE( LTrim(scString)                 , "HELLO"                   )
   TEST_LINE( LTrim("HELLO")                  , "HELLO"                   )
   TEST_LINE( LTrim( "" )                     , ""                        )
   TEST_LINE( LTrim( "UA   " )                , "UA   "                   )
   TEST_LINE( LTrim( "   UA" )                , "UA"                      )
   TEST_LINE( LTrim( "   UA  " )              , "UA  "                    )
   TEST_LINE( LTrim( " "+Chr(0)+" UA  " )     , ""+Chr(0)+" UA  "         )
   TEST_LINE( LTrim( " "+Chr(9)+" UA  " )     , "UA  "                    )
   TEST_LINE( LTrim( " "+Chr(9)+"U"+Chr(9))   , "U"+Chr(9)+""             )
   TEST_LINE( LTrim( " "+Chr(9)+Chr(9))       , ""                        )
   TEST_LINE( LTrim( Chr(10)+"U"+Chr(10))     , "U"+Chr(10)+""            )
   TEST_LINE( LTrim( Chr(13)+"U"+Chr(13))     , "U"+Chr(13)+""            )
   TEST_LINE( LTrim( "A"+Chr(10))             , "A"+Chr(10)+""            )
   TEST_LINE( LTrim( "A"+Chr(13))             , "A"+Chr(13)+""            )
   TEST_LINE( LTrim( "  "+Chr(0)+"ABC"+Chr(0)+"  "), ""+Chr(0)+"ABC"+Chr(0)+"  " )

   /* STRTRAN() */

   /* TODO: STRTRAN() */

/* NOTE: It seems like CA-Cl*pper 5.x is not aware of the BREAK return value of
         the error handler, so the error is thrown, but we can't catch it.
         This bug is fixed in CA-Clipper 5.3 [vszel] */
#ifndef __CLIPPER__
   TEST_LINE( StrTran()                       , "E BASE 1126 Argument error STRTRAN F:S" ) /* CA-Cl*pper bug, it will exit on this */
   TEST_LINE( StrTran( NIL )                  , "E BASE 1126 Argument error STRTRAN F:S" ) /* CA-Cl*pper bug, it will exit on this */
   TEST_LINE( StrTran( 100 )                  , "E BASE 1126 Argument error STRTRAN F:S" ) /* CA-Cl*pper bug, it will exit on this */
   TEST_LINE( StrTran( "AA", 1 )              , "E BASE 1126 Argument error STRTRAN F:S" ) /* CA-Cl*pper bug, it will exit on this */
#endif
   TEST_LINE( StrTran( "AA", "A" )            , "" )
   TEST_LINE( StrTran( "AA", "A", "1" )       , "11" )
   TEST_LINE( StrTran( "AA", "A", "1", "2" )  , "11" )

   /* UPPER() */

   TEST_LINE( Upper( scString )               , "HELLO"                                )
#ifdef __HARBOUR__
   TEST_LINE( Upper( @scString )              , "HELLO"                                ) /* Bug in CA-Cl*pper, it will return argument error */
#endif
   TEST_LINE( Upper( 100 )                    , "E BASE 1102 Argument error UPPER F:S" )
   TEST_LINE( Upper( "" )                     , ""                                     )
   TEST_LINE( Upper( " " )                    , " "                                    )
   TEST_LINE( Upper( "2" )                    , "2"                                    )
   TEST_LINE( Upper( "{" )                    , "{"                                    )
   TEST_LINE( Upper( Chr(0) )                 , ""+Chr(0)+""                           )
   TEST_LINE( Upper( "aAZAZa" )               , "AAZAZA"                               )
   TEST_LINE( Upper( "AazazA" )               , "AAZAZA"                               )
   TEST_LINE( Upper( "Aaz"+Chr(0)+"zA" )      , "AAZ"+Chr(0)+"ZA"                      )
   TEST_LINE( Upper( "z" )                    , "Z"                                    )
   TEST_LINE( Upper( "��" )                   , "��"                                   )
   TEST_LINE( Upper( "H�rbor 8-) �" )         , "H�RBOR 8-) �"                         )

   /* LOWER() */

   TEST_LINE( Lower( scString )               , "hello"                                )
#ifdef __HARBOUR__
   TEST_LINE( Lower( @scString )              , "hello"                                ) /* Bug in CA-Cl*pper, it will return argument error */
#endif
   TEST_LINE( Lower( 100 )                    , "E BASE 1103 Argument error LOWER F:S" )
   TEST_LINE( Lower( "" )                     , ""                                     )
   TEST_LINE( Lower( " " )                    , " "                                    )
   TEST_LINE( Lower( "2" )                    , "2"                                    )
   TEST_LINE( Lower( "{" )                    , "{"                                    )
   TEST_LINE( Lower( Chr(0) )                 , ""+Chr(0)+""                           )
   TEST_LINE( Lower( "aAZAZa" )               , "aazaza"                               )
   TEST_LINE( Lower( "AazazA" )               , "aazaza"                               )
   TEST_LINE( Lower( "Aaz"+Chr(0)+"zA" )      , "aaz"+Chr(0)+"za"                      )
   TEST_LINE( Lower( "z" )                    , "z"                                    )
   TEST_LINE( Lower( "��" )                   , "��"                                   )
   TEST_LINE( Lower( "H�rbor 8-) �" )         , "h�rbor 8-) �"                         )

   /* AT() */

   TEST_LINE( At(90, 100)                     , "E BASE 1108 Argument error AT F:S" )
   TEST_LINE( At("", 100)                     , "E BASE 1108 Argument error AT F:S" )
   TEST_LINE( At(100, "")                     , "E BASE 1108 Argument error AT F:S" )
   TEST_LINE( At("", "")                      , 0                ) /* Bug in CA-Cl*ppers compiler optimalizer, it will return 1 */
   TEST_LINE( At("", "ABCDEF")                , 0                ) /* Bug in CA-Cl*ppers compiler optimalizer, it will return 1 */
   TEST_LINE( At(scStringE, "ABCDEF")         , 0                )
   TEST_LINE( At("ABCDEF", "")                , 0                )
   TEST_LINE( At("AB", "AB")                  , 1                )
   TEST_LINE( At("AB", "AAB")                 , 2                )
   TEST_LINE( At("A", "ABCDEF")               , 1                )
   TEST_LINE( At("F", "ABCDEF")               , 6                )
   TEST_LINE( At("D", "ABCDEF")               , 4                )
   TEST_LINE( At("X", "ABCDEF")               , 0                )
   TEST_LINE( At("AB", "ABCDEF")              , 1                )
   TEST_LINE( At("AA", "ABCDEF")              , 0                )
   TEST_LINE( At("ABCDEF", "ABCDEF")          , 1                )
   TEST_LINE( At("BCDEF", "ABCDEF")           , 2                )
   TEST_LINE( At("BCDEFG", "ABCDEF")          , 0                )
   TEST_LINE( At("ABCDEFG", "ABCDEF")         , 0                )
   TEST_LINE( At("FI", "ABCDEF")              , 0                )

   /* RAT() */

   TEST_LINE( RAt(90, 100)                    , 0                )
   TEST_LINE( RAt("", 100)                    , 0                )
   TEST_LINE( RAt(100, "")                    , 0                )
   TEST_LINE( RAt("", "")                     , 0                )
   TEST_LINE( RAt("", "ABCDEF")               , 0                )
   TEST_LINE( RAt("ABCDEF", "")               , 0                )
   TEST_LINE( RAt("AB", "AB")                 , 1                )
   TEST_LINE( RAt("AB", "AAB")                , 2                )
   TEST_LINE( RAt("AB", "ABAB")               , 3                )
   TEST_LINE( RAt("A", "ABCADEF")             , 4                )
   TEST_LINE( RAt("A", "ABCADEFA")            , 8                )
   TEST_LINE( RAt("A", "ABCDEFA")             , 7                )
   TEST_LINE( RAt("A", "ABCDEF")              , 1                )
   TEST_LINE( RAt("F", "ABCDEF")              , 6                )
   TEST_LINE( RAt("D", "ABCDEF")              , 4                )
   TEST_LINE( RAt("X", "ABCDEF")              , 0                )
   TEST_LINE( RAt("AB", "ABCDEF")             , 1                )
   TEST_LINE( RAt("AA", "ABCDEF")             , 0                )
   TEST_LINE( RAt("ABCDEF", "ABCDEF")         , 1                )
   TEST_LINE( RAt("BCDEF", "ABCDEF")          , 2                )
   TEST_LINE( RAt("BCDEFG", "ABCDEF")         , 0                )
   TEST_LINE( RAt("ABCDEFG", "ABCDEF")        , 0                )
   TEST_LINE( RAt("FI", "ABCDEF")             , 0                )

   /* REPLICATE() */

#ifdef __HARBOUR__
   TEST_LINE( Replicate("XXX", 2000000000)    , "E BASE 1234 String overflow REPLICATE F:S" )
#else
   TEST_LINE( Replicate("XXX", 30000)         , "E BASE 1234 String overflow REPLICATE F:S" )
#endif
   TEST_LINE( Replicate(200  , 0 )            , "E BASE 1106 Argument error REPLICATE F:S" )
   TEST_LINE( Replicate(""   , 10 )           , "" )
   TEST_LINE( Replicate(""   , 0 )            , "" )
   TEST_LINE( Replicate("A"  , "B" )          , "E BASE 1106 Argument error REPLICATE F:S" )
   TEST_LINE( Replicate("A"  , 1 )            , "A"                                        )
   TEST_LINE( Replicate("A"  , 2 )            , "AA"                                       )
   TEST_LINE( Replicate("HE", 3 )             , "HEHEHE"                                   )
   TEST_LINE( Replicate("HE", 3.1 )           , "HEHEHE"                                   )
   TEST_LINE( Replicate("HE", 3.5 )           , "HEHEHE"                                   )
   TEST_LINE( Replicate("HE", 3.7 )           , "HEHEHE"                                   )
   TEST_LINE( Replicate("HE", -3 )            , "" )
   TEST_LINE( Replicate("H"+Chr(0), 2 )       , "H"+Chr(0)+"H"+Chr(0)+"" )

   /* SPACE() */

   TEST_LINE( Space( "A" )                    , "E BASE 1105 Argument error SPACE F:S" )
   TEST_LINE( Space( 0 )                      , "" )
   TEST_LINE( Space( -10 )                    , "" )
   TEST_LINE( Space( 10 )                     , "          " )
   TEST_LINE( Space( 10.2 )                   , "          " )
   TEST_LINE( Space( 10.5 )                   , "          " )
   TEST_LINE( Space( 10.7 )                   , "          " )

   /* SUBSTR() */

   TEST_LINE( SubStr(100     , 0, -1)         , "E BASE 1110 Argument error SUBSTR F:S" )
   TEST_LINE( SubStr("abcdef", 1, "a")        , "E BASE 1110 Argument error SUBSTR F:S" )
   TEST_LINE( SubStr("abcdef", "a")           , "E BASE 1110 Argument error SUBSTR F:S" )
   TEST_LINE( SubStr("abcdef", "a", 1)        , "E BASE 1110 Argument error SUBSTR F:S" )
   TEST_LINE( SubStr("abcdef", 0, -1)         , ""               )
   TEST_LINE( SubStr("abcdef", 0, 0)          , ""               )
   TEST_LINE( SubStr("abcdef", 0, 1)          , "a"              )
   TEST_LINE( SubStr("abcdef", 0, 7)          , "abcdef"         )
   TEST_LINE( SubStr("abcdef", 0)             , "abcdef"         )
   TEST_LINE( SubStr("abcdef", 2, -1)         , ""               )
   TEST_LINE( SubStr("abcdef", 2, 0)          , ""               )
   TEST_LINE( SubStr("abcdef", 2, 1)          , "b"              )
   TEST_LINE( SubStr("abcdef", 2, 7)          , "bcdef"          )
   TEST_LINE( SubStr("abcdef", 2)             , "bcdef"          )
   TEST_LINE( SubStr("abcdef", -2, -1)        , ""               )
   TEST_LINE( SubStr("abcdef", -2, 0)         , ""               )
   TEST_LINE( SubStr("abcdef", -2, 1)         , "e"              )
   TEST_LINE( SubStr("abcdef", -2, 7)         , "ef"             )
   TEST_LINE( SubStr("abcdef", -2)            , "ef"             )
   TEST_LINE( SubStr("abcdef", 10, -1)        , ""               )
   TEST_LINE( SubStr("abcdef", 10, 0)         , ""               )
   TEST_LINE( SubStr("abcdef", 10, 1)         , ""               )
   TEST_LINE( SubStr("abcdef", 10, 7)         , ""               )
   TEST_LINE( SubStr("abcdef", 10)            , ""               )
   TEST_LINE( SubStr("abcdef", -10, -1)       , ""               )
   TEST_LINE( SubStr("abcdef", -10, 0)        , ""               )
   TEST_LINE( SubStr("abcdef", -10, 1)        , "a"              )
   TEST_LINE( SubStr("abcdef", -10, 7)        , "abcdef"         )
   TEST_LINE( SubStr("abcdef", -10, 15)       , "abcdef"         )
   TEST_LINE( SubStr("abcdef", -10)           , "abcdef"         )
   TEST_LINE( SubStr("ab" + Chr(0) + "def", 2, 3) , "b" + Chr(0) + "d" )
   TEST_LINE( SubStr("abc" + Chr(0) + "def", 3, 1) , "c" )
   TEST_LINE( SubStr("abc" + Chr(0) + "def", 4, 1) , "" + Chr(0) + "" )
   TEST_LINE( SubStr("abc" + Chr(0) + "def", 5, 1) , "d" )

   /* LEFT() */

   TEST_LINE( Left(100     , -10)             , "E BASE 1124 Argument error LEFT F:S" )
   TEST_LINE( Left("abcdef", "A")             , "E BASE 1124 Argument error LEFT F:S" )
   TEST_LINE( Left("abcdef", -10)             , ""               )
   TEST_LINE( Left("abcdef", -2)              , ""               )
   TEST_LINE( Left("abcdef", 0)               , ""               )
   TEST_LINE( Left("abcdef", 2)               , "ab"             )
   TEST_LINE( Left("abcdef", 10)              , "abcdef"         )
   TEST_LINE( Left("ab" + Chr(0) + "def", 5)  , "ab" + Chr(0) + "de" )

   /* RIGHT() */

   TEST_LINE( Right(100     , -10)            , ""               )
   TEST_LINE( Right("abcdef", "A")            , ""               )
   TEST_LINE( Right("abcdef", -10)            , ""               )
   TEST_LINE( Right("abcdef", -2)             , ""               )
   TEST_LINE( Right("abcdef", 0)              , ""               )
   TEST_LINE( Right("abcdef", 2)              , "ef"             )
   TEST_LINE( Right("abcdef", 10)             , "abcdef"         )
   TEST_LINE( Right("ab" + Chr(0) + "def", 5) , "b" + Chr(0) + "def" )

   /* PADR() */

   TEST_LINE( Pad(NIL, 5)                     , ""               )
   TEST_LINE( Pad(.T., 5)                     , ""               )
   TEST_LINE( Pad(10, 5)                      , "10   "          )
   TEST_LINE( Pad(10.2, 5)                    , "10.2 "          )
   TEST_LINE( Pad(100000, 8)                  , "100000  "       )
   TEST_LINE( Pad(100000, 8, "-")             , "100000--"       )
   TEST_LINE( Pad(-100000, 8, "-")            , "-100000-"       )
   TEST_LINE( Pad(5000000000, 15)             , "5000000000     ")
   TEST_LINE( Pad(SToD("19800101"), 12)       , "1980.01.01  "   )
   TEST_LINE( Pad(Year(SToD("19800101")), 5)  , "1980 "          )
   TEST_LINE( Pad(Day(SToD("19800101")), 5)   , "1    "          )
#ifdef __HARBOUR__
   TEST_LINE( Pad(@scString, 10)              , "HELLO     "     ) /* Bug in CA-Cl*pper, it will return "" */
   TEST_LINE( Pad(scString, @snIntP)          , "HELLO     "     ) /* Bug in CA-Cl*pper, it will return "" */
#endif
   TEST_LINE( Pad("abcdef", "A")              , ""               )
   TEST_LINE( Pad("abcdef", -5)               , ""               )
   TEST_LINE( Pad("abcdef", 0)                , ""               )
   TEST_LINE( Pad("abcdef", 5)                , "abcde"          )
   TEST_LINE( Pad("abcdef", 10)               , "abcdef    "     )
   TEST_LINE( Pad("abcdef", 10, "")           , "abcdef"+Chr(0)+""+Chr(0)+""+Chr(0)+""+Chr(0)+"" )
   TEST_LINE( Pad("abcdef", 10, "1")          , "abcdef1111"     )
   TEST_LINE( Pad("abcdef", 10, "12")         , "abcdef1111"     )

   /* PADR() */

   TEST_LINE( PadR(NIL, 5)                    , ""               )
   TEST_LINE( PadR(.T., 5)                    , ""               )
   TEST_LINE( PadR(10, 5)                     , "10   "          )
   TEST_LINE( PadR(10.2, 5)                   , "10.2 "          )
   TEST_LINE( PadR(100000, 8)                 , "100000  "       )
   TEST_LINE( PadR(100000, 8, "-")            , "100000--"       )
   TEST_LINE( PadR(-100000, 8, "-")           , "-100000-"       )
   TEST_LINE( PadR(SToD("19800101"), 12)      , "1980.01.01  "   )
   TEST_LINE( PadR(Year(SToD("19800101")), 5) , "1980 "          )
   TEST_LINE( PadR(Day(SToD("19800101")), 5)  , "1    "          )
#ifdef __HARBOUR__
   TEST_LINE( PadR(@scString, 10)             , "HELLO     "     ) /* Bug in CA-Cl*pper, it will return "" */
   TEST_LINE( PadR(scString, @snIntP)         , "HELLO     "     ) /* Bug in CA-Cl*pper, it will return "" */
#endif
   TEST_LINE( PadR("abcdef", "A")             , ""               )
   TEST_LINE( PadR("abcdef", -5)              , ""               )
   TEST_LINE( PadR("abcdef", 0)               , ""               )
   TEST_LINE( PadR("abcdef", 5)               , "abcde"          )
   TEST_LINE( PadR("abcdef", 10)              , "abcdef    "     )
   TEST_LINE( PadR("abcdef", 10, "")          , "abcdef"+Chr(0)+""+Chr(0)+""+Chr(0)+""+Chr(0)+"" )
   TEST_LINE( PadR("abcdef", 10, "1")         , "abcdef1111"     )
   TEST_LINE( PadR("abcdef", 10, "12")        , "abcdef1111"     )

   /* PADL() */

   TEST_LINE( PadL(NIL, 5)                    , ""               )
   TEST_LINE( PadL(.T., 5)                    , ""               )
   TEST_LINE( PadL(10, 5)                     , "   10"          )
   TEST_LINE( PadL(10.2, 5)                   , " 10.2"          )
   TEST_LINE( PadL(100000, 8)                 , "  100000"       )
   TEST_LINE( PadL(100000, 8, "-")            , "--100000"       )
   TEST_LINE( PadL(-100000, 8, "-")           , "--100000"       )
   TEST_LINE( PadL(SToD("19800101"), 12)      , "  1980.01.01"   )
   TEST_LINE( PadL(Year(SToD("19800101")), 5) , " 1980"          )
   TEST_LINE( PadL(Day(SToD("19800101")), 5)  , "    1"          )
#ifdef __HARBOUR__
   TEST_LINE( PadL(@scString, 10)             , "     HELLO"     ) /* Bug in CA-Cl*pper, it will return "" */
   TEST_LINE( PadL(scString, @snIntP)         , "     HELLO"     ) /* Bug in CA-Cl*pper, it will return "" */
#endif
   TEST_LINE( PadL("abcdef", "A")             , ""               )
   TEST_LINE( PadL("abcdef", -5)              , ""               )
   TEST_LINE( PadL("abcdef", 0)               , ""               )
   TEST_LINE( PadL("abcdef", 5)               , "abcde"          ) /* QUESTION: CA-Cl*pper "bug", should return: "bcdef" ? */
   TEST_LINE( PadL("abcdef", 10)              , "    abcdef"     )
   TEST_LINE( PadL("abcdef", 10, "")          , ""+Chr(0)+""+Chr(0)+""+Chr(0)+""+Chr(0)+"abcdef" )
   TEST_LINE( PadL("abcdef", 10, "1")         , "1111abcdef"     )
   TEST_LINE( PadL("abcdef", 10, "12")        , "1111abcdef"     )

   /* PADC() */

   TEST_LINE( PadC(NIL, 5)                    , ""               )
   TEST_LINE( PadC(.T., 5)                    , ""               )
   TEST_LINE( PadC(10, 5)                     , " 10  "          )
   TEST_LINE( PadC(10.2, 5)                   , "10.2 "          )
   TEST_LINE( PadC(100000, 8)                 , " 100000 "       )
   TEST_LINE( PadC(100000, 8, "-")            , "-100000-"       )
   TEST_LINE( PadC(-100000, 8, "-")           , "-100000-"       )
   TEST_LINE( PadC(SToD("19800101"), 12)      , " 1980.01.01 "   )
   TEST_LINE( PadC(Year(SToD("19800101")), 5) , "1980 "          )
   TEST_LINE( PadC(Day(SToD("19800101")), 5)  , "  1  "          )
#ifdef __HARBOUR__
   TEST_LINE( PadC(@scString, 10)             , "  HELLO   "     ) /* Bug in CA-Cl*pper, it will return "" */
   TEST_LINE( PadC(scString, @snIntP)         , "  HELLO   "     ) /* Bug in CA-Cl*pper, it will return "" */
#endif
   TEST_LINE( PadC("abcdef", "A")             , ""               )
   TEST_LINE( PadC("abcdef", -5)              , ""               )
   TEST_LINE( PadC("abcdef", 0)               , ""               )
   TEST_LINE( PadC("abcdef", 2)               , "ab"             ) /* QUESTION: CA-Cl*pper "bug", should return: "cd" ? */
   TEST_LINE( PadC("abcdef", 5)               , "abcde"          )
   TEST_LINE( PadC("abcdef", 10)              , "  abcdef  "     )
   TEST_LINE( PadC("abcdef", 10, "")          , ""+Chr(0)+""+Chr(0)+"abcdef"+Chr(0)+""+Chr(0)+"" )
   TEST_LINE( PadC("abcdef", 10, "1")         , "11abcdef11"     )
   TEST_LINE( PadC("abcdef", 10, "12")        , "11abcdef11"     )

   /* STUFF() */

   TEST_LINE( Stuff()                                          , ""                        )
   TEST_LINE( Stuff( 100 )                                     , ""                        )
   TEST_LINE( Stuff("ABCDEF", -6, -5, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -6, -2, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -6,  0, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -6, 10, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -6, 30, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -2, -5, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -2, -2, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -2,  0, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -2, 10, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", -2, 30, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF",  0, -5, NIL)                     , ""                        )
   TEST_LINE( Stuff("ABCDEF",  0, -2, "xyz")                   , "xyz"                     )
   TEST_LINE( Stuff("ABCDEF",  0,  0, "xyz")                   , "xyzABCDEF"               )
   TEST_LINE( Stuff("ABCDEF",  0, 10, "xyz")                   , "xyz"                     )
   TEST_LINE( Stuff("ABCDEF",  0, 30, "xyz")                   , "xyz"                     )
   TEST_LINE( Stuff("ABCDEF",  1, -5, "xyz")                   , "xyz"                     )
   TEST_LINE( Stuff("ABCDEF",  1, -2, "xyz")                   , "xyz"                     )
   TEST_LINE( Stuff("ABCDEF",  1,  0, "xyz")                   , "xyzABCDEF"               )
   TEST_LINE( Stuff("ABCDEF",  1, 10, "xyz")                   , "xyz"                     )
   TEST_LINE( Stuff("ABCDEF",  1, 30, "xyz")                   , "xyz"                     )
   TEST_LINE( Stuff("ABCDEF",  2,  0, "xyz")                   , "AxyzBCDEF"               )
   TEST_LINE( Stuff("ABCDEF",  2,  3, ""   )                   , "AEF"                     )
   TEST_LINE( Stuff("ABCDEF",  2,  3, "xyz")                   , "AxyzEF"                  )
   TEST_LINE( Stuff("ABCDEF",  2,  2, "")                      , "ADEF"                    )
   TEST_LINE( Stuff("ABCDEF",  2, -5, "xyz")                   , "Axyz"                    )
   TEST_LINE( Stuff("ABCDEF",  2, -2, "xyz")                   , "Axyz"                    )
   TEST_LINE( Stuff("ABCDEF",  2,  1, "xyz")                   , "AxyzCDEF"                )
   TEST_LINE( Stuff("ABCDEF",  2,  4, "xyz")                   , "AxyzF"                   )
   TEST_LINE( Stuff("ABCDEF",  2, 10, "xyz")                   , "Axyz"                    )
   TEST_LINE( Stuff("ABCDEF",  2, 30, "xyz")                   , "Axyz"                    )
   TEST_LINE( Stuff("ABCDEF", 30, -5, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", 30, -2, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", 30,  0, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", 30, 10, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff("ABCDEF", 30, 30, "xyz")                   , "ABCDEFxyz"               )
   TEST_LINE( Stuff(@scString        ,  2,  3, "xyz")          , "HxyzO"                   )
   TEST_LINE( Stuff("ABC"+Chr(0)+"EF",  2,  3, "xyz")          , "AxyzEF"                  )
   TEST_LINE( Stuff("ABCE"+Chr(0)+"F",  2,  3, "xyz")          , "Axyz"+Chr(0)+"F"         )
   TEST_LINE( Stuff("ABC"+Chr(0)+"EF",  2,  3, "x"+Chr(0)+"z") , "Ax"+Chr(0)+"zEF"         )

   /* STR() */

   TEST_LINE( Str(NIL)                        , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( Str("A", 10, 2)                 , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( Str(100, 10, "A")               , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( Str(100, 10, NIL)               , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( Str(100, NIL, NIL)              , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( Str(5000000000.0)               , "5000000000.0"   )
   TEST_LINE( Str(5000000000)                 , " 5000000000"    )
   TEST_LINE( Str(-5000000000.0)              , "         -5000000000.0" )
   TEST_LINE( Str(-5000000000)                , "         -5000000000" )
   TEST_LINE( Str(10)                         , "        10"     )
   TEST_LINE( Str(10.0)                       , "        10.0"   )
   TEST_LINE( Str(10.00)                      , "        10.00"  )
   TEST_LINE( Str(10.50)                      , "        10.50"  )
   TEST_LINE( Str(100000)                     , "    100000"     )
   TEST_LINE( Str(-10)                        , "       -10"     )
   TEST_LINE( Str(-10.0)                      , "       -10.0"   )
   TEST_LINE( Str(-10.00)                     , "       -10.00"  )
   TEST_LINE( Str(-10.50)                     , "       -10.50"  )
   TEST_LINE( Str(-100000)                    , "   -100000"     )
   TEST_LINE( Str(10, 5)                      , "   10"          )
   TEST_LINE( Str(10.0, 5)                    , "   10"          )
   TEST_LINE( Str(10.00, 5)                   , "   10"          )
   TEST_LINE( Str(10.50, 5)                   , "   11"          )
   TEST_LINE( Str(100000, 5)                  , "*****"          )
   TEST_LINE( Str(100000, 8)                  , "  100000"       )
   TEST_LINE( Str(-10, 5)                     , "  -10"          )
   TEST_LINE( Str(-10.0, 5)                   , "  -10"          )
   TEST_LINE( Str(-10.00, 5)                  , "  -10"          )
   TEST_LINE( Str(-10.50, 5)                  , "  -11"          )
   TEST_LINE( Str(-100000, 5)                 , "*****"          )
   TEST_LINE( Str(-100000, 6)                 , "******"         )
   TEST_LINE( Str(-100000, 8)                 , " -100000"       )
   TEST_LINE( Str(10, -5)                     , "        10"     )
   TEST_LINE( Str(10.0, -5)                   , "        10"     )
   TEST_LINE( Str(10.00, -5)                  , "        10"     )
   TEST_LINE( Str(10.50, -5)                  , "        11"     )
   TEST_LINE( Str(100000, -5)                 , "    100000"     )
   TEST_LINE( Str(100000, -8)                 , "    100000"     )
   TEST_LINE( Str(-10, -5)                    , "       -10"     )
   TEST_LINE( Str(-10.0, -5)                  , "       -10"     )
   TEST_LINE( Str(-10.00, -5)                 , "       -10"     )
   TEST_LINE( Str(-10.50, -5)                 , "       -11"     )
   TEST_LINE( Str(-100000, -5)                , "   -100000"     )
   TEST_LINE( Str(-100000, -6)                , "   -100000"     )
   TEST_LINE( Str(-100000, -8)                , "   -100000"     )
   TEST_LINE( Str(10, 5, 0)                   , "   10"          )
   TEST_LINE( Str(10.0, 5, 0)                 , "   10"          )
   TEST_LINE( Str(10.00, 5, 0)                , "   10"          )
   TEST_LINE( Str(10.50, 5, 0)                , "   11"          )
   TEST_LINE( Str(100000, 5, 0)               , "*****"          )
   TEST_LINE( Str(-10, 5, 0)                  , "  -10"          )
   TEST_LINE( Str(-10.0, 5, 0)                , "  -10"          )
   TEST_LINE( Str(-10.00, 5, 0)               , "  -10"          )
   TEST_LINE( Str(-10.50, 5, 0)               , "  -11"          )
   TEST_LINE( Str(-100000, 5, 0)              , "*****"          )
   TEST_LINE( Str(-100000, 6, 0)              , "******"         )
   TEST_LINE( Str(-100000, 8, 0)              , " -100000"       )
   TEST_LINE( Str(10, 5, 1)                   , " 10.0"          )
   TEST_LINE( Str(10.0, 5, 1)                 , " 10.0"          )
   TEST_LINE( Str(10.00, 5, 1)                , " 10.0"          )
   TEST_LINE( Str(10.50, 5, 1)                , " 10.5"          )
   TEST_LINE( Str(100000, 5, 1)               , "*****"          )
   TEST_LINE( Str(-10, 5, 1)                  , "-10.0"          )
   TEST_LINE( Str(-10.0, 5, 1)                , "-10.0"          )
   TEST_LINE( Str(-10.00, 5, 1)               , "-10.0"          )
   TEST_LINE( Str(-10.50, 5, 1)               , "-10.5"          )
   TEST_LINE( Str(-100000, 5, 1)              , "*****"          )
   TEST_LINE( Str(-100000, 6, 1)              , "******"         )
   TEST_LINE( Str(-100000, 8, 1)              , "********"       )
   TEST_LINE( Str(10, 5, -1)                  , "   10"          )
   TEST_LINE( Str(10.0, 5, -1)                , "   10"          )
   TEST_LINE( Str(10.00, 5, -1)               , "   10"          )
   TEST_LINE( Str(10.50, 5, -1)               , "   11"          )
   TEST_LINE( Str(100000, 5, -1)              , "*****"          )
   TEST_LINE( Str(-10, 5, -1)                 , "  -10"          )
   TEST_LINE( Str(-10.0, 5, -1)               , "  -10"          )
   TEST_LINE( Str(-10.00, 5, -1)              , "  -10"          )
   TEST_LINE( Str(-10.50, 5, -1)              , "  -11"          )
   TEST_LINE( Str(-100000, 5, -1)             , "*****"          )
   TEST_LINE( Str(-100000, 6, -1)             , "******"         )
   TEST_LINE( Str(-100000, 8, -1)             , " -100000"       )

   /* STRZERO() */

   TEST_LINE( StrZero(NIL)                    , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( StrZero("A", 10, 2)             , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( StrZero(100, 10, "A")           , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( StrZero(100, 10, NIL)           , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( StrZero(100, NIL, NIL)          , "E BASE 1099 Argument error STR F:S" )
   TEST_LINE( StrZero(10)                     , "0000000010"     )
   TEST_LINE( StrZero(10.0)                   , "0000000010.0"   )
   TEST_LINE( StrZero(10.00)                  , "0000000010.00"  )
   TEST_LINE( StrZero(10.50)                  , "0000000010.50"  )
   TEST_LINE( StrZero(100000)                 , "0000100000"     )
   TEST_LINE( StrZero(-10)                    , "-000000010"     )
   TEST_LINE( StrZero(-10.0)                  , "-000000010.0"   )
   TEST_LINE( StrZero(-10.00)                 , "-000000010.00"  )
   TEST_LINE( StrZero(-10.50)                 , "-000000010.50"  )
   TEST_LINE( StrZero(-100000)                , "-000100000"     )
   TEST_LINE( StrZero(10, 5)                  , "00010"          )
   TEST_LINE( StrZero(10.0, 5)                , "00010"          )
   TEST_LINE( StrZero(10.00, 5)               , "00010"          )
   TEST_LINE( StrZero(10.50, 5)               , "00011"          )
   TEST_LINE( StrZero(100000, 5)              , "*****"          )
   TEST_LINE( StrZero(100000, 8)              , "00100000"       )
   TEST_LINE( StrZero(-10, 5)                 , "-0010"          )
   TEST_LINE( StrZero(-10.0, 5)               , "-0010"          )
   TEST_LINE( StrZero(-10.00, 5)              , "-0010"          )
   TEST_LINE( StrZero(-10.50, 5)              , "-0011"          )
   TEST_LINE( StrZero(-100000, 5)             , "*****"          )
   TEST_LINE( StrZero(-100000, 6)             , "******"         )
   TEST_LINE( StrZero(-100000, 8)             , "-0100000"       )
   TEST_LINE( StrZero(10, -5)                 , "0000000010"     )
   TEST_LINE( StrZero(10.0, -5)               , "0000000010"     )
   TEST_LINE( StrZero(10.00, -5)              , "0000000010"     )
   TEST_LINE( StrZero(10.50, -5)              , "0000000011"     )
   TEST_LINE( StrZero(100000, -5)             , "0000100000"     )
   TEST_LINE( StrZero(100000, -8)             , "0000100000"     )
   TEST_LINE( StrZero(-10, -5)                , "-000000010"     )
   TEST_LINE( StrZero(-10.0, -5)              , "-000000010"     )
   TEST_LINE( StrZero(-10.00, -5)             , "-000000010"     )
   TEST_LINE( StrZero(-10.50, -5)             , "-000000011"     )
   TEST_LINE( StrZero(-100000, -5)            , "-000100000"     )
   TEST_LINE( StrZero(-100000, -6)            , "-000100000"     )
   TEST_LINE( StrZero(-100000, -8)            , "-000100000"     )
   TEST_LINE( StrZero(10, 5, 0)               , "00010"          )
   TEST_LINE( StrZero(10.0, 5, 0)             , "00010"          )
   TEST_LINE( StrZero(10.50, 5, 0)            , "00011"          )
   TEST_LINE( StrZero(100000, 5, 0)           , "*****"          )
   TEST_LINE( StrZero(-10, 5, 0)              , "-0010"          )
   TEST_LINE( StrZero(-10.0, 5, 0)            , "-0010"          )
   TEST_LINE( StrZero(-10.00, 5, 0)           , "-0010"          )
   TEST_LINE( StrZero(-10.50, 5, 0)           , "-0011"          )
   TEST_LINE( StrZero(-100000, 5, 0)          , "*****"          )
   TEST_LINE( StrZero(-100000, 6, 0)          , "******"         )
   TEST_LINE( StrZero(-100000, 8, 0)          , "-0100000"       )
   TEST_LINE( StrZero(10, 5, 1)               , "010.0"          )
   TEST_LINE( StrZero(10.0, 5, 1)             , "010.0"          )
   TEST_LINE( StrZero(10.50, 5, 1)            , "010.5"          )
   TEST_LINE( StrZero(100000, 5, 1)           , "*****"          )
   TEST_LINE( StrZero(-10, 5, 1)              , "-10.0"          )
   TEST_LINE( StrZero(-10.0, 5, 1)            , "-10.0"          )
   TEST_LINE( StrZero(-10.00, 5, 1)           , "-10.0"          )
   TEST_LINE( StrZero(-10.50, 5, 1)           , "-10.5"          )
   TEST_LINE( StrZero(-100000, 5, 1)          , "*****"          )
   TEST_LINE( StrZero(-100000, 6, 1)          , "******"         )
   TEST_LINE( StrZero(-100000, 8, 1)          , "********"       )
   TEST_LINE( StrZero(10, 5, -1)              , "00010"          )
   TEST_LINE( StrZero(10.0, 5, -1)            , "00010"          )
   TEST_LINE( StrZero(10.50, 5, -1)           , "00011"          )
   TEST_LINE( StrZero(100000, 5, -1)          , "*****"          )
   TEST_LINE( StrZero(-10, 5, -1)             , "-0010"          )
   TEST_LINE( StrZero(-10.0, 5, -1)           , "-0010"          )
   TEST_LINE( StrZero(-10.00, 5, -1)          , "-0010"          )
   TEST_LINE( StrZero(-10.50, 5, -1)          , "-0011"          )
   TEST_LINE( StrZero(-100000, 5, -1)         , "*****"          )
   TEST_LINE( StrZero(-100000, 6, -1)         , "******"         )
   TEST_LINE( StrZero(-100000, 8, -1)         , "-0100000"       )

   /* TRANSFORM() */

   TEST_LINE( Transform( NIL       , NIL        )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( NIL       , ""         )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( NIL       , "@"        )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( {}        , NIL        )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( {}        , ""         )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( {}        , "@"        )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( ErrorNew(), NIL        )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( ErrorNew(), ""         )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( ErrorNew(), "@"        )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( {|| NIL } , NIL        )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( {|| NIL } , ""         )          , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( {|| NIL } , "@"        )          , "E BASE 1122 Argument error TRANSFORM F:S" )

   TEST_LINE( Transform( "", "" )                          , ""                                         )
   TEST_LINE( Transform( "", "@" )                         , ""                                         )
   TEST_LINE( Transform( "", NIL )                         , ""                                         )
   TEST_LINE( Transform( "", 100 )                         , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( "hello", "" )                     , "hello"                                    )
   TEST_LINE( Transform( "hello", "@" )                    , "hello"                                    )
   TEST_LINE( Transform( "hello", NIL )                    , "hello"                                    )
   TEST_LINE( Transform( "hello", 100 )                    , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( 100.2, "" )                       , "       100.2"                             )
   TEST_LINE( Transform( 100.2, "@" )                      , "       100.2"                             )
   TEST_LINE( Transform( 100.2, NIL )                      , "       100.2"                             )
   TEST_LINE( Transform( 100.2, 100 )                      , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( 100.20, "" )                      , "       100.20"                            )
   TEST_LINE( Transform( 100.20, "@" )                     , "       100.20"                            )
   TEST_LINE( Transform( 100.20, NIL )                     , "       100.20"                            )
   TEST_LINE( Transform( 100.20, 100 )                     , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( Val("100.2"), "" )                , "100.2"                                    )
   TEST_LINE( Transform( Val("100.2"), "@" )               , "100.2"                                    )
   TEST_LINE( Transform( Val("100.2"), NIL )               , "100.2"                                    )
   TEST_LINE( Transform( Val("100.2"), 100 )               , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( Val("100.20"), "" )               , "100.20"                                   )
// TEST_LINE( Transform( Val("100.20"), "@" )              , "100.20"                                   )
   TEST_LINE( Transform( Val("100.20"), NIL )              , "100.20"                                   )
   TEST_LINE( Transform( Val("100.20"), 100 )              , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( sdDate, "" )                      , "1980.01.01"                               )
   TEST_LINE( Transform( sdDate, "@" )                     , "1980.01.01"                               )
   TEST_LINE( Transform( sdDate, NIL )                     , "1980.01.01"                               )
   TEST_LINE( Transform( sdDate, 100 )                     , "E BASE 1122 Argument error TRANSFORM F:S" )
   TEST_LINE( Transform( .T., "" )                         , "T"                                        )
   TEST_LINE( Transform( .T., "@" )                        , "T"                                        )
   TEST_LINE( Transform( .F., NIL )                        , "F"                                        )
   TEST_LINE( Transform( .F., 100 )                        , "E BASE 1122 Argument error TRANSFORM F:S" )

   TEST_LINE( Transform( scStringM , "!!!!!"    )          , "HELLO"                       )
   TEST_LINE( Transform( scStringM , "@!"       )          , "HELLO"                       )
#ifdef __HARBOUR__
   TEST_LINE( Transform( @scStringM, "!!!!!"    )          , "HELLO"                       ) /* Bug in CA-Cl*pper, it returns: "E BASE 1122 Argument error TRANSFORM F:S" */
   TEST_LINE( Transform( @scStringM, "@!"       )          , "HELLO"                       ) /* Bug in CA-Cl*pper, it returns: "E BASE 1122 Argument error TRANSFORM F:S" */
#endif
   TEST_LINE( Transform( scStringM , "" )                  , "Hello"                       )
   TEST_LINE( Transform( scStringM , NIL )                 , "Hello"                       )
   TEST_LINE( Transform( scStringM , 100 )                 , "E BASE 1122 Argument error TRANSFORM F:S" )

   TEST_LINE( Transform("abcdef", "@! !lkm!")              , "ABkmE"                       )
   TEST_LINE( Transform("abcdefghijklmnopqrstuvwxyz", "@! 1234567890"), "12345678I0" )
   TEST_LINE( Transform("abcdefghijklmnopqrstuvwxyzabcdefg", "@! abcdefghijklmnopqrstuvwxyzabcdefg"), "AbcdefghijkLmNopqrstuvwXYzAbcdefg" )
   TEST_LINE( Transform("abcdefghijklmnopqrstuvwxyz", "@! `~!@#$% ^&*()_+-={}\|;':")  , "`~C@E$% ^&*()_+-={}\|;':" )
   TEST_LINE( Transform("abcdefghijklmnopqrstuvwxyz", "@! ,./<>?")                    , ",./<>?" )
   TEST_LINE( Transform("hello", " @!")                    , " @L"   )

   TEST_LINE( Transform("abcdef", "@R! !lkm!")              , "ABkmC"                       )
   TEST_LINE( Transform("abcdefghijklmnopqrstuvwxyz", "@R! 1234567890"), "12345678A0" )
   TEST_LINE( Transform("abcdefghijklmnopqrstuvwxyzabcdefg", "@R! abcdefghijklmnopqrstuvwxyzabcdefg"), "AbcdefghijkBmCopqrstuvwDNzFbcdefg" )
   TEST_LINE( Transform("abcdefghijklmnopqrstuvwxyz", "@R! `~!@#$% ^&*()_+-={}\|;':")  , "`~A@B$% ^&*()_+-={}\|;':"         )
   TEST_LINE( Transform("abcdefghijklmnopqrstuvwxyz", "@R! ,./<>?")                    , ",./<>?ABCDEFGHIJKLMNOPQRSTUVWXYZ" )
   TEST_LINE( Transform("hello", " @R!")                   , " @RL"  )

   TEST_LINE( Transform("abc", "@R !!!!")                  , "ABC "  )
   TEST_LINE( Transform("abc", "@R XXXX")                  , "abc "  )
   TEST_LINE( Transform("abc", "@R !!")                    , "AB"    )
   TEST_LINE( Transform("abc", "@R XX")                    , "ab"    )
   TEST_LINE( Transform("abc", "@!R !!!!")                 , "ABC "  )
   TEST_LINE( Transform("abc", "@!R XXXX")                 , "ABC "  )
   TEST_LINE( Transform("abc", "@!R !!")                   , "AB"    )
   TEST_LINE( Transform("abc", "@!R XX")                   , "AB"    )

   TEST_LINE( Transform( "Hallo   ", "!!!!!"    )          , "HALLO"                       )
   TEST_LINE( Transform( "Hallo   ", "!!A!!"    )          , "HAlLO"                       )
   TEST_LINE( Transform( "Hallo   ", "!!A9!"    )          , "HAllO"                       )
   TEST_LINE( Transform( "Hallo   ", "!QA9!"    )          , "HQllO"                       )
   TEST_LINE( Transform( "Hallo   ", "ZQA9!"    )          , "ZQllO"                       )
   TEST_LINE( Transform( "Hall"    , "ZQA9!"    )          , "ZQll"                        )
   TEST_LINE( Transform( "Hallo   ", "!AAA"     )          , "Hall"                        )
   TEST_LINE( Transform( "Hallo   ", "@!"       )          , "HALLO   "                    )
   TEST_LINE( Transform( "Hallo   ", "@! AA"    )          , "HA"                          )
   TEST_LINE( Transform( "Hallo   ", "@R"       )          , "Hallo   "                    )
   TEST_LINE( Transform( "Hallo   ", "@Z"       )          , "        "                    )
   TEST_LINE( Transform( "Hallo   ", "@R !!"    )          , "HA"                          )
   TEST_LINE( Transform( "Hi"      , "@R !!!"   )          , "HI "                         )
   TEST_LINE( Transform( "Hallo   ", ""         )          , "Hallo   "                    )

   TEST_LINE( Transform( .T.       , ""         )          , "T"                           )
   TEST_LINE( Transform( .F.       , ""         )          , "F"                           )
   TEST_LINE( Transform( .T.       , "L"        )          , "T"                           )
   TEST_LINE( Transform( .F.       , "L"        )          , "F"                           )
   TEST_LINE( Transform( .T.       , "Y"        )          , "Y"                           )
   TEST_LINE( Transform( .F.       , "Y"        )          , "N"                           )
   TEST_LINE( Transform( .T.       , "X"        )          , "X"                           )
   TEST_LINE( Transform( .F.       , "#"        )          , "F"                           )
   TEST_LINE( Transform( .T.       , "X!"       )          , "X"                           )
   TEST_LINE( Transform( .F.       , "@R Y"     )          , "N"                           )
   TEST_LINE( Transform( .T.       , "@R X!"    )          , "X!T"                         )

   TEST_LINE( Transform( SToD("20000101") , "@B"         ) , "2000.01.01"                  )
   TEST_LINE( Transform( SToD("19901214") , "99/99/9999" ) , "1990.12.14"                  )
   TEST_LINE( Transform( SToD("19901202") , "99.99.9999" ) , "1990.12.02"                  )
   TEST_LINE( Transform( SToD("")         , "99/99/9999" ) , "    .  .  "                  )
   TEST_LINE( Transform( SToD("19901202") , "99/99/99"   ) , "1990.12.02"                  )
   TEST_LINE( Transform( SToD("19901214") , "99-99-99"   ) , "1990.12.14"                  )
   TEST_LINE( Transform( SToD("20040430") , "99.99.99"   ) , "2004.04.30"                  )
   TEST_LINE( Transform( SToD("")         , "99/99/99"   ) , "    .  .  "                  )
   TEST_LINE( Transform( SToD("19920101") , "THISWRNG"   ) , "1992.01.01"                  )
   TEST_LINE( Transform( SToD("19350605") , "999/99/9"   ) , "1935.06.05"                  )
   TEST_LINE( Transform( SToD("19101112") , "9#-9#/##"   ) , "1910.11.12"                  )
   TEST_LINE( Transform( SToD("19920101") , ""           ) , "1992.01.01"                  )
   TEST_LINE( Transform( SToD("19920101") , "DO THIS "   ) , "1992.01.01"                  )
   TEST_LINE( Transform( SToD("19920102") , "@E"         ) , "02/01/1992"                  ) /* Bug in CA-Cl*pper, it returns: "2.91901.02" */
   TEST_LINE( Transform( 1234             , "@D 9999"    ) , "1234.00.0 "                  )
   TEST_LINE( Transform( 1234             , "@BD 9999"   ) , "1234.00.0 "                  )

   SET CENTURY OFF

   TEST_LINE( Transform( SToD("20000101") , "@B"         ) , "00.01.01"                    )
   TEST_LINE( Transform( SToD("19901214") , "99/99/9999" ) , "90.12.14"                    )
   TEST_LINE( Transform( SToD("19901202") , "99.99.9999" ) , "90.12.02"                    )
   TEST_LINE( Transform( SToD("")         , "99/99/9999" ) , "  .  .  "                    )
   TEST_LINE( Transform( SToD("19901202") , "99/99/99"   ) , "90.12.02"                    )
   TEST_LINE( Transform( SToD("19901214") , "99-99-99"   ) , "90.12.14"                    )
   TEST_LINE( Transform( SToD("20040430") , "99.99.99"   ) , "04.04.30"                    )
   TEST_LINE( Transform( SToD("")         , "99/99/99"   ) , "  .  .  "                    )
   TEST_LINE( Transform( SToD("19920101") , "THISWRNG"   ) , "92.01.01"                    )
   TEST_LINE( Transform( SToD("19350605") , "999/99/9"   ) , "35.06.05"                    )
   TEST_LINE( Transform( SToD("19101112") , "9#-9#/##"   ) , "10.11.12"                    )
   TEST_LINE( Transform( SToD("19920101") , ""           ) , "92.01.01"                    )
   TEST_LINE( Transform( SToD("19920101") , "DO THIS "   ) , "92.01.01"                    )
   TEST_LINE( Transform( SToD("19920102") , "@E"         ) , "02/01/92"                    ) /* Bug in CA-Cl*pper, it returns: "01.92.02" */
   TEST_LINE( Transform( 1234             , "@D 9999"    ) , "**.**.* "                    )
   TEST_LINE( Transform( 1234             , "@BD 9999"   ) , "**.**.* "                    )

   SET CENTURY ON

   TEST_LINE( Transform( 1         , "@b"          )       , "1         "                  )
   TEST_LINE( Transform( 1         , "@B"          )       , "1         "                  )
   TEST_LINE( Transform( 1.0       , "@B"          )       , "1.0         "                )
   TEST_LINE( Transform( 15        , "9999"        )       , "  15"                        )
   TEST_LINE( Transform( 1.5       , "99.99"       )       , " 1.50"                       )
   TEST_LINE( Transform( 1.5       , "9999"        )       , "   2"                        )
   TEST_LINE( Transform( 15        , "####"        )       , "  15"                        )
   TEST_LINE( Transform( 1.5       , "##.##"       )       , " 1.50"                       )
   TEST_LINE( Transform( 1.5       , "####"        )       , "   2"                        )
   TEST_LINE( Transform( 15        , " AX##"       )       , " AX15"                       )
   TEST_LINE( Transform( 1.5       , "!9XPA.9"     )       , "!1XPA.5"                     )
   TEST_LINE( Transform( -15       , "9999"        )       , " -15"                        )
   TEST_LINE( Transform( -1.5      , "99.99"       )       , "-1.50"                       )
   TEST_LINE( Transform( -15       , "$999"        )       , "$-15"                        )
   TEST_LINE( Transform( -1.5      , "*9.99"       )       , "-1.50"                       )
   TEST_LINE( Transform( 41        , "$$$9"        )       , "$$41"                        )
   TEST_LINE( Transform( 41        , "***9"        )       , "**41"                        )
   TEST_LINE( Transform( 15000     , "9999"        )       , "****"                        )
   TEST_LINE( Transform( 15000     , "99,999"      )       , "15,000"                      )
   TEST_LINE( Transform( 1500      , "99,999"      )       , " 1,500"                      )
   TEST_LINE( Transform( 150       , "99,999"      )       , "   150"                      )
   TEST_LINE( Transform( 150       , "99,99"       )       , " 1,50"                       )
   TEST_LINE( Transform( 41        , "@Z 9999"     )       , "  41"                        )
   TEST_LINE( Transform( 0         , "@Z 9999"     )       , "    "                        )
#ifdef __HARBOUR__
   TEST_LINE( Transform( 41        , "@0 9999"     )       , "0041"                        ) /* Extension in Harbour, in CA-Cl*pper it should return: "  41" */
   TEST_LINE( Transform( 0         , "@0 9999"     )       , "0000"                        ) /* Extension in Harbour, in CA-Cl*pper it should return: "   0" */
#endif
   TEST_LINE( Transform( 41        , "@B 9999"     )       , "41  "                        )
   TEST_LINE( Transform( 41        , "@B 99.9"     )       , "41.0"                        )
   TEST_LINE( Transform( 7         , "@B 99.9"     )       , "7.0 "                        )
   TEST_LINE( Transform( 7         , "@C 99.9"     )       , " 7.0 CR"                     )
   TEST_LINE( Transform( -7        , "@C 99.9"     )       , "-7.0"                        )
   TEST_LINE( Transform( 7         , "@X 99.9"     )       , " 7.0"                        )
   TEST_LINE( Transform( -7        , "@X 99.9"     )       , " 7.0 DB"                     )
   TEST_LINE( Transform( 7         , "@( 99.9"     )       , " 7.0"                        )
   TEST_LINE( Transform( -7        , "@( 99.9"     )       , "(7.0)"                       )
   TEST_LINE( Transform( 7         , "9X9Z5.9"     )       , " X7Z5.0"                     )
   TEST_LINE( Transform( -7        , "@R 9X9^"     )       , "-X7^"                        )
   TEST_LINE( Transform( -7        , "9X9^"        )       , "-X7^"                        )
   TEST_LINE( Transform( 1         , "@R 9HI!"     )       , "1HI!"                        )
   TEST_LINE( Transform( 1         , "9HI!"        )       , "1HI!"                        )
   TEST_LINE( Transform( -12       , "@( 99"       )       , "(*)"                         ) /* Bug in CA-Cl*pper, it returns: "(2)" */
   TEST_LINE( Transform( 12        , "@( 99"       )       , "12"                          )
   TEST_LINE( Transform( 1         , ""            )       , "         1"                  )
   TEST_LINE( Transform( 32768     , ""            )       , "     32768"                  )
   TEST_LINE( Transform( -20       , ""            )       , "       -20"                  )
   TEST_LINE( Transform( 1048576   , ""            )       , "   1048576"                  )
   TEST_LINE( Transform( 21.65     , ""            )       , "        21.65"               )
   TEST_LINE( Transform( -3.33     , ""            )       , "        -3.33"               )
   TEST_LINE( Transform( -1234     , "@( 9999"     )       , "(***)"                       ) /* Bug in CA-Cl*pper, it returns: "(234)" */
   TEST_LINE( Transform( -1234     , "@B 9999"     )       , "****"                        )
   TEST_LINE( Transform( -1234     , "@B( 9999"    )       , "(***)"                       ) /* Bug in CA-Cl*pper, it returns: "(234)" */
   TEST_LINE( Transform( 1234      , "@E 9,999.99" )       , "1.234,00"                    )
   TEST_LINE( Transform( 12.2      , "@E 9,999.99" )       , "   12,20"                    )
   TEST_LINE( Transform( -1234     , "@X 9999"     )       , "1234 DB"                     )
   TEST_LINE( Transform( -1234     , "@BX 9999"    )       , "1234 DB"                     )
   TEST_LINE( Transform( 1234      , "@B 9999"     )       , "1234"                        )
   TEST_LINE( Transform( 1234      , "@BX 9999"    )       , "1234"                        )
   TEST_LINE( Transform( 0         , "@Z 9999"     )       , "    "                        )
   TEST_LINE( Transform( 0         , "@BZ 9999"    )       , "    "                        )
   TEST_LINE( Transform( 2334      , "Xxxxx: #####")       , "Xxxxx:  2334"                )

   RETURN NIL

#ifdef __HARBOUR__

STATIC FUNCTION New_STRINGS()

   TEST_LINE( HB_ValToStr( 4 )                   , "         4"    )
   TEST_LINE( HB_ValToStr( 4.0 / 2 )             , "         2.00" )
   TEST_LINE( HB_ValToStr( "String" )            , "String"        )
   TEST_LINE( HB_ValToStr( SToD( "20010101" ) )  , "2001.01.01"    )
   TEST_LINE( HB_ValToStr( NIL )                 , "NIL"           )
   TEST_LINE( HB_ValToStr( .F. )                 , ".F."           )
   TEST_LINE( HB_ValToStr( .T. )                 , ".T."           )

   RETURN NIL

STATIC FUNCTION Long_STRINGS()

   TEST_LINE( RIGHT( SPACE( 64 * 1024 - 5 ) + "12345 7890", 10                      ), "12345 7890"                                 )
   TEST_LINE( LEN( SPACE( 81910 ) + "1234567890"                                    ), 81920                                        )
   TEST_LINE( ( "1234567890" + SPACE( 810910 ) ) - ( "1234567890" + SPACE( 810910 ) ), "12345678901234567890" + SPACE( 810910 * 2 ) )

   RETURN NIL

#endif

/* NOTE: The order of the tests is relevant here, so don't
         rearrange them. */

STATIC FUNCTION Main_FILE()
   LOCAL cFileName := "$$FILEIO.TMP"
   LOCAL nFlags

   LOCAL cBuff4   := Space( 4 )
   LOCAL cBuff100 := Space( 100 )

   LOCAL fhnd

   nFlags := FC_NORMAL
   fhnd := FCreate( cFileName, nFlags )

   TEST_LINE( FError()                                                 , 0 )
   TEST_LINE( TESTFIER( FWrite( fhnd, ">1234567890<" ) )               , "E: 0      R: 12"     )
   TEST_LINE( TESTFIER( FWrite( fhnd, "(123" + Chr(0) + "4567890)" ) ) , "E: 0      R: 13"     )
   TEST_LINE( TESTFIER( FSeek( fhnd ) )                                , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 5 ) )                             , "E: 0      R: 5"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -1, FS_SET ) )                    , "E: 25     R: 5"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -10, FS_SET ) )                   , "E: 25     R: 5"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -100, FS_SET ) )                  , "E: 25     R: 5"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "!" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 1 ) )                             , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "A" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 2, FS_SET ) )                     , "E: 0      R: 2"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "B" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 3, FS_RELATIVE ) )                , "E: 0      R: 6"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "C" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -1, FS_RELATIVE ) )               , "E: 0      R: 6"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "D" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 3, FS_END ) )                     , "E: 0      R: 28"     )
   TEST_LINE( TESTFIER( FWrite( fhnd, "E" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -1, FS_END ) )                    , "E: 0      R: 28"     )
   TEST_LINE( TESTFIER( FWrite( fhnd, "F" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0 ) )                             , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FRead( fhnd, mnLongP ) )                       , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FRead( fhnd, @mnLongP, 2 ) )                   , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FRead( fhnd, cBuff4 ) )                        , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FRead( fhnd, cBuff4, 2 ) )                     , "E: 0      R: 0"      )
#ifdef __CLIPPER__
// TEST_LINE( TESTFIER( FRead( fhnd, @cBuff4, Len( cBuff4 ) + 1 ) )    , "E: 0      R: 0"      )
#endif
   TEST_LINE( TESTFIER( FRead( fhnd, @cBuff4, 1000 ) )                 , 'E: 0      R: 0'                    )
   TEST_LINE( TESTFIER( FRead( fhnd, @cBuff4, 3 ) )                    , 'E: 0      R: 3'                    )
   TEST_LINE( TESTFIER( FRead( fhnd, @cBuff100, 100 ) )                , 'E: 0      R: 26'                   )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0 ) )                             , 'E: 0      R: 0'                    )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 4 ) )                          , 'E: 0      R: ">AB3"'               )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0 ) )                             , 'E: 0      R: 0'                    )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 100 ) )                        , 'E: 0      R: ">AB34!D7890<(123"'   )
   TEST_LINE( TESTFIER( FSeek( fhnd, 1, FS_RELATIVE ) )                , 'E: 0      R: 30'                   )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 2 ) )                          , 'E: 0      R: ""'                   )
   TEST_LINE( TESTFIER( FSeek( fhnd, -4, FS_END ) )                    , 'E: 0      R: 25'                   )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 1 ) )                          , 'E: 0      R: ""'                   )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 20 ) )                         , 'E: 0      R: ""'                   )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0, FS_END ) )                     , 'E: 0      R: 29'                   )
   TEST_LINE( TESTFIER( FWrite( fhnd, "_-_-_-_-_-_-_" ) )              , 'E: 0      R: 13'                   )
   TEST_LINE( TESTFIER( FSeek( fhnd, -4, FS_END ) )                    , 'E: 0      R: 38'                   )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 1 ) )                          , 'E: 0      R: "-"'                  )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 20 ) )                         , 'E: 0      R: "_-_"'                )
   TEST_LINE( TESTFIER( FSeek( fhnd, 3, FS_END ) )                     , 'E: 0      R: 45'                   )
   TEST_LINE( TESTFIER( FWrite( fhnd, "V" ) )                          , 'E: 0      R: 1'                    )
   TEST_LINE( TESTFIER( FSeek( fhnd, -3, FS_END ) )                    , 'E: 0      R: 43'                   )
   TEST_LINE( TESTFIER( FWrite( fhnd, "W" ) )                          , 'E: 0      R: 1'                    )
   TEST_LINE( TESTFIER( FClose() )                                     , 'E: 0      R: .F.'                  )
   TEST_LINE( TESTFIER( FClose( fhnd ) )                               , 'E: 0      R: .T.'                  )
   TEST_LINE( TESTFIER( FClose( fhnd ) )                               , 'E: 6      R: .F.'                  )
   TEST_LINE( TESTFIER( FErase( "NOT_HERE.$$$" ) )                     , 'E: 2      R: -1'                   )
   TEST_LINE( TESTFIER( FErase( 1 ) )                                  , 'E: 3      R: -1'                   )
   TEST_LINE( TESTFIER( FErase( "NOT_HERE.$$$" ) )                     , 'E: 2      R: -1'                   )
   TEST_LINE( TESTFIER( FRename( "NOT_HERE.$$$", 'A' ) )               , 'E: 2      R: -1'                   )

   nFlags := FO_READWRITE
   fhnd := FOpen( cFileName, nFlags )

   TEST_LINE( FError()                                                 , 0 )
   TEST_LINE( TESTFIER( FWrite( fhnd, ">1234567890<" ) )               , "E: 0      R: 12"     )
   TEST_LINE( TESTFIER( FWrite( fhnd, "(123" + Chr(0) + "4567890)" ) ) , "E: 0      R: 13"     )
   TEST_LINE( TESTFIER( FSeek( fhnd ) )                                , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 5 ) )                             , "E: 0      R: 5"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -1, FS_SET ) )                    , "E: 25     R: 5"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -10, FS_SET ) )                   , "E: 25     R: 5"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -100, FS_SET ) )                  , "E: 25     R: 5"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "!" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 1 ) )                             , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "A" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 2, FS_SET ) )                     , "E: 0      R: 2"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "B" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 3, FS_RELATIVE ) )                , "E: 0      R: 6"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "C" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -1, FS_RELATIVE ) )               , "E: 0      R: 6"      )
   TEST_LINE( TESTFIER( FWrite( fhnd, "D" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 3, FS_END ) )                     , "E: 0      R: 49"     )
   TEST_LINE( TESTFIER( FWrite( fhnd, "E" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, -1, FS_END ) )                    , "E: 0      R: 49"     )
   TEST_LINE( TESTFIER( FWrite( fhnd, "F" ) )                          , "E: 0      R: 1"      )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0 ) )                             , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FRead( fhnd, mnLongP ) )                       , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FRead( fhnd, @mnLongP, 2 ) )                   , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FRead( fhnd, cBuff4 ) )                        , "E: 0      R: 0"      )
   TEST_LINE( TESTFIER( FRead( fhnd, cBuff4, 2 ) )                     , "E: 0      R: 0"      )
#ifdef __CLIPPER__
// TEST_LINE( TESTFIER( FRead( fhnd, @cBuff4, Len( cBuff4 ) + 1 ) )    , "E: 0      R: 0"      )
#endif
   TEST_LINE( TESTFIER( FRead( fhnd, @cBuff4, 1000 ) )                 , 'E: 0      R: 0'                  )
   TEST_LINE( TESTFIER( FRead( fhnd, @cBuff4, 3 ) )                    , 'E: 0      R: 3'                  )
   TEST_LINE( TESTFIER( FRead( fhnd, @cBuff100, 100 ) )                , 'E: 0      R: 47'                 )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0 ) )                             , 'E: 0      R: 0'                  )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 4 ) )                          , 'E: 0      R: ">AB3"'             )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0 ) )                             , 'E: 0      R: 0'                  )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 100 ) )                        , 'E: 0      R: ">AB34!D7890<(123"' )
   TEST_LINE( TESTFIER( FSeek( fhnd, 1, FS_RELATIVE ) )                , 'E: 0      R: 51'                 )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 2 ) )                          , 'E: 0      R: ""'                 )
   TEST_LINE( TESTFIER( FSeek( fhnd, -4, FS_END ) )                    , 'E: 0      R: 46'                 )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 1 ) )                          , 'E: 0      R: ""'                 )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 20 ) )                         , 'E: 0      R: ""'                 )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0, FS_END ) )                     , 'E: 0      R: 50'                 )
   TEST_LINE( TESTFIER( FWrite( fhnd, "_-_-_-_-_-_-_" ) )              , 'E: 0      R: 13'                 )
   TEST_LINE( TESTFIER( FSeek( fhnd, -4, FS_END ) )                    , 'E: 0      R: 59'                 )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 1 ) )                          , 'E: 0      R: "-"'                )
   TEST_LINE( TESTFIER( FReadStr( fhnd, 20 ) )                         , 'E: 0      R: "_-_"'              )
   TEST_LINE( TESTFIER( FSeek( fhnd, 3, FS_END ) )                     , 'E: 0      R: 66'                 )
   TEST_LINE( TESTFIER( FWrite( fhnd, "V" ) )                          , 'E: 0      R: 1'                  )
   TEST_LINE( TESTFIER( FSeek( fhnd, -3, FS_END ) )                    , 'E: 0      R: 64'                 )
   TEST_LINE( TESTFIER( FWrite( fhnd, "W" ) )                          , 'E: 0      R: 1'                  )
   TEST_LINE( TESTFIER( FWrite( fhnd, "" ) )                           , 'E: 0      R: 0'                  )
   TEST_LINE( TESTFIER( FSeek( fhnd, 0, FS_END ) )                     , 'E: 0      R: 65'                 )
   TEST_LINE( TESTFIER( FClose() )                                     , 'E: 0      R: .F.'                )
   TEST_LINE( TESTFIER( FClose( fhnd ) )                               , 'E: 0      R: .T.'                )
   TEST_LINE( TESTFIER( FClose( fhnd ) )                               , 'E: 6      R: .F.'                )
   TEST_LINE( TESTFIER( FErase( "NOT_HERE.$$$" ) )                     , 'E: 2      R: -1'                 )
   TEST_LINE( TESTFIER( FErase( 1 ) )                                  , 'E: 3      R: -1'                 )
   TEST_LINE( TESTFIER( FErase( "NOT_HERE.$$$" ) )                     , 'E: 2      R: -1'                 )
   TEST_LINE( TESTFIER( FRename( "NOT_HERE.$$$", 'A' ) )               , 'E: 2      R: -1'                 )

   TEST_LINE( TESTFIER( File( cFileName ) )                            , "E: 2      R: .T."    )
   TEST_LINE( TESTFIER( File( "NOT_HERE.$$$" ) )                       , "E: 2      R: .F."    )

   FErase("$$FILEIO.TMP")

   RETURN NIL

STATIC FUNCTION TESTFIER( xRetVal )
   RETURN PadR( "E: " + LTrim( Str( FError() ) ), 9 ) + " R: " + XToStr( xRetVal )

STATIC FUNCTION Main_MISC()
   LOCAL oError

   /* Some random error object tests taken from the separate test source */

   oError := ErrorNew()
   TEST_LINE( oError:ClassName()              , "ERROR"                   )
   oError:Description = "Its description"
   TEST_LINE( oError:Description              , "Its description"         )
#ifdef __CLIPPER__
   TEST_LINE( Len( oError )                   , 7                         )
#endif
#ifdef __HARBOUR__
   TEST_LINE( Len( oError )                   , 14                        )
#endif

   /* "Samples" function tests (AMPM(), DAYS(), ELAPTIME(), ... ) */

   TEST_LINE( AMPM( "" )                      , "12 am"                                   )
   TEST_LINE( AMPM( "HELLO" )                 , "12LLO am"                                )
   TEST_LINE( AMPM( " 0:23:45" )              , "12:23:45 am"                             )
   TEST_LINE( AMPM( "00:23:45" )              , "12:23:45 am"                             )
   TEST_LINE( AMPM( " 5:23:45" )              , " 5:23:45 am"                             )
   TEST_LINE( AMPM( "05:23:45" )              , "05:23:45 am"                             )
   TEST_LINE( AMPM( "12:23:45" )              , "12:23:45 pm"                             )
   TEST_LINE( AMPM( "20:23:45" )              , " 8:23:45 pm"                             )
   TEST_LINE( AMPM( "24:23:45" )              , "12:23:45 am"                             )
   TEST_LINE( AMPM( "25:23:45" )              , "13:23:45 pm"                             )
   TEST_LINE( AMPM( "2" )                     , "2 am"                                    )
   TEST_LINE( AMPM( "02:23" )                 , "02:23 am"                                )
   TEST_LINE( AMPM( "02:23:45.10" )           , "02:23:45.10 am"                          )

   TEST_LINE( DAYS( 100000 )                  , 1 )

   TEST_LINE( ELAPTIME("23:12:34","12:34:57") , "13:22:23" )
   TEST_LINE( ELAPTIME("12:34:57","23:12:34") , "10:37:37" )

   TEST_LINE( LENNUM( 10 )                    , 2 )
   TEST_LINE( LENNUM( 10.9 )                  , 4 )
   TEST_LINE( LENNUM( 10.90 )                 , 5 )

   TEST_LINE( SECS("23:12:34")                , 83554 )
   TEST_LINE( SECS("12:34:57")                , 45297 )

   TEST_LINE( TSTRING(1000)                   , "00:16:40" )

   TEST_LINE( SoundEx()                       , "0000" )
   TEST_LINE( SoundEx( 10 )                   , "0000" )
   TEST_LINE( SoundEx( @scString )            , "H400" )
   TEST_LINE( SoundEx( "" )                   , "0000" )
   TEST_LINE( SoundEx( "Hm" )                 , "H500" )
   TEST_LINE( SoundEx( "Smith" )              , "S530" )
   TEST_LINE( SoundEx( "Harbour" )            , "H616" )
   TEST_LINE( SoundEx( "HARBOUR" )            , "H616" )
   TEST_LINE( SoundEx( "Harpour" )            , "H616" )
   TEST_LINE( SoundEx( "Hello" )              , "H400" )
   TEST_LINE( SoundEx( "Aardwaark" )          , "A636" )
   TEST_LINE( SoundEx( "Ardwark" )            , "A636" )
   TEST_LINE( SoundEx( "Bold" )               , "B430" )
   TEST_LINE( SoundEx( "Cold" )               , "C430" )
   TEST_LINE( SoundEx( "Colt" )               , "C430" )
   TEST_LINE( SoundEx( "C"+Chr(0)+"olt" )     , "C430" )
   TEST_LINE( SoundEx( "��A��" )              , "A000" )
   TEST_LINE( SoundEx( "12345" )              , "0000" )

   /* NATION functions */

   TEST_LINE( NationMsg()                     , "Invalid argument" )
   TEST_LINE( NationMsg("A")                  , "" )
   TEST_LINE( NationMsg(-1)                   , "" ) /* CA-Cl*pper bug: 5.3 may return trash. */
   TEST_LINE( NationMsg(0)                    , "" )
   TEST_LINE( NationMsg(1)                    , "Database Files    # Records    Last Update     Size" )
   TEST_LINE( NationMsg(2)                    , "Do you want more samples?"                           )
   TEST_LINE( NationMsg(3)                    , "Page No."                                            )
   TEST_LINE( NationMsg(4)                    , "** Subtotal **"                                      )
   TEST_LINE( NationMsg(5)                    , "* Subsubtotal *"                                     )
   TEST_LINE( NationMsg(6)                    , "*** Total ***"                                       )
   TEST_LINE( NationMsg(7)                    , "Ins"                                                 )
   TEST_LINE( NationMsg(8)                    , "   "                                                 )
   TEST_LINE( NationMsg(9)                    , "Invalid date"                                        )
   TEST_LINE( NationMsg(10)                   , "Range: "                                             )
   TEST_LINE( NationMsg(11)                   , " - "                                                 )
   TEST_LINE( NationMsg(12)                   , "Y/N"                                                 )
   TEST_LINE( NationMsg(13)                   , "INVALID EXPRESSION"                                  )
   TEST_LINE( NationMsg(14)                   , "" )
   TEST_LINE( NationMsg(200)                  , "" ) /* Bug in CA-Cl*pper, it will return "74?" or other trash */

/* These will cause a GPF in CA-Cl*pper (5.2e) */
#ifndef __CLIPPER__
   TEST_LINE( IsAffirm()                      , .F.    )
   TEST_LINE( IsAffirm(.F.)                   , .F.    )
   TEST_LINE( IsAffirm(.T.)                   , .F.    )
   TEST_LINE( IsAffirm(0)                     , .F.    )
   TEST_LINE( IsAffirm(1)                     , .F.    )
#endif
   TEST_LINE( IsAffirm("")                    , .F.    )
   TEST_LINE( IsAffirm("I")                   , .F.    )
   TEST_LINE( IsAffirm("y")                   , .T.    )
   TEST_LINE( IsAffirm("Y")                   , .T.    )
   TEST_LINE( IsAffirm("yes")                 , .T.    )
   TEST_LINE( IsAffirm("YES")                 , .T.    )
   TEST_LINE( IsAffirm("n")                   , .F.    )
   TEST_LINE( IsAffirm("N")                   , .F.    )
   TEST_LINE( IsAffirm("no")                  , .F.    )
   TEST_LINE( IsAffirm("NO")                  , .F.    )

/* These will cause a GPF in CA-Cl*pper (5.2e) */
#ifndef __CLIPPER__
   TEST_LINE( IsNegative()                    , .F.    )
   TEST_LINE( IsNegative(.F.)                 , .F.    )
   TEST_LINE( IsNegative(.T.)                 , .F.    )
   TEST_LINE( IsNegative(0)                   , .F.    )
   TEST_LINE( IsNegative(1)                   , .F.    )
#endif
   TEST_LINE( IsNegative("")                  , .F.    )
   TEST_LINE( IsNegative("I")                 , .F.    )
   TEST_LINE( IsNegative("y")                 , .F.    )
   TEST_LINE( IsNegative("Y")                 , .F.    )
   TEST_LINE( IsNegative("yes")               , .F.    )
   TEST_LINE( IsNegative("YES")               , .F.    )
   TEST_LINE( IsNegative("n")                 , .T.    )
   TEST_LINE( IsNegative("N")                 , .T.    )
   TEST_LINE( IsNegative("no")                , .T.    )
   TEST_LINE( IsNegative("NO")                , .T.    )

   /* FOR/NEXT */

   TEST_LINE( TFORNEXT( .F., .T., NIL )       , "E BASE 1086 Argument error ++ F:S"       )
   TEST_LINE( TFORNEXT( .T., .F., NIL )       , .T.                                       )
   TEST_LINE( TFORNEXT( .F., .F., NIL )       , "E BASE 1086 Argument error ++ F:S"       )
   TEST_LINE( TFORNEXT( 100, 101, NIL )       , 102                                       )
   TEST_LINE( TFORNEXT( "A", "A", NIL )       , "E BASE 1086 Argument error ++ F:S"       )
   TEST_LINE( TFORNEXT( NIL, NIL, NIL )       , "E BASE 1075 Argument error > F:S"        )
   TEST_LINE( TFORNEXT( .F., .T.,   1 )       , "E BASE 1081 Argument error + F:S"        )
   TEST_LINE( TFORNEXT( .F., .T.,  -1 )       , .F.                                       )
   TEST_LINE( TFORNEXT( .F., .T., .F. )       , "E BASE 1073 Argument error < F:S"        )
   TEST_LINE( TFORNEXT( .T., .F.,   1 )       , .T.                                       )
   TEST_LINE( TFORNEXT( .T., .F.,  -1 )       , "E BASE 1081 Argument error + F:S"        )
   TEST_LINE( TFORNEXT( .T., .F., .T. )       , "E BASE 1073 Argument error < F:S"        )
   TEST_LINE( TFORNEXT( 100, 101,   1 )       , 102                                       )
   TEST_LINE( TFORNEXT( 101, 100,  -1 )       , 99                                        )
   TEST_LINE( TFORNEXT( "A", "A", "A" )       , "E BASE 1073 Argument error < F:S"        )
   TEST_LINE( TFORNEXT( "A", "B", "A" )       , "E BASE 1073 Argument error < F:S"        )
   TEST_LINE( TFORNEXT( "B", "A", "A" )       , "E BASE 1073 Argument error < F:S"        )
   TEST_LINE( TFORNEXT( NIL, NIL, NIL )       , "E BASE 1075 Argument error > F:S"        )

   TEST_LINE( TFORNEXTX(   1, 10,NIL )        , "FTTTTTTTTTTT"                            )
   TEST_LINE( TFORNEXTX(  10,  1,NIL )        , "FT"                                      )
   TEST_LINE( TFORNEXTX(   1, 10,  1 )        , "FTSSTSSTSSTSSTSSTSSTSSTSSTSSTSSTS"       )
   TEST_LINE( TFORNEXTX(  10,  1, -1 )        , "FTSSTSSTSSTSSTSSTSSTSSTSSTSSTSSTS"       )
   TEST_LINE( TFORNEXTX(   1, 10, -1 )        , "FTS"                                     )
   TEST_LINE( TFORNEXTX(  10,  1,  1 )        , "FTS"                                     )
   TEST_LINE( TFORNEXTX(   1, 10,  4 )        , "FTSSTSSTSSTS"                            )
   TEST_LINE( TFORNEXTX(  10,  1, -4 )        , "FTSSTSSTSSTS"                            )
   TEST_LINE( TFORNEXTX(   1, 10, -4 )        , "FTS"                                     )
   TEST_LINE( TFORNEXTX(  10,  1,  4 )        , "FTS"                                     )

   TEST_LINE( TFORNEXTXF(   1, 10,NIL )       , "F-9999T1T2T3T4T5T6T7T8T9T10T11R11"                                              )
   TEST_LINE( TFORNEXTXF(  10,  1,NIL )       , "F-9999T10R10"                                                                   )
   TEST_LINE( TFORNEXTXF(   1, 10,  1 )       , "F-9999T1S1S1T2S2S2T3S3S3T4S4S4T5S5S5T6S6S6T7S7S7T8S8S8T9S9S9T10S10S10T11S11R11" )
   TEST_LINE( TFORNEXTXF(  10,  1, -1 )       , "F-9999T10S10S10T9S9S9T8S8S8T7S7S7T6S6S6T5S5S5T4S4S4T3S3S3T2S2S2T1S1S1T0S0R0"    )
   TEST_LINE( TFORNEXTXF(   1, 10, -1 )       , "F-9999T1S1R1"                                                                   )
   TEST_LINE( TFORNEXTXF(  10,  1,  1 )       , "F-9999T10S10R10"                                                                )
   TEST_LINE( TFORNEXTXF(   1, 10,  4 )       , "F-9999T1S1S1T5S5S5T9S9S9T13S13R13"                                              )
   TEST_LINE( TFORNEXTXF(  10,  1, -4 )       , "F-9999T10S10S10T6S6S6T2S2S2T-2S-2R-2"                                           )
   TEST_LINE( TFORNEXTXF(   1, 10, -4 )       , "F-9999T1S1R1"                                                                   )
   TEST_LINE( TFORNEXTXF(  10,  1,  4 )       , "F-9999T10S10R10"                                                                )

   /* EVAL(), :EVAL */

   TEST_LINE( Eval( NIL )                     , "E BASE 1004 No exported method EVAL F:S" )
   TEST_LINE( Eval( 1 )                       , "E BASE 1004 No exported method EVAL F:S" )
#ifdef __HARBOUR__
   TEST_LINE( Eval( @sbBlock )                , NIL                                       ) /* Bug in CA-Cl*pper, it will return: "E BASE 1004 No exported method EVAL F:S" */
#endif
   TEST_LINE( Eval( {|p1| p1 },"A","B")       , "A"                                       )
   TEST_LINE( Eval( {|p1,p2| p1+p2 },"A","B") , "AB"                                      )
   TEST_LINE( Eval( {|p1,p2,p3| p1 },"A","B") , "A"                                       )
/* Harbour compiler not yet handles these */
#ifndef __HARBOUR__
   TEST_LINE( suNIL:Eval                      , "E BASE 1004 No exported method EVAL F:S" )
#endif
   TEST_LINE( scString:Eval                   , "E BASE 1004 No exported method EVAL F:S" )
   TEST_LINE( snIntP:Eval                     , "E BASE 1004 No exported method EVAL F:S" )
   TEST_LINE( sdDateE:Eval                    , "E BASE 1004 No exported method EVAL F:S" )
   TEST_LINE( slFalse:Eval                    , "E BASE 1004 No exported method EVAL F:S" )
   TEST_LINE( sbBlock:Eval                    , NIL                                       )
   TEST_LINE( saArray:Eval                    , "E BASE 1004 No exported method EVAL F:S" )
   TEST_LINE( soObject:Eval                   , "E BASE 1004 No exported method EVAL F:S" )

   /* STOD() */

   /* For these tests in CA-Cl*pper 5.2e the following native STOD() has
      been used ( not the emulated one written in Clipper ):

      CLIPPER STOD( void )
      {
         // The length check is a fix to avoid buggy behaviour of _retds()
         _retds( ( ISCHAR( 1 ) && _parclen( 1 ) == 8 ) ? _parc( 1 ) : "        " );
      }
   */

   TEST_LINE( SToD()                          , SToD("        ")             )
   TEST_LINE( SToD(1)                         , SToD("        ")             )
   TEST_LINE( SToD(NIL)                       , SToD("        ")             )
   TEST_LINE( SToD("")                        , SToD("        ")             )
   TEST_LINE( SToD("        ")                , SToD("        ")             )
   TEST_LINE( SToD("       ")                 , SToD("        ")             )
   TEST_LINE( SToD("         ")               , SToD("        ")             )
   TEST_LINE( SToD(" 1234567")                , SToD("        ")             )
   TEST_LINE( SToD("1999    ")                , SToD("        ")             )
   TEST_LINE( SToD("99999999")                , SToD("        ")             )
   TEST_LINE( SToD("99990101")                , SToD("        ")             )
   TEST_LINE( SToD("19991301")                , SToD("        ")             )
   TEST_LINE( SToD("19991241")                , SToD("        ")             )
   TEST_LINE( SToD("01000101")                , SToD("01000101")             )
   TEST_LINE( SToD("29991231")                , SToD("29991231")             )
   TEST_LINE( SToD("19990905")                , SToD("19990905")             )
   TEST_LINE( SToD(" 9990905")                , SToD("        ")             )
   TEST_LINE( SToD("1 990905")                , SToD("        ")             )
   TEST_LINE( SToD("19 90905")                , SToD("17490905")             )
   TEST_LINE( SToD("199 0905")                , SToD("19740905")             )
   TEST_LINE( SToD("1999 905")                , SToD("        ")             )
   TEST_LINE( SToD("19990 05")                , SToD("        ")             )
   TEST_LINE( SToD("199909 5")                , SToD("        ")             )
   TEST_LINE( SToD("1999090 ")                , SToD("        ")             )
   TEST_LINE( SToD("1999 9 5")                , SToD("        ")             )
   TEST_LINE( SToD("1999090" + Chr(0))        , SToD("        ")             )

   /* DESCEND() */

   TEST_LINE( Descend()                       , NIL                                                 ) /* Bug in CA-Cl*pper, it returns undefined trash */
   TEST_LINE( Descend( NIL )                  , NIL                                                 )
   TEST_LINE( Descend( { "A", "B" } )         , NIL                                                 )
#ifdef __HARBOUR__
   TEST_LINE( Descend( @scString )            , "�����"                                             ) /* Bug in CA-Cl*pper, it will return NIL */
#endif
   TEST_LINE( Descend( scString )             , "�����"                                             )
   TEST_LINE( Descend( scString )             , "�����"                                             )
   TEST_LINE( Descend( Descend( scString ) )  , "HELLO"                                             )
   TEST_LINE( Descend( .F. )                  , .T.                                                 )
   TEST_LINE( Descend( .T. )                  , .F.                                                 )
   TEST_LINE( Descend( 0 )                    , 0.00                                                )
   TEST_LINE( Descend( 1 )                    , -1.00                                               )
   TEST_LINE( Descend( -1 )                   , 1.00                                                )
   TEST_LINE( Descend( Descend( 256 ) )       , 256.00                                              )
   TEST_LINE( Descend( 2.0 )                  , -2.00                                               )
   TEST_LINE( Descend( 2.5 )                  , -2.50                                               )
   TEST_LINE( Descend( -100.35 )              , 100.35                                              )
   TEST_LINE( Str(Descend( -740.354 ))        , "       740.35"                                     )
   TEST_LINE( Str(Descend( -740.359 ))        , "       740.36"                                     )
   TEST_LINE( Str(Descend( -740.354 ), 15, 5) , "      740.35400"                                   )
   TEST_LINE( Str(Descend( -740.359 ), 15, 5) , "      740.35900"                                   )
   TEST_LINE( Descend( 100000 )               , -100000.00                                          )
   TEST_LINE( Descend( -100000 )              , 100000.00                                           )
   TEST_LINE( Descend( "" )                   , ""                                                  )
   TEST_LINE( Descend( Chr(0) )               , ""+Chr(0)+""                                        )
   TEST_LINE( Descend( Chr(0) + "Hello" )     , ""+Chr(0)+"�����"                                   )
   TEST_LINE( Descend( "Hello"+Chr(0)+"wo" )  , "�����"+Chr(0)+"��"                                 )
   TEST_LINE( Descend( SToD( "" ) )           , 5231808                                             )
   TEST_LINE( Descend( SToD( "01000101" ) )   , 3474223                                             )
   TEST_LINE( Descend( SToD( "19801220" ) )   , 2787214                                             )

#ifdef __HARBOUR__

   /* HB_COLORINDEX() */

   TEST_LINE( hb_ColorIndex()                  , ""               )
   TEST_LINE( hb_ColorIndex("", -1)            , ""               )
   TEST_LINE( hb_ColorIndex("", 0)             , ""               )
   TEST_LINE( hb_ColorIndex("W/R", -1)         , ""               )
   TEST_LINE( hb_ColorIndex("W/R", 0)          , "W/R"            )
   TEST_LINE( hb_ColorIndex("W/R", 1)          , ""               )
   TEST_LINE( hb_ColorIndex("W/R", 2)          , ""               )
   TEST_LINE( hb_ColorIndex("W/R,GR/0", 0)     , "W/R"            )
   TEST_LINE( hb_ColorIndex("W/R,GR/0", 1)     , "GR/0"           )
   TEST_LINE( hb_ColorIndex("W/R,GR/0", 2)     , ""               )
   TEST_LINE( hb_ColorIndex("W/R,GR/0", 3)     , ""               )
   TEST_LINE( hb_ColorIndex("W/R, GR/0", 0)    , "W/R"            )
   TEST_LINE( hb_ColorIndex("W/R, GR/0", 1)    , "GR/0"           )
   TEST_LINE( hb_ColorIndex("W/R, GR/0", 2)    , ""               )
   TEST_LINE( hb_ColorIndex("W/R, GR/0", 3)    , ""               )
   TEST_LINE( hb_ColorIndex("W/R,GR/0 ", 0)    , "W/R"            )
   TEST_LINE( hb_ColorIndex("W/R,GR/0 ", 1)    , "GR/0"           )
   TEST_LINE( hb_ColorIndex("W/R,GR/0 ", 2)    , ""               )
   TEST_LINE( hb_ColorIndex("W/R, GR/0 ", 0)   , "W/R"            )
   TEST_LINE( hb_ColorIndex("W/R, GR/0 ", 1)   , "GR/0"           )
   TEST_LINE( hb_ColorIndex("W/R, GR/0 ", 2)   , ""               )
   TEST_LINE( hb_ColorIndex("W/R, GR/0 ,", 0)  , "W/R"            )
   TEST_LINE( hb_ColorIndex("W/R, GR/0 ,", 1)  , "GR/0"           )
   TEST_LINE( hb_ColorIndex("W/R, GR/0 ,", 2)  , ""               )
   TEST_LINE( hb_ColorIndex(" W/R, GR/0 ,", 0) , "W/R"            )
   TEST_LINE( hb_ColorIndex(" W/R, GR/0 ,", 1) , "GR/0"           )
   TEST_LINE( hb_ColorIndex(" W/R, GR/0 ,", 2) , ""               )
   TEST_LINE( hb_ColorIndex(" W/R , GR/0 ,", 0), "W/R"            )
   TEST_LINE( hb_ColorIndex(" W/R , GR/0 ,", 1), "GR/0"           )
   TEST_LINE( hb_ColorIndex(" W/R , GR/0 ,", 2), ""               )
   TEST_LINE( hb_ColorIndex(" W/R ,   ,", 1)   , ""               )
   TEST_LINE( hb_ColorIndex(" W/R ,,", 1)      , ""               )
   TEST_LINE( hb_ColorIndex(",,", 0)           , ""               )
   TEST_LINE( hb_ColorIndex(",,", 1)           , ""               )
   TEST_LINE( hb_ColorIndex(",,", 2)           , ""               )
   TEST_LINE( hb_ColorIndex(",  ,", 2)         , ""               )

#endif

   /* FKMAX(), FKLABEL() */

   TEST_LINE( FKMax()                         , 40               )
   TEST_LINE( FKMax( 1 )                      , 40               )
#ifdef __HARBOUR__
   TEST_LINE( FKLabel()                       , ""               ) /* Bug in CA-Cl*pper, it returns: "E BASE 1074 Argument error <= F:S" */
   TEST_LINE( FKLabel( NIL )                  , ""               ) /* Bug in CA-Cl*pper, it returns: "E BASE 1074 Argument error <= F:S" */
   TEST_LINE( FKLabel( "A" )                  , ""               ) /* Bug in CA-Cl*pper, it returns: "E BASE 1074 Argument error <= F:S" */
#endif
   TEST_LINE( FKLabel( -1 )                   , ""               )
   TEST_LINE( FKLabel( 0 )                    , ""               )
   TEST_LINE( FKLabel( 1 )                    , "F1"             )
   TEST_LINE( FKLabel( 25 )                   , "F25"            )
   TEST_LINE( FKLabel( 40 )                   , "F40"            )
   TEST_LINE( FKLabel( 41 )                   , ""               )

   /* NOTE: BIN2*() functions are quite untable in CA-Cl*pper when the passed
      parameter is smaller than the required length. */

   /* BIN2I() */

#ifndef __CLIPPER__
   TEST_LINE( BIN2I()                         , 0                ) /* Bug in CA-Cl*pper, this causes a GPF */
   TEST_LINE( BIN2I(100)                      , 0                ) /* Bug in CA-Cl*pper, this causes a GPF */
#endif
   TEST_LINE( BIN2I("")                       , 0                )
   TEST_LINE( BIN2I("AB")                     , 16961            )
   TEST_LINE( BIN2I("BA")                     , 16706            )
   TEST_LINE( BIN2I(Chr(255))                 , 255              )
   TEST_LINE( BIN2I(Chr(255)+Chr(255))        , -1               )
   TEST_LINE( BIN2I(Chr(0))                   , 0                )
   TEST_LINE( BIN2I(Chr(0)+Chr(0))            , 0                )
   TEST_LINE( BIN2I("A")                      , 65               )
   TEST_LINE( BIN2I("ABC")                    , 16961            )

   /* BIN2W() */

#ifndef __CLIPPER__
   TEST_LINE( BIN2W()                         , 0                ) /* Bug in CA-Cl*pper, this causes a GPF */
   TEST_LINE( BIN2W(100)                      , 0                ) /* Bug in CA-Cl*pper, this causes a GPF */
#endif
   TEST_LINE( BIN2W("")                       , 0                )
   TEST_LINE( BIN2W("AB")                     , 16961            )
   TEST_LINE( BIN2W("BA")                     , 16706            )
   TEST_LINE( BIN2W(Chr(255))                 , 255              )
   TEST_LINE( BIN2W(Chr(255)+Chr(255))        , 65535            )
   TEST_LINE( BIN2W(Chr(0))                   , 0                )
   TEST_LINE( BIN2W(Chr(0)+Chr(0))            , 0                )
   TEST_LINE( BIN2W("A")                      , 65               )
   TEST_LINE( BIN2W("ABC")                    , 16961            )

   /* BIN2L() */

#ifndef __CLIPPER__
   TEST_LINE( BIN2L()                                    , 0                ) /* Bug in CA-Cl*pper, this causes a GPF */
   TEST_LINE( BIN2L(100)                                 , 0                ) /* Bug in CA-Cl*pper, this causes a GPF */
#endif
   TEST_LINE( BIN2L("")                                  , 0                )
   TEST_LINE( BIN2L("ABCD")                              , 1145258561       )
   TEST_LINE( BIN2L("DCBA")                              , 1094861636       )
   TEST_LINE( BIN2L(Chr(255))                            , 255              )
   TEST_LINE( BIN2L(Chr(255)+Chr(255)+Chr(255))          , 16777215         )
   TEST_LINE( BIN2L(Chr(255)+Chr(255)+Chr(255)+Chr(255)) , -1               )
   TEST_LINE( BIN2L(Chr(0)+Chr(0)+Chr(0))                , 0                )
   TEST_LINE( BIN2L(Chr(0)+Chr(0)+Chr(0)+Chr(0))         , 0                )
   TEST_LINE( BIN2L("ABC")                               , 4407873          )
   TEST_LINE( BIN2L("ABCDE")                             , 1145258561       )

   /* I2BIN() */

   TEST_LINE( I2BIN()                         , ""+Chr(0)+""+Chr(0)+"" )
   TEST_LINE( I2BIN(""     )                  , ""+Chr(0)+""+Chr(0)+"" )
   TEST_LINE( I2BIN(0      )                  , ""+Chr(0)+""+Chr(0)+"" )
   TEST_LINE( I2BIN(16961  )                  , "AB"                   )
   TEST_LINE( I2BIN(16706  )                  , "BA"                   )
   TEST_LINE( I2BIN(255    )                  , "�"+Chr(0)+""          )
   TEST_LINE( I2BIN(-1     )                  , "��"                   )
   TEST_LINE( I2BIN(0      )                  , ""+Chr(0)+""+Chr(0)+"" )
   TEST_LINE( I2BIN(0      )                  , ""+Chr(0)+""+Chr(0)+"" )
   TEST_LINE( I2BIN(65     )                  , "A"+Chr(0)+""          )
   TEST_LINE( I2BIN(16961  )                  , "AB"                   )

   /* L2BIN() */

   TEST_LINE( L2BIN()                         , ""+Chr(0)+""+Chr(0)+""+Chr(0)+""+Chr(0)+""  )
   TEST_LINE( L2BIN("")                       , ""+Chr(0)+""+Chr(0)+""+Chr(0)+""+Chr(0)+""  )
   TEST_LINE( L2BIN(0          )              , ""+Chr(0)+""+Chr(0)+""+Chr(0)+""+Chr(0)+""  )
   TEST_LINE( L2BIN(1145258561 )              , "ABCD"                                      )
   TEST_LINE( L2BIN(1094861636 )              , "DCBA"                                      )
   TEST_LINE( L2BIN(255        )              , "�"+Chr(0)+""+Chr(0)+""+Chr(0)+""           )
   TEST_LINE( L2BIN(16777215   )              , "���"+Chr(0)+""                             )
   TEST_LINE( L2BIN(-1         )              , Chr(255)+Chr(255)+Chr(255)+Chr(255)         )
   TEST_LINE( L2BIN(0          )              , ""+Chr(0)+""+Chr(0)+""+Chr(0)+""+Chr(0)+""  )
   TEST_LINE( L2BIN(0          )              , Chr(0)+Chr(0)+Chr(0)+Chr(0)                 )
   TEST_LINE( L2BIN(4407873    )              , "ABC"+Chr(0)+""                             )
   TEST_LINE( L2BIN(1145258561 )              , "ABCD"                                      )

   /* __COPYFILE() */

   FClose(FCreate("$$COPYFR.TMP"))

   /* NOTE: Cannot yet test the return value of the function on a DEFAULT-ed
            failure. */
   /* NOTE: The dot in the "*INVALID*." filename is intentional and serves
            to hide different path handling, since Harbour is platform
            independent. */

   TEST_LINE( __CopyFile("$$COPYFR.TMP")                 , "E BASE 2010 Argument error __COPYFILE "   )
   TEST_LINE( __CopyFile("$$COPYFR.TMP", "$$COPYTO.TMP") , NIL                                        )
   TEST_LINE( __CopyFile("NOT_HERE.$$$", "$$COPYTO.TMP") , "E BASE 2012 Open error NOT_HERE.$$$ F:DR" )
   TEST_LINE( __CopyFile("$$COPYFR.TMP", "*INVALID*.")   , "E BASE 2012 Create error *INVALID*. F:DR" )

   FErase("$$COPYFR.TMP")
   FErase("$$COPYTO.TMP")

   /* __RUN() */

   /* NOTE: Only error cases are tested. */

   TEST_LINE( __RUN()                         , NIL              )
   TEST_LINE( __RUN( NIL )                    , NIL              )
   TEST_LINE( __RUN( 10 )                     , NIL              )

   /* ARRAY function error conditions. */

   TEST_LINE( aCopy()                         , NIL                                        )
   TEST_LINE( aCopy({}, "C")                  , NIL                                        )
   TEST_LINE( aCopy("C", {})                  , NIL                                        )
   TEST_LINE( aCopy({}, {})                   , "{.[0].}"                                  )
   TEST_LINE( aCopy({}, ErrorNew())           , "ERROR Object"                             )
   TEST_LINE( aCopy(ErrorNew(), {})           , "{.[0].}"                                  )
   TEST_LINE( aClone()                        , NIL                                        )
   TEST_LINE( aClone( NIL )                   , NIL                                        )
   TEST_LINE( aClone( {} )                    , "{.[0].}"                                  )
   TEST_LINE( aClone( ErrorNew() )            , NIL                                        )
   TEST_LINE( aEval()                         , "E BASE 2017 Argument error AEVAL "        )
   TEST_LINE( aEval( NIL )                    , "E BASE 2017 Argument error AEVAL "        )
   TEST_LINE( aEval( {} )                     , "E BASE 2017 Argument error AEVAL "        )
   TEST_LINE( aEval( {}, NIL )                , "E BASE 2017 Argument error AEVAL "        )
   TEST_LINE( aEval( {}, {|| NIL } )          , "{.[0].}"                                  )
   TEST_LINE( aEval( ErrorNew(), {|| NIL } )  , "ERROR Object"                             )
   TEST_LINE( aScan()                         , 0                                          )
   TEST_LINE( aScan( NIL )                    , 0                                          )
   TEST_LINE( aScan( "A" )                    , 0                                          )
   TEST_LINE( aScan( {} )                     , 0                                          )
   TEST_LINE( aScan( {}, "" )                 , 0                                          )
   TEST_LINE( aScan( ErrorNew(), "NOT_FOUND") , 0                                          )
   TEST_LINE( aSort()                         , NIL                                        )
   TEST_LINE( aSort(10)                       , NIL                                        )
   TEST_LINE( aSort({})                       , "{.[0].}"                                  )
   TEST_LINE( aSort(ErrorNew())               , NIL                                        )
   TEST_LINE( aFill()                         , "E BASE 2017 Argument error AEVAL "        )
   TEST_LINE( aFill( NIL )                    , "E BASE 2017 Argument error AEVAL "        )
   TEST_LINE( aFill( {} )                     , "{.[0].}"                                  )
   TEST_LINE( aFill( {}, 1 )                  , "{.[0].}"                                  )
   TEST_LINE( aFill( ErrorNew() )             , "ERROR Object"                             )
   TEST_LINE( aFill( ErrorNew(), 1 )          , "ERROR Object"                             )
   TEST_LINE( aDel()                          , NIL                                        )
   TEST_LINE( aDel( NIL )                     , NIL                                        )
   TEST_LINE( aDel( { 1 } )                   , "{.[1].}"                                  )
   TEST_LINE( aDel( { 1 }, 0 )                , "{.[1].}"                                  )
   TEST_LINE( aDel( { 1 }, 100 )              , "{.[1].}"                                  )
   TEST_LINE( aDel( { 1 }, 1 )                , "{.[1].}"                                  )
   TEST_LINE( aDel( { 1 }, -1 )               , "{.[1].}"                                  )
   TEST_LINE( aDel( { 1 }, 0 )                , "{.[1].}"                                  )
   TEST_LINE( aDel( { 1 }, NIL )              , "{.[1].}"                                  )
   TEST_LINE( aDel( ErrorNew() )              , "ERROR Object"                             )
   TEST_LINE( aDel( ErrorNew(), 0 )           , "ERROR Object"                             )
   TEST_LINE( aDel( ErrorNew(), 100 )         , "ERROR Object"                             )
   TEST_LINE( aDel( ErrorNew(), 1 )           , "ERROR Object"                             )
   TEST_LINE( aDel( ErrorNew(), -1 )          , "ERROR Object"                             )
   TEST_LINE( aDel( ErrorNew(), 0 )           , "ERROR Object"                             )
   TEST_LINE( aDel( ErrorNew(), NIL )         , "ERROR Object"                             )
   TEST_LINE( aIns()                          , NIL                                        )
   TEST_LINE( aIns( NIL )                     , NIL                                        )
   TEST_LINE( aIns( { 1 } )                   , "{.[1].}"                                  )
   TEST_LINE( aIns( { 1 }, 0 )                , "{.[1].}"                                  )
   TEST_LINE( aIns( { 1 }, 100 )              , "{.[1].}"                                  )
   TEST_LINE( aIns( { 1 }, 1 )                , "{.[1].}"                                  )
   TEST_LINE( aIns( { 1 }, -1 )               , "{.[1].}"                                  )
   TEST_LINE( aIns( { 1 }, 0 )                , "{.[1].}"                                  )
   TEST_LINE( aIns( { 1 }, NIL )              , "{.[1].}"                                  )
   TEST_LINE( aIns( ErrorNew() )              , "ERROR Object"                             )
   TEST_LINE( aIns( ErrorNew(), 0 )           , "ERROR Object"                             )
   TEST_LINE( aIns( ErrorNew(), 100 )         , "ERROR Object"                             )
   TEST_LINE( aIns( ErrorNew(), 1 )           , "ERROR Object"                             )
   TEST_LINE( aIns( ErrorNew(), -1 )          , "ERROR Object"                             )
   TEST_LINE( aIns( ErrorNew(), 0 )           , "ERROR Object"                             )
   TEST_LINE( aIns( ErrorNew(), NIL )         , "ERROR Object"                             )
   TEST_LINE( aTail()                         , NIL                                        )
   TEST_LINE( aTail( NIL )                    , NIL                                        )
   TEST_LINE( aTail( "" )                     , NIL                                        )
   TEST_LINE( aTail( {} )                     , NIL                                        )
   TEST_LINE( aTail( { 1, 2 } )               , 2                                          )
   TEST_LINE( aTail( ErrorNew() )             , NIL                                        )
   TEST_LINE( aSize()                         , NIL                                        )
   TEST_LINE( aSize( NIL )                    , NIL                                        )
   TEST_LINE( aSize( {} )                     , NIL                                        )
   TEST_LINE( aSize( ErrorNew() )             , NIL                                        )
   TEST_LINE( aSize( NIL, 0 )                 , NIL                                        )
   TEST_LINE( aSize( {}, 0 )                  , "{.[0].}"                                  )
   TEST_LINE( aSize( ErrorNew(), 0 )          , "ERROR Object"                             )
   TEST_LINE( aSize( NIL, 1 )                 , NIL                                        )
   TEST_LINE( aSize( {}, 1 )                  , "{.[1].}"                                  )
   TEST_LINE( aSize( { 1, 2 }, 1 )            , "{.[1].}"                                  )
   TEST_LINE( aSize( { 1, "AAAA" }, 1 )       , "{.[1].}"                                  )
   TEST_LINE( aSize( { "BBB", "AAAA" }, 0 )   , "{.[0].}"                                  )
   TEST_LINE( aSize( ErrorNew(), 1 )          , "ERROR Object"                             )
   TEST_LINE( aSize( NIL, -1 )                , NIL                                        )
   TEST_LINE( aSize( {}, -1 )                 , "{.[0].}"                                  )
   TEST_LINE( aSize( { 1 }, -1 )              , "{.[0].}"                                  )
#ifdef __HARBOUR__
   TEST_LINE( aSize( { 1 }, 5000 )            , "{.[5000].}"                               )
#else
   TEST_LINE( aSize( { 1 }, 5000 )            , "{.[1].}"                                  )
#endif
   TEST_LINE( aSize( ErrorNew(), -1 )         , "ERROR Object"                             )
   TEST_LINE( aSize( ErrorNew(), 100 )        , "ERROR Object"                             )
   TEST_LINE( aAdd( NIL, NIL )                , "E BASE 1123 Argument error AADD F:S"      )
   TEST_LINE( aAdd( {}, NIL )                 , NIL                                        )
   TEST_LINE( aAdd( {}, "A" )                 , "A"                                        )
   TEST_LINE( aAdd( ErrorNew(), NIL )         , NIL                                        )
   TEST_LINE( aAdd( ErrorNew(), "A" )         , "A"                                        )
   TEST_LINE( Array()                         , NIL                                        )
   TEST_LINE( Array( 0 )                      , "{.[0].}"                                  )
#ifdef __HARBOUR__
   TEST_LINE( Array( 5000 )                   , "{.[5000].}"                               )
#else
   TEST_LINE( Array( 5000 )                   , "E BASE 1131 Bound error array dimension " )
#endif
   TEST_LINE( Array( 1 )                      , "{.[1].}"                                  )
   TEST_LINE( Array( -1 )                     , "E BASE 1131 Bound error array dimension " )
   TEST_LINE( Array( 1, 0, -10 )              , "E BASE 1131 Bound error array dimension " )
   TEST_LINE( Array( 1, 0, "A" )              , NIL                                        )
   TEST_LINE( Array( 1, 0, 2 )                , "{.[1].}"                                  )
   TEST_LINE( Array( 4, 3, 2 )                , "{.[4].}"                                  )
   TEST_LINE( Array( 0, 3, 2 )                , "{.[0].}"                                  )

   /* AFILL() */

   TEST_LINE( TAStr(aFill(TANew(),"X")       ) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",NIL,-2)) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",NIL, 0)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",NIL, 3)) , "XXX......."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",NIL,20)) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  0)   ) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  0,-2)) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  0, 0)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  0, 3)) , "XXX......."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  0,20)) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  1)   ) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  1,-2)) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  1, 0)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  1, 3)) , "XXX......."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  1,20)) , "XXXXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  3)   ) , "..XXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  3,-2)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  3, 0)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  3, 3)) , "..XXX....."     )
   TEST_LINE( TAStr(aFill(TANew(),"X",  3,20)) , "..XXXXXXXX"     )
   TEST_LINE( TAStr(aFill(TANew(),"X", -1)   ) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", -1,-2)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", -1, 0)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", -1, 3)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", -1,20)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", 21)   ) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", 21,-2)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", 21, 0)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", 21, 3)) , ".........."     )
   TEST_LINE( TAStr(aFill(TANew(),"X", 21,20)) , ".........."     )

   /* ACOPY() */

   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1        )) , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1,  0    )) , ".........."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1,  3    )) , "ABC......."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1, 20    )) , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3        )) , "CDEFGHIJ.."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3,  0    )) , ".........."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3,  3    )) , "CDE......."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3, 20    )) , "CDEFGHIJ.."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21        )) , "J........."     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21,  0    )) , ".........."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21,  3    )) , "J........."     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21, 20    )) , "J........."     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1,NIL,  1)) , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1,  0,  1)) , ".........."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1,  3,  0)) , "ABC......."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1,  3,  2)) , ".ABC......"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1,  3,  8)) , ".......ABC"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1,  3, 20)) , ".........A"     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  1, 20,  1)) , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3,NIL,  3)) , "..CDEFGHIJ"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3,  0,  3)) , ".........."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3,  3,  0)) , "CDE......."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3,  3,  2)) , ".CDE......"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3,  3,  8)) , ".......CDE"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3,  3, 20)) , ".........C"     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(),  3, 20,  3)) , "..CDEFGHIJ"     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21,NIL, 21)) , ".........J"     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21,  0, 21)) , ".........."     )
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21,  3,  0)) , "J........."     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21,  3,  2)) , ".J........"     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21,  3,  8)) , ".......J.."     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21,  3, 20)) , ".........J"     ) /* Strange in CA-Cl*pper, it should return: ".........." */
   TEST_LINE( TAStr(aCopy(TARng(),TANew(), 21, 20, 21)) , ".........J"     ) /* Strange in CA-Cl*pper, it should return: ".........." */

   /* ASORT() */

   TEST_LINE( TAStr(aSort(TARRv(),,,{||NIL})) , "ABCDEFGHIJ"     ) /* Bug/Feature in CA-Cl*pper, it will return: "IHGFEDCBAJ" */
   TEST_LINE( TAStr(aSort(TARRv()))           , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(),NIL,NIL))   , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(),NIL, -2))   , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(),NIL,  0))   , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(),NIL,  3))   , "HIJGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(),NIL, 20))   , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(), -5    ))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(), -5, -2))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(), -5,  0))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(), -5,  3))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(), -5, 20))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(),  0    ))   , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(),  0, -2))   , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(),  0,  0))   , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(),  0,  3))   , "HIJGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(),  0, 20))   , "ABCDEFGHIJ"     )
   TEST_LINE( TAStr(aSort(TARRv(),  5    ))   , "JIHGABCDEF"     )
#ifdef __HARBOUR__
   TEST_LINE( TAStr(aSort(TARRv(),  5, -2))   , "JIHGABCDEF"     ) /* CA-Cl*pper will crash or GPF on that line. */
#endif
   TEST_LINE( TAStr(aSort(TARRv(),  5,  0))   , "JIHGABCDEF"     )
   TEST_LINE( TAStr(aSort(TARRv(),  5,  3))   , "JIHGDEFCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(),  5, 20))   , "JIHGABCDEF"     )
   TEST_LINE( TAStr(aSort(TARRv(), 20    ))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(), 20, -2))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(), 20,  0))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(), 20,  3))   , "JIHGFEDCBA"     )
   TEST_LINE( TAStr(aSort(TARRv(), 20, 20))   , "JIHGFEDCBA"     )

   /* ASCAN() */

   TEST_LINE( aScan()                         , 0           )
   TEST_LINE( aScan( NIL )                    , 0           )
   TEST_LINE( aScan( "A" )                    , 0           )
   TEST_LINE( aScan( "A", "A" )               , 0           )
   TEST_LINE( aScan( "A", {|| .F. } )         , 0           )
   TEST_LINE( aScan( {1,2,3}, {|x| NIL } )    , 0           )
   TEST_LINE( aScan( saAllTypes, scString   ) , 1           )
#ifdef __HARBOUR__
   TEST_LINE( aScan( @saAllTypes, scString )  , 1           ) /* Bug in CA-Cl*pper, it will return 0 */
   TEST_LINE( aScan( saAllTypes, @scString )  , 1           ) /* Bug in CA-Cl*pper, it will return 0 */
#endif
   TEST_LINE( aScan( saAllTypes, scStringE  ) , 1           )
   TEST_LINE( aScan( saAllTypes, scStringZ  ) , 3           )
   TEST_LINE( aScan( saAllTypes, snIntZ     ) , 4           )
   TEST_LINE( aScan( saAllTypes, snDoubleZ  ) , 4           )
   TEST_LINE( aScan( saAllTypes, snIntP     ) , 6           )
   TEST_LINE( aScan( saAllTypes, snLongP    ) , 7           )
   TEST_LINE( aScan( saAllTypes, snDoubleP  ) , 8           )
   TEST_LINE( aScan( saAllTypes, snIntN     ) , 9           )
   TEST_LINE( aScan( saAllTypes, snLongN    ) , 10          )
   TEST_LINE( aScan( saAllTypes, snDoubleN  ) , 11          )
   TEST_LINE( aScan( saAllTypes, snDoubleI  ) , 4           )
   TEST_LINE( aScan( saAllTypes, sdDateE    ) , 13          )
   TEST_LINE( aScan( saAllTypes, slFalse    ) , 14          )
   TEST_LINE( aScan( saAllTypes, slTrue     ) , 15          )
   TEST_LINE( aScan( saAllTypes, soObject   ) , 0           )
   TEST_LINE( aScan( saAllTypes, suNIL      ) , 17          )
   TEST_LINE( aScan( saAllTypes, sbBlock    ) , 0           )
   TEST_LINE( aScan( saAllTypes, sbBlockC   ) , 0           )
   TEST_LINE( aScan( saAllTypes, saArray    ) , 0           )
   SET EXACT ON
   TEST_LINE( aScan( saAllTypes, scString   ) , 1           )
   TEST_LINE( aScan( saAllTypes, scStringE  ) , 2           )
   TEST_LINE( aScan( saAllTypes, scStringZ  ) , 3           )
   SET EXACT OFF

   /* MEMVARBLOCK() */

   TEST_LINE( MEMVARBLOCK()                   , NIL             )
   TEST_LINE( MEMVARBLOCK( NIL )              , NIL             )
   TEST_LINE( MEMVARBLOCK( 100 )              , NIL             )
   TEST_LINE( MEMVARBLOCK( "mxNotHere" )      , NIL             )
   TEST_LINE( MEMVARBLOCK( "mcString" )       , "{||...}"       )

   /* Defines for HARDCR() and MEMOTRAN() */

   #define SO Chr( 141 )
   #define NU Chr( 0 )
   #define LF Chr( 10 )
   #define CR Chr( 13 )

   /* HARDCR() */

   TEST_LINE( HardCR()                                                      , ""                                                                                 )
   TEST_LINE( HardCR(NIL)                                                   , ""                                                                                 )
   TEST_LINE( HardCR(100)                                                   , ""                                                                                 )
#ifdef __HARBOUR__
   TEST_LINE( HardCR(@scString)                                             , "HELLO"                                                                            ) /* Bug in CA-Cl*pper, it will return "" */
#endif
   TEST_LINE( HardCR("H"+SO+LF+"P"+SO+LF+"W"+SO+"M")                        , "H"+Chr(13)+""+Chr(10)+"P"+Chr(13)+""+Chr(10)+"W�M"                                )
   TEST_LINE( HardCR("H"+NU+"B"+SO+LF+NU+"P"+SO+LF+"W"+SO+"M"+NU)           , "H"+Chr(0)+"B"+Chr(13)+""+Chr(10)+""+Chr(0)+"P"+Chr(13)+""+Chr(10)+"W�M"+Chr(0)+"" )

   /* MEMOTRAN() */

   TEST_LINE( MemoTran()                                                    , ""                                                 )
   TEST_LINE( MemoTran(NIL)                                                 , ""                                                 )
   TEST_LINE( MemoTran(100)                                                 , ""                                                 )
   TEST_LINE( MemoTran(100,"1","2")                                         , ""                                                 )
#ifdef __HARBOUR__
   TEST_LINE( MemoTran(@scString)                                           , "HELLO"                                            ) /* Bug in CA-Cl*pper, it will return "" */
#endif
   TEST_LINE( MemoTran("H"+SO+LF+"P"+CR+LF+"M")                             , "H P;M"                                            )
   TEST_LINE( MemoTran("H"+NU+"O"+SO+LF+"P"+CR+LF+"M"+NU+"I")               , "H"+Chr(0)+"O P;M"+Chr(0)+"I"                      )
   TEST_LINE( MemoTran("M"+CR+"s"+CR+LF+"w"+SO+"w"+SO+LF+"h"+CR)            , "M"+Chr(13)+"s;w�w h"+Chr(13)+""                   )
   TEST_LINE( MemoTran("M"+CR+"s"+CR+LF+"w"+SO+"w"+SO+LF+"h"+CR,"111","222"), "M"+Chr(13)+"s1w�w2h"+Chr(13)+""                   )
   TEST_LINE( MemoTran("M"+CR+"s"+CR+LF+"w"+SO+"w"+SO+LF+"h"+CR,"","")      , "M"+Chr(13)+"s"+Chr(0)+"w�w"+Chr(0)+"h"+Chr(13)+"" )

   /* MEMOWRITE()/MEMOREAD() */

   TEST_LINE( MemoWrit()                         , .F.              )
   TEST_LINE( MemoWrit("$$MEMOFI.TMP")           , .F.              )
   TEST_LINE( MemoWrit("$$MEMOFI.TMP","")        , .T.              )
   TEST_LINE( MemoRead("$$MEMOFI.TMP")           , ""               )
   TEST_LINE( MemoWrit("$$MEMOFI.TMP",scStringZ) , .T.              )
   TEST_LINE( MemoRead("$$MEMOFI.TMP")           , "A"+Chr(0)+"B"   )
   TEST_LINE( MemoWrit("$$MEMOFI.TMP",Chr(26))   , .T.              )
   TEST_LINE( MemoRead("$$MEMOFI.TMP")           , ""+Chr(26)+""    )
   TEST_LINE( MemoWrit("$$MEMOFI.TMP",scStringW) , .T.              )
   TEST_LINE( MemoRead("$$MEMOFI.TMP")           , ""+Chr(13)+""+Chr(10)+"�"+Chr(10)+""+Chr(9)+"" )
   TEST_LINE( MemoWrit("*INVALI*.TMP",scStringZ) , .F.              )
   TEST_LINE( MemoRead()                         , ""               )
   TEST_LINE( MemoRead("*INVALI*.TMP")           , ""               )

   FErase("$$MEMOFI.TMP")

#ifdef __HARBOUR__

   /* HB_FNAMESPLIT(), HB_FNAMEMERGE() */

   TEST_LINE( TESTFNAME( ""                            ) , ";;;;"                                                                    )
   TEST_LINE( TESTFNAME( "                           " ) , ";;;;"                                                                    )
   TEST_LINE( TESTFNAME( ":                          " ) , ":;:;;;"                                                                  )
   TEST_LINE( TESTFNAME( "C:/WORK\HELLO              " ) , "C:/WORK\HELLO;C:/WORK\;HELLO;;"                                          )
   TEST_LINE( TESTFNAME( "C:\WORK/HELLO              " ) , "C:\WORK/HELLO;C:\WORK/;HELLO;;"                                          )
   TEST_LINE( TESTFNAME( "C:\WORK\HELLO              " ) , "C:\WORK\HELLO;C:\WORK\;HELLO;;"                                          )
   TEST_LINE( TESTFNAME( "C:\WORK\HELLO.             " ) , "C:\WORK\HELLO.;C:\WORK\;HELLO;.;"                                        )
   TEST_LINE( TESTFNAME( "C:\WORK\HELLO.PRG          " ) , "C:\WORK\HELLO.PRG;C:\WORK\;HELLO;.PRG;"                                  )
   TEST_LINE( TESTFNAME( "C:\WORK\HELLO\             " ) , "C:\WORK\HELLO\;C:\WORK\HELLO\;;;"                                        )
   TEST_LINE( TESTFNAME( "C:\WORK\HELLO\.PRG         " ) , "C:\WORK\HELLO\.PRG;C:\WORK\HELLO\;.PRG;;"                                )
   TEST_LINE( TESTFNAME( "C:\WORK\HELLO\A.PRG        " ) , "C:\WORK\HELLO\A.PRG;C:\WORK\HELLO\;A;.PRG;"                              )
   TEST_LINE( TESTFNAME( "C:\WORK\HELLO\A.B.PRG      " ) , "C:\WORK\HELLO\A.B.PRG;C:\WORK\HELLO\;A.B;.PRG;"                          )
   TEST_LINE( TESTFNAME( "C:WORK\HELLO               " ) , "C:WORK\HELLO;C:WORK\;HELLO;;"                                            )
   TEST_LINE( TESTFNAME( "C:WORK\HELLO.              " ) , "C:WORK\HELLO.;C:WORK\;HELLO;.;"                                          )
   TEST_LINE( TESTFNAME( "C:WORK\HELLO.PRG           " ) , "C:WORK\HELLO.PRG;C:WORK\;HELLO;.PRG;"                                    )
   TEST_LINE( TESTFNAME( "C:WORK\HELLO\              " ) , "C:WORK\HELLO\;C:WORK\HELLO\;;;"                                          )
   TEST_LINE( TESTFNAME( "C:WORK\HELLO\.PRG          " ) , "C:WORK\HELLO\.PRG;C:WORK\HELLO\;.PRG;;"                                  )
   TEST_LINE( TESTFNAME( "C:WORK\HELLO\A.PRG         " ) , "C:WORK\HELLO\A.PRG;C:WORK\HELLO\;A;.PRG;"                                )
   TEST_LINE( TESTFNAME( "C:WORK\HELLO\A.B.PRG       " ) , "C:WORK\HELLO\A.B.PRG;C:WORK\HELLO\;A.B;.PRG;"                            )
   TEST_LINE( TESTFNAME( "C:\WORK.OLD\HELLO          " ) , "C:\WORK.OLD\HELLO;C:\WORK.OLD\;HELLO;;"                                  )
   TEST_LINE( TESTFNAME( "C:\WORK.OLD\HELLO.         " ) , "C:\WORK.OLD\HELLO.;C:\WORK.OLD\;HELLO;.;"                                )
   TEST_LINE( TESTFNAME( "C:\WORK.OLD\HELLO.PRG      " ) , "C:\WORK.OLD\HELLO.PRG;C:\WORK.OLD\;HELLO;.PRG;"                          )
   TEST_LINE( TESTFNAME( "C:\WORK.OLD\HELLO\         " ) , "C:\WORK.OLD\HELLO\;C:\WORK.OLD\HELLO\;;;"                                )
   TEST_LINE( TESTFNAME( "C:\WORK.OLD\HELLO\.PRG     " ) , "C:\WORK.OLD\HELLO\.PRG;C:\WORK.OLD\HELLO\;.PRG;;"                        )
   TEST_LINE( TESTFNAME( "C:\WORK.OLD\HELLO\A.PRG    " ) , "C:\WORK.OLD\HELLO\A.PRG;C:\WORK.OLD\HELLO\;A;.PRG;"                      )
   TEST_LINE( TESTFNAME( "C:\WORK.OLD\HELLO\A.B.PRG  " ) , "C:\WORK.OLD\HELLO\A.B.PRG;C:\WORK.OLD\HELLO\;A.B;.PRG;"                  )
   TEST_LINE( TESTFNAME( "C:WORK.OLD\HELLO           " ) , "C:WORK.OLD\HELLO;C:WORK.OLD\;HELLO;;"                                    )
   TEST_LINE( TESTFNAME( "C:WORK.OLD\HELLO.          " ) , "C:WORK.OLD\HELLO.;C:WORK.OLD\;HELLO;.;"                                  )
   TEST_LINE( TESTFNAME( "C:WORK.OLD\HELLO.PRG       " ) , "C:WORK.OLD\HELLO.PRG;C:WORK.OLD\;HELLO;.PRG;"                            )
   TEST_LINE( TESTFNAME( "C:WORK.OLD\HELLO\          " ) , "C:WORK.OLD\HELLO\;C:WORK.OLD\HELLO\;;;"                                  )
   TEST_LINE( TESTFNAME( "C:WORK.OLD\HELLO\.PRG      " ) , "C:WORK.OLD\HELLO\.PRG;C:WORK.OLD\HELLO\;.PRG;;"                          )
   TEST_LINE( TESTFNAME( "C:WORK.OLD\HELLO\A.PRG     " ) , "C:WORK.OLD\HELLO\A.PRG;C:WORK.OLD\HELLO\;A;.PRG;"                        )
   TEST_LINE( TESTFNAME( "C:WORK.OLD\HELLO\A.B.PRG   " ) , "C:WORK.OLD\HELLO\A.B.PRG;C:WORK.OLD\HELLO\;A.B;.PRG;"                    )
   TEST_LINE( TESTFNAME( "C:.OLD\HELLO               " ) , "C:.OLD\HELLO;C:.OLD\;HELLO;;"                                            )
   TEST_LINE( TESTFNAME( "C:.OLD\HELLO.              " ) , "C:.OLD\HELLO.;C:.OLD\;HELLO;.;"                                          )
   TEST_LINE( TESTFNAME( "C:.OLD\HELLO.PRG           " ) , "C:.OLD\HELLO.PRG;C:.OLD\;HELLO;.PRG;"                                    )
   TEST_LINE( TESTFNAME( "C:.OLD\HELLO\              " ) , "C:.OLD\HELLO\;C:.OLD\HELLO\;;;"                                          )
   TEST_LINE( TESTFNAME( "C:.OLD\HELLO\.PRG          " ) , "C:.OLD\HELLO\.PRG;C:.OLD\HELLO\;.PRG;;"                                  )
   TEST_LINE( TESTFNAME( "C:.OLD\HELLO\A.PRG         " ) , "C:.OLD\HELLO\A.PRG;C:.OLD\HELLO\;A;.PRG;"                                )
   TEST_LINE( TESTFNAME( "C:.OLD\HELLO\A.B.PRG       " ) , "C:.OLD\HELLO\A.B.PRG;C:.OLD\HELLO\;A.B;.PRG;"                            )
   TEST_LINE( TESTFNAME( "\\SERVER\WORK\HELLO        " ) , "\\SERVER\WORK\HELLO;\\SERVER\WORK\;HELLO;;"                              )
   TEST_LINE( TESTFNAME( "\\SERVER\WORK\HELLO.       " ) , "\\SERVER\WORK\HELLO.;\\SERVER\WORK\;HELLO;.;"                            )
   TEST_LINE( TESTFNAME( "\\SERVER\WORK\HELLO.PRG    " ) , "\\SERVER\WORK\HELLO.PRG;\\SERVER\WORK\;HELLO;.PRG;"                      )
   TEST_LINE( TESTFNAME( "\\SERVER\WORK\HELLO\       " ) , "\\SERVER\WORK\HELLO\;\\SERVER\WORK\HELLO\;;;"                            )
   TEST_LINE( TESTFNAME( "\\SERVER\WORK\HELLO\.PRG   " ) , "\\SERVER\WORK\HELLO\.PRG;\\SERVER\WORK\HELLO\;.PRG;;"                    )
   TEST_LINE( TESTFNAME( "\\SERVER\WORK\HELLO\A.PRG  " ) , "\\SERVER\WORK\HELLO\A.PRG;\\SERVER\WORK\HELLO\;A;.PRG;"                  )
   TEST_LINE( TESTFNAME( "\\SERVER\WORK\HELLO\A.B.PRG" ) , "\\SERVER\WORK\HELLO\A.B.PRG;\\SERVER\WORK\HELLO\;A.B;.PRG;"              )
   TEST_LINE( TESTFNAME( "\SERVER\WORK\HELLO         " ) , "\SERVER\WORK\HELLO;\SERVER\WORK\;HELLO;;"                                )
   TEST_LINE( TESTFNAME( "\SERVER\WORK\HELLO.        " ) , "\SERVER\WORK\HELLO.;\SERVER\WORK\;HELLO;.;"                              )
   TEST_LINE( TESTFNAME( "\SERVER\WORK\HELLO.PRG     " ) , "\SERVER\WORK\HELLO.PRG;\SERVER\WORK\;HELLO;.PRG;"                        )
   TEST_LINE( TESTFNAME( "\SERVER\WORK\HELLO\        " ) , "\SERVER\WORK\HELLO\;\SERVER\WORK\HELLO\;;;"                              )
   TEST_LINE( TESTFNAME( "\SERVER\WORK\HELLO\.PRG    " ) , "\SERVER\WORK\HELLO\.PRG;\SERVER\WORK\HELLO\;.PRG;;"                      )
   TEST_LINE( TESTFNAME( "\SERVER\WORK\HELLO\A.PRG   " ) , "\SERVER\WORK\HELLO\A.PRG;\SERVER\WORK\HELLO\;A;.PRG;"                    )
   TEST_LINE( TESTFNAME( "\SERVER\WORK\HELLO\A.B.PRG " ) , "\SERVER\WORK\HELLO\A.B.PRG;\SERVER\WORK\HELLO\;A.B;.PRG;"                )
   TEST_LINE( TESTFNAME( "C:\HELLO                   " ) , "C:\HELLO;C:\;HELLO;;"                                                    )
   TEST_LINE( TESTFNAME( "C:\HELLO.                  " ) , "C:\HELLO.;C:\;HELLO;.;"                                                  )
   TEST_LINE( TESTFNAME( "C:\HELLO.PRG               " ) , "C:\HELLO.PRG;C:\;HELLO;.PRG;"                                            )
   TEST_LINE( TESTFNAME( "C:\HELLO\                  " ) , "C:\HELLO\;C:\HELLO\;;;"                                                  )
   TEST_LINE( TESTFNAME( "C:\HELLO\.PRG              " ) , "C:\HELLO\.PRG;C:\HELLO\;.PRG;;"                                          )
   TEST_LINE( TESTFNAME( "C:\HELLO\A.PRG             " ) , "C:\HELLO\A.PRG;C:\HELLO\;A;.PRG;"                                        )
   TEST_LINE( TESTFNAME( "C:\HELLO\A.B.PRG           " ) , "C:\HELLO\A.B.PRG;C:\HELLO\;A.B;.PRG;"                                    )
   TEST_LINE( TESTFNAME( "C:HELLO                    " ) , "C:HELLO;C:;HELLO;;"                                                      )
   TEST_LINE( TESTFNAME( "C:HELLO.                   " ) , "C:HELLO.;C:;HELLO;.;"                                                    )
   TEST_LINE( TESTFNAME( "C:HELLO.PRG                " ) , "C:HELLO.PRG;C:;HELLO;.PRG;"                                              )
   TEST_LINE( TESTFNAME( "C:HELLO\                   " ) , "C:HELLO\;C:HELLO\;;;"                                                    )
   TEST_LINE( TESTFNAME( "C:HELLO\.PRG               " ) , "C:HELLO\.PRG;C:HELLO\;.PRG;;"                                            )
   TEST_LINE( TESTFNAME( "C:HELLO\A.PRG              " ) , "C:HELLO\A.PRG;C:HELLO\;A;.PRG;"                                          )
   TEST_LINE( TESTFNAME( "C:HELLO\A.B.PRG            " ) , "C:HELLO\A.B.PRG;C:HELLO\;A.B;.PRG;"                                      )
   TEST_LINE( TESTFNAME( "\\HELLO                    " ) , "\\HELLO;\\;HELLO;;"                                                      )
   TEST_LINE( TESTFNAME( "\\HELLO.                   " ) , "\\HELLO.;\\;HELLO;.;"                                                    )
   TEST_LINE( TESTFNAME( "\\HELLO.PRG                " ) , "\\HELLO.PRG;\\;HELLO;.PRG;"                                              )
   TEST_LINE( TESTFNAME( "\\HELLO\                   " ) , "\\HELLO\;\\HELLO\;;;"                                                    )
   TEST_LINE( TESTFNAME( "\\.PRG                     " ) , "\\.PRG;\\;.PRG;;"                                                        )
   TEST_LINE( TESTFNAME( "\\A.PRG                    " ) , "\\A.PRG;\\;A;.PRG;"                                                      )
   TEST_LINE( TESTFNAME( "\\A.B.PRG                  " ) , "\\A.B.PRG;\\;A.B;.PRG;"                                                  )
   TEST_LINE( TESTFNAME( "\HELLO                     " ) , "\HELLO;\;HELLO;;"                                                        )
   TEST_LINE( TESTFNAME( "\HELLO.                    " ) , "\HELLO.;\;HELLO;.;"                                                      )
   TEST_LINE( TESTFNAME( "\HELLO.PRG                 " ) , "\HELLO.PRG;\;HELLO;.PRG;"                                                )
   TEST_LINE( TESTFNAME( "\HELLO\                    " ) , "\HELLO\;\HELLO\;;;"                                                      )
   TEST_LINE( TESTFNAME( "\HELLO\.PRG                " ) , "\HELLO\.PRG;\HELLO\;.PRG;;"                                              )
   TEST_LINE( TESTFNAME( "\HELLO\A.PRG               " ) , "\HELLO\A.PRG;\HELLO\;A;.PRG;"                                            )
   TEST_LINE( TESTFNAME( "\HELLO\A.B.PRG             " ) , "\HELLO\A.B.PRG;\HELLO\;A.B;.PRG;"                                        )
   TEST_LINE( TESTFNAME( "HELLO                      " ) , "HELLO;;HELLO;;"                                                          )
   TEST_LINE( TESTFNAME( "HELLO.                     " ) , "HELLO.;;HELLO;.;"                                                        )
   TEST_LINE( TESTFNAME( "HELLO.PRG                  " ) , "HELLO.PRG;;HELLO;.PRG;"                                                  )
   TEST_LINE( TESTFNAME( "HELLO\                     " ) , "HELLO\;HELLO\;;;"                                                        )
   TEST_LINE( TESTFNAME( ".PRG                       " ) , ".PRG;;.PRG;;"                                                            )
   TEST_LINE( TESTFNAME( "A.PRG                      " ) , "A.PRG;;A;.PRG;"                                                          )
   TEST_LINE( TESTFNAME( "A.B.PRG                    " ) , "A.B.PRG;;A.B;.PRG;"                                                      )
   TEST_LINE( TESTFNAME( "                           " ) , ";;;;"                                                                    )
   TEST_LINE( TESTFNAME( "\                          " ) , "\;\;;;"                                                                  )
   TEST_LINE( TESTFNAME( "\\                         " ) , "\\;\\;;;"                                                                )
   TEST_LINE( TESTFNAME( "C                          " ) , "C;;C;;"                                                                  )
   TEST_LINE( TESTFNAME( "C:                         " ) , "C:;C:;;;"                                                                )
   TEST_LINE( TESTFNAME( "C:\                        " ) , "C:\;C:\;;;"                                                              )
   TEST_LINE( TESTFNAME( "C:\\                       " ) , "C:\\;C:\\;;;"                                                            )

#endif

   RETURN NIL

#ifdef __HARBOUR__

STATIC FUNCTION Main_OPOVERL()
   LOCAL oString := HB_TString()

   oString:cValue := "Hello"

   TEST_LINE( oString =  "Hello"        , .T.                 )
   TEST_LINE( oString == "Hello"        , .T.                 )
   TEST_LINE( oString != "Hello"        , .F.                 )
   TEST_LINE( oString <> "Hello"        , .F.                 )
   TEST_LINE( oString #  "Hello"        , .F.                 )
   TEST_LINE( oString $  "Hello"        , .T.                 )
   TEST_LINE( oString <  "Hello"        , .F.                 )
   TEST_LINE( oString <= "Hello"        , .T.                 )
   TEST_LINE( oString <  "Hello"        , .F.                 )
   TEST_LINE( oString <= "Hello"        , .T.                 )
   TEST_LINE( oString +  "Hello"        , "HelloHello"        )
   TEST_LINE( oString -  "Hello"        , "HelloHello"        )
   TEST_LINE( oString * 3               , "HelloHelloHello"   )
   TEST_LINE( oString / 2               , "He"                )
   TEST_LINE( oString % "TST"           , "Hello % TST"       )
   TEST_LINE( oString ^ "TST"           , "Hello ^ TST"       )
   TEST_LINE( oString ** "TST"          , "Hello ^ TST"       )
   IF !TEST_OPT_Z()
   TEST_LINE( oString .AND. "TST"       , "Hello AND TST"     )
   TEST_LINE( oString .OR. "TST"        , "Hello OR TST"      )
   ENDIF
   TEST_LINE( .NOT. oString             , "�����"             )
   TEST_LINE( !oString                  , "�����"             )
   TEST_LINE( oString++                 , "HB_TSTRING Object" )
   TEST_LINE( oString:cValue            , "Hello "            )
   TEST_LINE( oString--                 , "HB_TSTRING Object" )
   TEST_LINE( oString:cValue            , "Hello"             )

   RETURN NIL

STATIC FUNCTION HB_TString()

   STATIC oClass

   IF oClass == NIL
      oClass = TClass():New( "HB_TSTRING" )

      oClass:AddData( "cValue" )

      oClass:AddInline( "=="   , {| self, cTest | ::cValue == cTest } )
      oClass:AddInline( "!="   , {| self, cTest | ::cValue != cTest } )
      oClass:AddInline( "<"    , {| self, cTest | ::cValue <  cTest } )
      oClass:AddInline( "<="   , {| self, cTest | ::cValue <= cTest } )
      oClass:AddInline( ">"    , {| self, cTest | ::cValue >  cTest } )
      oClass:AddInline( ">="   , {| self, cTest | ::cValue >= cTest } )
      oClass:AddInline( "+"    , {| self, cTest | ::cValue +  cTest } )
      oClass:AddInline( "-"    , {| self, cTest | ::cValue -  cTest } )
      oClass:AddInline( "++"   , {| self        | ::cValue += " ", self } )
      oClass:AddInline( "--"   , {| self        | iif( Len( ::cValue ) > 0, ::cValue := Left( ::cValue, Len( ::cValue ) - 1 ), ::cValue ), self } )
      oClass:AddInline( "$"    , {| self, cTest | ::cValue $  cTest } )
      oClass:AddInline( "*"    , {| self, nVal  | Replicate( ::cValue, nVal ) } )
      oClass:AddInline( "/"    , {| self, nVal  | Left( ::cValue, Len( ::cValue ) / nVal ) } )
      oClass:AddInline( "%"    , {| self, cTest | ::cValue + " % " + cTest } )
      oClass:AddInline( "^"    , {| self, cTest | ::cValue + " ^ " + cTest } )
      oClass:AddInline( "**"   , {| self, cTest | ::cValue + " ** " + cTest } )
      oClass:AddInline( "!"    , {| self        | Descend( ::cValue ) } )
      oClass:AddInline( ".NOT.", {| self        | Descend( ::cValue ) } )
      oClass:AddInline( ".AND.", {| self, cTest | ::cValue + " AND " + cTest } )
      oClass:AddInline( ".OR." , {| self, cTest | ::cValue + " OR " + cTest } )

      oClass:AddInline( "HasMsg", {| self, cMsg | __ObjHasMsg( QSelf(), cMsg ) } )

      oClass:Create()
   ENDIF

   RETURN oClass:Instance()

#endif

/* NOTE: These should always be called last, since they can mess up the test
         environment.

         Right now the failing __MRestore() will clear all memory variables,
         which is absolutely normal otherwise. */

STATIC FUNCTION Main_LAST()

   TEST_LINE( MEMVARBLOCK( "mcString" )           , "{||...}"                                         )
   TEST_LINE( __MRestore()                        , "E BASE 2007 Argument error __MRESTORE "          )
   TEST_LINE( MEMVARBLOCK( "mcString" )           , "{||...}"                                         )
   TEST_LINE( __MSave()                           , "E BASE 2008 Argument error __MSAVE "             )
   TEST_LINE( __MRestore( "$NOTHERE.MEM", .F. )   , "E BASE 2005 Open error $NOTHERE.MEM F:DR"        )
   TEST_LINE( MEMVARBLOCK( "mcString" )           , NIL                                               )
   TEST_LINE( __MSave( "*BADNAM*.MEM", "*", .T. ) , "E BASE 2006 Create error *BADNAM*.MEM F:DR"      )

   RETURN NIL

STATIC FUNCTION TEST_BEGIN( cParam )

   s_nStartTime := Seconds()

#ifdef __HARBOUR__
   s_cNewLine := HB_OSNewLine()
#else
   s_cNewLine := Chr( 13 ) + Chr( 10 )
#endif

   s_lShowAll := "/ALL" $ Upper( cParam )
   s_aSkipList := ListToNArray( CMDLGetValue( Upper( cParam ), "/SKIP:", "" ) )

   /* Detect presence of shortcutting optimalization */

   s_lShortcut := .T.
   IF .T. .OR. Eval( {|| s_lShortcut := .F. } )
      /* Do nothing */
   ENDIF

   /* Decide about output filename */

   DO CASE
   CASE "HARBOUR" $ Upper( Version() )     ; s_cFileName := "rtl_test.hb"
   CASE "CLIPPER (R)" $ Upper( Version() ) .AND. ;
        "5.3" $ Version()                  ; s_cFileName := "rtl_test.c53"
   CASE "CLIPPER (R)" $ Upper( Version() ) ; s_cFileName := "rtl_test.c5x"
   ENDCASE

   s_nFhnd := 1 /* FHND_STDOUT */
   s_cFileName := "(stdout)"

   s_nCount := 0
   s_nPass := 0
   s_nFail := 0

   /* Set up the initial state */

/* TODO: Need to add this, when multi language support will be available
         to make sure all error messages comes in the original English
         language. */
/* SET LANGID TO EN */
   SET DATE ANSI
   SET CENTURY ON
   SET EXACT OFF

   FErase( "NOT_HERE.$$$" )

   /* Feedback */

   /* NOTE: The 0 parameter of Version() will force Harbour to include the
            compiler version in the version string. */

   FWrite( s_nFhnd, "      Version: " + Version( 0 ) + s_cNewLine +;
                    "           OS: " + OS() + s_cNewLine +;
                    "   Date, Time: " + DToS( Date() ) + " " + Time() + s_cNewLine +;
                    "       Output: " + s_cFileName + s_cNewLine +;
                    "Shortcut opt.: " + iif( s_lShortcut, "ON", "OFF" ) + s_cNewLine +;
                    "     Switches: " + cParam + s_cNewLine +;
                    "===========================================================================" + s_cNewLine )

   FWrite( s_nFhnd, PadR( "R", TEST_RESULT_COL1_WIDTH ) + " " +;
                    PadR( "Line", TEST_RESULT_COL2_WIDTH ) + " " +;
                    PadR( "TestCall()", TEST_RESULT_COL3_WIDTH ) + " -> " +;
                    PadR( "Result", TEST_RESULT_COL4_WIDTH ) + " | " +;
                    PadR( "Expected", TEST_RESULT_COL5_WIDTH ) + s_cNewLine +;
                    "---------------------------------------------------------------------------" + s_cNewLine )

   /* NOTE: Some basic values we may need for some tests.
            ( passing by reference, avoid preprocessor bugs, etc. ) */

   scString  := "HELLO"
   scStringM := "Hello"
   scStringE := ""
   scStringZ := "A" + Chr( 0 ) + "B"
   scStringW := Chr(13)+Chr(10)+Chr(141)+Chr(10)+Chr(9)
   snIntZ    := 0
   snDoubleZ := 0.0
   snIntP    := 10
   snIntP1   := 65
   snLongP   := 100000
   snDoubleP := 10.567 /* Use different number of decimals than the default */
   snIntN    := -10
   snLongN   := -100000
   snDoubleN := -10.567 /* Use different number of decimals than the default */
   snDoubleI := 0   //Log( 0 )
   sdDate    := SToD( "19800101" )
   sdDateE   := SToD( "" )
   slFalse   := .F.
   slTrue    := .T.
   soObject  := ErrorNew()
   suNIL     := NIL
   sbBlock   := {|| NIL }
   sbBlockC  := {|| "(string)" }
   saArray   := { 9898 }

   saAllTypes := {;
      scString  ,;
      scStringE ,;
      scStringZ ,;
      snIntZ    ,;
      snDoubleZ ,;
      snIntP    ,;
      snLongP   ,;
      snDoubleP ,;
      snIntN    ,;
      snLongN   ,;
      snDoubleN ,;
      snDoubleI ,;
      sdDateE   ,;
      slFalse   ,;
      slTrue    ,;
      soObject  ,;
      suNIL     ,;
      sbBlock   ,;
      sbBlockC  ,;
      saArray   }

   /* NOTE: mxNotHere intentionally not declared */
   PUBLIC mcLongerNameThen10Chars := "Long String Name!"
   PUBLIC mcString  := "HELLO"
   PUBLIC mcStringE := ""
   PUBLIC mcStringZ := "A" + Chr( 0 ) + "B"
   PUBLIC mcStringW := Chr(13)+Chr(10)+Chr(141)+Chr(10)+Chr(9)
   PUBLIC mnIntZ    := 0
   PUBLIC mnDoubleZ := 0.0
   PUBLIC mnIntP    := 10
   PUBLIC mnLongP   := 100000
   PUBLIC mnDoubleP := 10.567
   PUBLIC mnIntN    := -10
   PUBLIC mnLongN   := -100000
   PUBLIC mnDoubleN := -10.567
   PUBLIC mnDoubleI := 0    //Log( 0 )
   PUBLIC mdDate    := SToD( "19800101" )
   PUBLIC mdDateE   := SToD( "" )
   PUBLIC mlFalse   := .F.
   PUBLIC mlTrue    := .T.
   PUBLIC moObject  := ErrorNew()
   PUBLIC muNIL     := NIL
   PUBLIC mbBlock   := {|| NIL }
   PUBLIC mbBlockC  := {|| "(string)" }
   PUBLIC maArray   := { 9898 }

   RETURN NIL

STATIC FUNCTION TEST_CALL( cBlock, bBlock, xResultExpected )
   LOCAL xResult
   LOCAL oError
   LOCAL bOldError
   LOCAL lPPError
   LOCAL lFailed
   LOCAL lSkipped

   s_nCount++

   IF !( ValType( cBlock ) == "C" )
      cBlock := "!! Preprocessor error !!"
      lPPError := .T.
   ELSE
      lPPError := .F.
   ENDIF

   lSkipped := aScan( s_aSkipList, s_nCount ) > 0

   IF lSkipped

      lFailed := .F.
      xResult := "!! Skipped !!"

   ELSE

      bOldError := ErrorBlock( {|oError| Break( oError ) } )

      BEGIN SEQUENCE
         xResult := Eval( bBlock )
      RECOVER USING oError
         xResult := ErrorMessage( oError )
      END SEQUENCE

      ErrorBlock( bOldError )

      IF !( ValType( xResult ) == ValType( xResultExpected ) )
         IF ValType( xResultExpected) == "C" .AND. ValType( xResult ) $ "ABMO"
            lFailed := !( XToStr( xResult ) == xResultExpected )
         ELSE
            lFailed := .T.
         ENDIF
      ELSE
         lFailed := !( xResult == xResultExpected )
      ENDIF

   ENDIF

   IF s_lShowAll .OR. lFailed .OR. lSkipped .OR. lPPError
      FWrite( s_nFhnd, PadR( iif( lFailed, "!", iif( lSkipped, "S", " " ) ), TEST_RESULT_COL1_WIDTH ) + " " +;
                       PadR( ProcName( 1 ) + "(" + LTrim( Str( ProcLine( 1 ), 5 ) ) + ")", TEST_RESULT_COL2_WIDTH ) + " " +;
                       PadR( cBlock, TEST_RESULT_COL3_WIDTH ) + " -> " +;
                       PadR( XToStr( xResult ), TEST_RESULT_COL4_WIDTH ) + " | " +;
                       PadR( XToStr( xResultExpected ), TEST_RESULT_COL5_WIDTH ) )

      FWrite( s_nFhnd, s_cNewLine )

   ENDIF

   IF lFailed
      s_nFail++
   ELSE
      s_nPass++
   ENDIF

   RETURN NIL

STATIC FUNCTION TEST_OPT_Z()
   RETURN s_lShortCut

STATIC FUNCTION TEST_END()

   s_nEndTime := Seconds()

   FWrite( s_nFhnd, "===========================================================================" + s_cNewLine +;
                    "Test calls passed: " + Str( s_nPass ) + s_cNewLine +;
                    "Test calls failed: " + Str( s_nFail ) + s_cNewLine +;
                    "                   ----------" + s_cNewLine +;
                    "            Total: " + Str( s_nPass + s_nFail ) +;
                    " ( Time elapsed: " + LTrim( Str( s_nEndTime - s_nStartTime ) ) + " seconds )" + s_cNewLine +;
                    s_cNewLine )

   IF s_nFail != 0
      IF "CLIPPER (R)" $ Upper( Version() )
         FWrite( s_nFhnd, "WARNING ! Failures detected using CA-Clipper." + s_cNewLine +;
                          "Please fix those expected results which are not bugs in CA-Clipper itself." + s_cNewLine )
      ELSE
         FWrite( s_nFhnd, "WARNING ! Failures detected" + s_cNewLine )
      ENDIF
   ENDIF

   ErrorLevel( iif( s_nFail != 0, 1, 0 ) )

   RETURN NIL

STATIC FUNCTION XToStr( xValue )
   LOCAL cType := ValType( xValue )

   DO CASE
   CASE cType == "C"

      xValue := StrTran( xValue, Chr(0), '"+Chr(0)+"' )
      xValue := StrTran( xValue, Chr(9), '"+Chr(9)+"' )
      xValue := StrTran( xValue, Chr(10), '"+Chr(10)+"' )
      xValue := StrTran( xValue, Chr(13), '"+Chr(13)+"' )
      xValue := StrTran( xValue, Chr(26), '"+Chr(26)+"' )

      RETURN '"' + xValue + '"'

   CASE cType == "N" ; RETURN LTrim( Str( xValue ) )
   CASE cType == "D" ; RETURN 'SToD("' + DToS( xValue ) + '")'
   CASE cType == "L" ; RETURN iif( xValue, ".T.", ".F." )
   CASE cType == "O" ; RETURN xValue:className + " Object"
   CASE cType == "U" ; RETURN "NIL"
   CASE cType == "B" ; RETURN '{||...}'
   CASE cType == "A" ; RETURN '{.[' + LTrim( Str( Len( xValue ) ) ) + '].}'
   CASE cType == "M" ; RETURN 'M:"' + xValue + '"'
   ENDCASE

   RETURN ""

STATIC FUNCTION ErrorMessage( oError )
   LOCAL cMessage := ""
   LOCAL tmp

   IF ValType( oError:severity ) == "N"
      DO CASE
      CASE oError:severity == ES_WHOCARES     ; cMessage += "M "
      CASE oError:severity == ES_WARNING      ; cMessage += "W "
      CASE oError:severity == ES_ERROR        ; cMessage += "E "
      CASE oError:severity == ES_CATASTROPHIC ; cMessage += "C "
      ENDCASE
   ENDIF
   IF ValType( oError:subsystem ) == "C"
      cMessage += oError:subsystem() + " "
   ENDIF
   IF ValType( oError:subCode ) == "N"
      cMessage += LTrim( Str( oError:subCode ) ) + " "
   ENDIF
   IF ValType( oError:description ) == "C"
      cMessage += oError:description + " "
   ENDIF
   IF !Empty( oError:operation )
      cMessage += oError:operation + " "
   ENDIF
   IF !Empty( oError:filename )
      cMessage += oError:filename + " "
   ENDIF

#ifdef _COMMENT_
   IF ValType( oError:Args ) == "A"
      cMessage += "A:"
      FOR tmp := 1 TO Len( oError:Args )
         cMessage += ValType( oError:Args[ tmp ] )
//       cMessage += XToStr( oError:Args[ tmp ] )
//       IF tmp < Len( oError:Args )
//          cMessage += ";"
//       ENDIF
      NEXT
      cMessage += " "
   ENDIF
#endif

   IF oError:canDefault .OR. ;
      oError:canRetry .OR. ;
      oError:canSubstitute

      cMessage += "F:"
      IF oError:canDefault
         cMessage += "D"
      ENDIF
      IF oError:canRetry
         cMessage += "R"
      ENDIF
      IF oError:canSubstitute
         cMessage += "S"
      ENDIF
   ENDIF

   RETURN cMessage

STATIC FUNCTION ListToNArray( cString )
   LOCAL aArray := {}
   LOCAL nPos

   IF !Empty( cString )
      DO WHILE ( nPos := At( ",", cString ) ) > 0
         aAdd( aArray, Val( AllTrim( Left( cString, nPos - 1 ) ) ) )
         cString := SubStr( cString, nPos + 1 )
      ENDDO

      aAdd( aArray, Val( AllTrim( cString ) ) )
   ENDIF

   RETURN aArray

STATIC FUNCTION TANew( cChar, nLen )
   LOCAL aArray
   LOCAL tmp

   IF nLen == NIL
      nLen := 10
   ENDIF

   IF cChar == NIL
      cChar := "."
   ENDIF

   aArray := Array( nLen )

   /* Intentionally not using aFill() here, since this function is
      involved in testing aFill() itself. */
   FOR tmp := 1 TO nLen
      aArray[ tmp ] := cChar
   NEXT

   RETURN aArray

STATIC FUNCTION TARng( nLen )
   LOCAL aArray
   LOCAL tmp

   IF nLen == NIL
      nLen := 10
   ENDIF

   aArray := Array( nLen )

   FOR tmp := 1 TO nLen
      aArray[ tmp ] := Chr( Asc( "A" ) + tmp - 1 )
   NEXT

   RETURN aArray

STATIC FUNCTION TARRv( nLen )
   LOCAL aArray
   LOCAL tmp

   IF nLen == NIL
      nLen := 10
   ENDIF

   aArray := Array( nLen )

   FOR tmp := 1 TO nLen
      aArray[ tmp ] := Chr( Asc( "A" ) + nLen - tmp )
   NEXT

   RETURN aArray

STATIC FUNCTION TAStr( aArray )
   LOCAL cString := ""
   LOCAL tmp

   FOR tmp := 1 TO Len( aArray )
      cString += aArray[ tmp ]
   NEXT

   RETURN cString

STATIC FUNCTION TFORNEXT( xFrom, xTo, xStep )
   LOCAL tmp

   IF xStep == NIL
      FOR tmp := xFrom TO xTo
      NEXT
   ELSE
      FOR tmp := xFrom TO xTo STEP xStep
      NEXT
   ENDIF

   RETURN tmp

STATIC FUNCTION TFORNEXTX( xFrom, xTo, xStep )
   LOCAL tmp
   LOCAL cResult := ""
   LOCAL bFrom := {|| cResult += "F", xFrom }
   LOCAL bTo   := {|| cResult += "T", xTo   }
   LOCAL bStep := {|| cResult += "S", xStep }

   IF xStep == NIL
      FOR tmp := Eval( bFrom ) TO Eval( bTo )
      NEXT
   ELSE
      FOR tmp := Eval( bFrom ) TO Eval( bTo ) STEP Eval( bStep )
      NEXT
   ENDIF

   RETURN cResult

STATIC FUNCTION TFORNEXTXF( xFrom, xTo, xStep )
   LOCAL tmp := -9999
   LOCAL cResult := ""
   LOCAL bFrom := {|| cResult += "F" + LTrim( Str( tmp ) ), xFrom }
   LOCAL bTo   := {|| cResult += "T" + LTrim( Str( tmp ) ), xTo   }
   LOCAL bStep := {|| cResult += "S" + LTrim( Str( tmp ) ), xStep }

   IF xStep == NIL
      FOR tmp := Eval( bFrom ) TO Eval( bTo )
      NEXT
   ELSE
      FOR tmp := Eval( bFrom ) TO Eval( bTo ) STEP Eval( bStep )
      NEXT
   ENDIF

   RETURN cResult + "R" + LTrim( Str( tmp ) )

#ifdef __HARBOUR__

/* NOTE: cDrive is not tested because it's platform dependent. */

STATIC FUNCTION TESTFNAME( cFull )
   LOCAL cPath, cName, cExt, cDrive

   HB_FNameSplit( RTrim( cFull ), @cPath, @cName, @cExt, @cDrive )

   RETURN HB_FNameMerge( cPath, cName, cExt ) + ";" + ;
          cPath + ";" +;
          cName + ";" +;
          cExt + ";" +;
          ""

#endif

STATIC FUNCTION CMDLGetValue( cCommandLine, cName, cRetVal )
   LOCAL tmp, tmp1

   IF ( tmp := At( cName, cCommandLine ) ) > 0
      IF ( tmp1 := At( " ", tmp := SubStr( cCommandLine, tmp + Len( cName ) ) ) ) > 0
           tmp := Left( tmp, tmp1 - 1 )
      ENDIF
      cRetVal := tmp
   ENDIF

   RETURN cRetVal

#ifndef __HARBOUR__
#ifndef __XPP__

STATIC FUNCTION SToD( cDate )
   LOCAL cOldDateFormat
   LOCAL dDate

   IF ValType( cDate ) == "C" .AND. !Empty( cDate )
      cOldDateFormat := Set( _SET_DATEFORMAT, "yyyy/mm/dd" )

      dDate := CToD( SubStr( cDate, 1, 4 ) + "/" +;
                     SubStr( cDate, 5, 2 ) + "/" +;
                     SubStr( cDate, 7, 2 ) )

      Set( _SET_DATEFORMAT, cOldDateFormat )
   ELSE
      dDate := CToD( "" )
   ENDIF

   RETURN dDate

#endif
#endif
