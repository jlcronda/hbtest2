/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Compiler main file
 *
 * Copyright 1999 {list of individual authors and e-mail addresses}
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

#include "hbsetup.h"

#if defined(DOS) && defined(__BORLANDC__)
   #include <limits.h>
   extern unsigned _stklen = UINT_MAX;
#endif

extern int harbour_main( int argc, char * argv[] );

int main( int argc, char * argv[] )
{
   return harbour_main( argc, argv );
}

#if defined(__IBMCPP__) || defined(_MSC_VER)
int isatty( int handle )
{
   return ( handle < 4 ) ? 1 : 0;
}
#endif
