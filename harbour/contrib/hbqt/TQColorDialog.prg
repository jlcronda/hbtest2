/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * QT wrapper main header
 *
 * Copyright 2009 Pritpal Bedi <pritpal@vouchcac.com>
 *
 * Copyright 2009 Marcos Antonio Gambeta <marcosgambeta at gmail dot com>
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
/*----------------------------------------------------------------------*/


#include "hbclass.ch"


CREATE CLASS QColorDialog INHERIT QDialog

   VAR     pParent
   VAR     pPtr

   METHOD  New()
   METHOD  Configure( xObject )
   METHOD  Destroy()                           INLINE  Qt_QColorDialog_destroy( ::pPtr )

   METHOD  currentColor()                      INLINE  Qt_QColorDialog_currentColor( ::pPtr )
   METHOD  open()                              INLINE  Qt_QColorDialog_open( ::pPtr )
   METHOD  options()                           INLINE  Qt_QColorDialog_options( ::pPtr )
   METHOD  selectedColor()                     INLINE  Qt_QColorDialog_selectedColor( ::pPtr )
   METHOD  setCurrentColor( pColor )           INLINE  Qt_QColorDialog_setCurrentColor( ::pPtr, pColor )
   METHOD  setOption( nOption, lOn )           INLINE  Qt_QColorDialog_setOption( ::pPtr, nOption, lOn )
   METHOD  setOptions( nOptions )              INLINE  Qt_QColorDialog_setOptions( ::pPtr, nOptions )
   METHOD  setVisible( lVisible )              INLINE  Qt_QColorDialog_setVisible( ::pPtr, lVisible )
   METHOD  testOption( nOption )               INLINE  Qt_QColorDialog_testOption( ::pPtr, nOption )
   METHOD  customColor( nIndex )               INLINE  Qt_QColorDialog_customColor( ::pPtr, nIndex )
   METHOD  customCount()                       INLINE  Qt_QColorDialog_customCount( ::pPtr )
   METHOD  getColor( pInitial, pParent, cTitle, nOptions )  INLINE  Qt_QColorDialog_getColor( ::pPtr, pInitial, pParent, cTitle, nOptions )
   METHOD  getColor_1( pInitial, pParent )     INLINE  Qt_QColorDialog_getColor_1( ::pPtr, pInitial, pParent )
   METHOD  setCustomColor( nIndex, nColor )    INLINE  Qt_QColorDialog_setCustomColor( ::pPtr, nIndex, nColor )
   METHOD  setStandardColor( nIndex, nColor )  INLINE  Qt_QColorDialog_setStandardColor( ::pPtr, nIndex, nColor )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD New( pParent ) CLASS QColorDialog

   ::pParent := pParent

   ::pPtr := Qt_QColorDialog( pParent )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD Configure( xObject ) CLASS QColorDialog

   IF hb_isObject( xObject )
      ::pPtr := xObject:pPtr
   ELSEIF hb_isPointer( xObject )
      ::pPtr := xObject
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

