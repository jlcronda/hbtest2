/*
 * $Id$
 */

/*
 * xHarbour Project source code:
 * Random number generator routine
 *
 * Copyright 2003 Giancarlo Niccolai <gian@niccolai.ws>
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

#include "hbapi.h"
#include "hbdate.h"

#include <stdlib.h>
#include <float.h>

/* Globally available data, no need to MT it */
static volatile HB_BOOL s_fInit = HB_FALSE;

/*
 * HB_RANDOM
 *
 * HB_RANDOM() --> returns a real value n so that 0 <= n < 1
 * HB_RANDOM( x ) --> returns a real number n so that 0 <= n < x
 * HB_RANDOM( x, y ) --> Returns a real number n so that x <= n < y
 */
HB_FUNC( HB_RANDOM )
{
   double dRnd = hb_random_num();

   if( ! HB_ISNUM( 1 ) )
      hb_retnd( dRnd );
   else if( ! HB_ISNUM( 2 ) )
      hb_retnd( dRnd * hb_parnd( 1 ) );
   else
   {
      double dX = hb_parnd( 2 );
      double dY = hb_parnd( 1 );
      if( dX > dY )
      {
         double dZ = dY;
         dY = dX;
         dX = dZ;
      }
      hb_retnd( dRnd * ( dY - dX ) + dX );
   }
}

/*
 * HB_RANDOMINT
 *
 * HB_RANDOMINT() --> returns 0 or 1, evenly distributed
 * HB_RANDOMINT( N ) --> returns an integer between 1 and N (inclusive)
 * HB_RANDOMINT( x, y ) --> Returns an integer number between x and y (inclusive)
 * The integer returned is of the longest type available
 */
HB_FUNC( HB_RANDOMINT )
{
   double dRnd = hb_random_num();

   if( ! HB_ISNUM( 1 ) )
      hb_retni( dRnd >= 0.5 ? 0 : 1 );
   else if( ! HB_ISNUM( 2 ) )
      hb_retnint( ( HB_MAXINT ) ( 1 + ( dRnd * hb_parnint( 1 ) ) ) );
   else
   {
      HB_MAXINT lX = hb_parnint( 1 );
      HB_MAXINT lY = hb_parnint( 2 );
      if( lX > lY )
      {
         HB_MAXINT lZ = lY;
         lY = lX;
         lX = lZ;
      }
      hb_retnint( ( HB_MAXINT ) ( lX + ( dRnd * ( lY - lX + 1 ) ) ) );
   }
}

HB_FUNC( HB_RANDOMSEED )
{
   srand( HB_ISNUM( 1 ) ? ( unsigned ) hb_parni( 1 ) : ( unsigned ) hb_dateMilliSeconds() );
   s_fInit = HB_TRUE;
}

HB_FUNC( HB_RANDOMINTMAX )
{
#if RAND_MAX > HB_VMLONG_MAX
   hb_retnd( RAND_MAX );
#else
   hb_retnint( RAND_MAX );
#endif
}

/* Returns a double value between 0 and 1 */
double hb_random_num( void )
{
   double d1, d2;

   if( ! s_fInit )
   {
      srand( ( unsigned ) hb_dateMilliSeconds() );
      s_fInit = HB_TRUE;
   }

   d1 = ( double ) rand();
   d2 = ( double ) RAND_MAX + 1.0;

   return d1 / d2;
}
