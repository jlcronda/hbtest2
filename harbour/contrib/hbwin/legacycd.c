/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Compatibility calls (DLL).
 *
 * Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://www.harbour-project.org
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

/* This functions are deprecated, kept for compatibility with old
   3rd party tools. Please update your code to use new API,
   the old one will be removed in a future revision. [vszakats] */

/* NOTE: Add to this file functions coming from old DLL source only.
         [vszakats] */

#include "hbwin.h"

#if ! defined( HB_LEGACY_LEVEL3 ) && ! defined( HB_WIN_LEGACY_LEVEL_OFF )
   #define HB_WIN_LEGACY_LEVEL_OFF
#endif

#if ! defined( HB_WIN_LEGACY_LEVEL_OFF )

/* Please use WAPI_GETLASTERROR(). */
HB_FUNC( GETLASTERROR )
{
   hb_retnl( GetLastError() );
}

/* Please use WAPI_SETLASTERROR(). */
HB_FUNC( SETLASTERROR )
{
   hb_retnl( GetLastError() );
   SetLastError( hb_parnl( 1 ) );
}

HB_FUNC( LOADLIBRARY )
{
   void * hFileName;

   hb_retnint( ( HB_PTRDIFF ) LoadLibrary( HB_PARSTRDEF( 1, &hFileName, NULL ) ) );

   hb_strfree( hFileName );
}

HB_FUNC( FREELIBRARY )
{
   if( HB_ISPOINTER( 1 ) )
      hb_retl( FreeLibrary( ( HMODULE ) hb_parptr( 1 ) ) ? HB_TRUE : HB_FALSE );
   else if( HB_ISNUM( 1 ) )
      hb_retl( FreeLibrary( ( HMODULE ) ( HB_PTRDIFF ) hb_parnint( 1 ) ) ? HB_TRUE : HB_FALSE );
   else
      hb_retl( HB_FALSE );
}

HB_FUNC( GETPROCADDRESS )
{
   HMODULE hDLL;

   if( HB_ISNUM( 1 ) )
      hDLL = ( HMODULE ) ( HB_PTRDIFF ) hb_parnint( 1 );
   else
      hDLL = ( HMODULE ) hb_parptr( 1 );

   hb_retptr( hDLL ? ( void * ) hbwin_getprocaddress( hDLL, 2, NULL ) : NULL );
}

#ifndef HB_WIN_NO_LEGACY
#define HB_WIN_NO_LEGACY
#endif
#undef HB_LEGACY_LEVEL3

#include "hbwin.ch"

HB_FUNC( CALLDLL )
{
   hbwin_dllCall( HB_WIN_DLL_CALLCONV_STDCALL, HB_WIN_DLL_CTYPE_DEFAULT, HB_FALSE, ( FARPROC ) hb_parptr( 1 ), hb_pcount(), 2, NULL );
}

HB_FUNC( CALLDLLBOOL )
{
   hbwin_dllCall( HB_WIN_DLL_CALLCONV_STDCALL, HB_WIN_DLL_CTYPE_BOOL   , HB_FALSE, ( FARPROC ) hb_parptr( 1 ), hb_pcount(), 2, NULL );
}

HB_FUNC( CALLDLLTYPED )
{
   hbwin_dllCall( HB_WIN_DLL_CALLCONV_STDCALL, hb_parni( 2 )           , HB_FALSE, ( FARPROC ) hb_parptr( 1 ), hb_pcount(), 3, NULL );
}

#endif
