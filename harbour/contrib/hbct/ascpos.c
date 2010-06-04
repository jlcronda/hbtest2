/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *   CT3 string function
 *     - ASCPOS
 *     - VALPOS
 *
 * Copyright 2001 IntTec GmbH, Neunlindenstr 32, 79106 Freiburg, Germany
 *        Author: Martin Vogel <vogel@inttec.de>
 *
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */


#include "ct.h"


/* defines */
#define DO_ASCPOS_ASCPOS    0
#define DO_ASCPOS_VALPOS    1

/* helper function */
static void do_ascpos( int iSwitch )
{
   if( HB_ISCHAR( 1 ) )
   {
      HB_SIZE sStrSize = hb_parclen( 1 );
      const HB_BYTE * pcString = ( const HB_BYTE * ) hb_parc( 1 );
      HB_SIZE sPos;

      if( HB_ISNUM( 2 ) )
         sPos = hb_parnl( 2 );
      else
         sPos = sStrSize;

      if( ( sPos == 0 ) || ( sPos > sStrSize ) )
      {
         hb_retni( 0 );
      }
      else
      {
         if( iSwitch == DO_ASCPOS_VALPOS )
         {
            if( HB_ISDIGIT( ( HB_UCHAR ) pcString[ sPos - 1 ] ) )
               hb_retnl( pcString[ sPos - 1 ] - 48 );
            else
               hb_retni( 0 );
         }
         else                   /* iSwitch == DO_ASCPOS_ASCPOS */
         {
            hb_retnl( pcString[sPos - 1] );
         }
      }
   }
   else
   {
      PHB_ITEM pSubst = NULL;
      int iArgErrorMode = ct_getargerrormode();

      if( iArgErrorMode != CT_ARGERR_IGNORE )
      {
         pSubst = ct_error_subst( ( HB_USHORT ) iArgErrorMode, EG_ARG,
                                  iSwitch == DO_ASCPOS_VALPOS ?
                                  CT_ERROR_VALPOS : CT_ERROR_ASCPOS, NULL,
                                  HB_ERR_FUNCNAME, 0, EF_CANSUBSTITUTE,
                                  HB_ERR_ARGS_BASEPARAMS );
      }

      if( pSubst != NULL )
      {
         hb_itemReturnRelease( pSubst );
      }
      else
      {
         hb_retni( 0 );
      }
   }
}


/*  $DOC$
 *  $FUNCNAME$
 *      ASCPOS()
 *  $CATEGORY$
 *      CT3 string functions
 *  $ONELINER$
 *      ASCII value of a character at a certain position
 *  $SYNTAX$
 *      ASCPOS (<cString>, [<nPosition>]) --> nAsciiValue
 *  $ARGUMENTS$
 *      <cString>      is the processed string
 *      [<nPosition>]  is an optional position within <cString>
 *                     Default: last position in <cString>
 *  $RETURNS$
 *      <nAsciiValue>  the ASCII value of the character at the specified
 *                     position
 *  $DESCRIPTION$
 *      The ASCPOS() function returns the ASCII value of the character that
 *      can be found at the position <nPosition> in <cString>. If <nPosition>
 *      is larger than the length of <cString>, 0 is returned.
 *  $EXAMPLES$
 *      ? ascpos ("0123456789") --> 57
 *      ? ascpos ("0123456789",1) --> 48
 *  $TESTS$
 *      ascpos ("0123456789") == 57
 *      ascpos ("0123456789",1) == 48
 *      ascpos ("0123456789",11) == 0  // <nPosition> to large !
 *  $STATUS$
 *      Ready
 *  $COMPLIANCE$
 *      ASCPOS() is compatible with CT3's ASCPOS().
 *  $PLATFORMS$
 *      All
 *  $FILES$
 *      Source is asciisum.c, library is libct.
 *  $SEEALSO$
 *      VALPOS()
 *  $END$
 */

HB_FUNC( ASCPOS )
{
   do_ascpos( DO_ASCPOS_ASCPOS );
}


/*  $DOC$
 *  $FUNCNAME$
 *      VALPOS()
 *  $CATEGORY$
 *      CT3 string functions
 *  $ONELINER$
 *      Numerical value of a character at a certain position
 *  $SYNTAX$
 *      VALPOS (<cString>, [<nPosition>]) --> nDigitValue
 *  $ARGUMENTS$
 *      <cString>      is the processed string
 *      [<nPosition>]  is an optional position within <cString>
 *                     Default: last position in <cString>
 *  $RETURNS$
 *      <nDigitValue>  the numerical value of the character at the specified
 *                     position
 *  $DESCRIPTION$
 *      The VALPOS() function returns the numerical value of the character that
 *      can be found at the position <nPosition> in <cString>. If no digit
 *      can be found at this position or if <nPosition>
 *      is larger than the length of <cString>, 0 is returned.
 *  $EXAMPLES$
 *      ? valpos ("1234x56789") --> 9
 *      ? valpos ("1234x56789",1) --> 1
 *  $TESTS$
 *      valpos ("1234x56789") == 9
 *      valpos ("1234x56789",1) == 1
 *      valpos ("1234x56789",11) == 0  // <nPosition> to large !
 *      valpos ("1234x56789",5) == 0   // "x" is not a digit !
 *  $STATUS$
 *      Ready
 *  $COMPLIANCE$
 *      VALPOS() is compatible with CT3's VALPOS().
 *  $PLATFORMS$
 *      All
 *  $FILES$
 *      Source is asciisum.c, library is libct.
 *  $SEEALSO$
 *      ASCPOS()
 *  $END$
 */

HB_FUNC( VALPOS )
{
   do_ascpos( DO_ASCPOS_VALPOS );
}
