/*
 * $Id$
 */

/* -------------------------------------------------------------------- */
/* WARNING: Automatically generated source file. DO NOT EDIT!           */
/*          Instead, edit corresponding .qth file,                      */
/*          or the generator tool itself, and run regenarate.           */
/* -------------------------------------------------------------------- */

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

#include "hbapi.h"
#include "../hbqt.h"

/*----------------------------------------------------------------------*/
#if QT_VERSION >= 0x040500
/*----------------------------------------------------------------------*/

/*
 *  enum FontFilter { AllFonts, ScalableFonts, NonScalableFonts, MonospacedFonts, ProportionalFonts }
 *  flags FontFilters
 */

#include <QtCore/QPointer>

#include <QtGui/QFontComboBox>


/*
 * QFontComboBox ( QWidget * parent = 0 )
 * ~QFontComboBox ()
 */

QT_G_FUNC( release_QFontComboBox )
{
#if defined(__debug__)
   hb_snprintf( str, sizeof(str), "release_QFontComboBox" );  OutputDebugString( str );
#endif
   void * ph = ( void * ) Cargo;
   if( ph )
   {
      const QMetaObject * m = ( ( QObject * ) ph )->metaObject();
      if( ( QString ) m->className() != ( QString ) "QObject" )
      {
         delete ( ( QFontComboBox * ) ph );
         ph = NULL;
      }
      else
      {
#if defined(__debug__)
   hb_snprintf( str, sizeof(str), "  Object Name Missing: QFontComboBox" );  OutputDebugString( str );
#endif
      }
   }
}

HB_FUNC( QT_QFONTCOMBOBOX )
{
   QGC_POINTER * p = ( QGC_POINTER * ) hb_gcAlloc( sizeof( QGC_POINTER ), Q_release );
   QPointer< QFontComboBox > pObj = NULL;

   pObj = ( QFontComboBox * ) new QFontComboBox( hbqt_par_QWidget( 1 ) ) ;

   p->ph = pObj;
   p->func = release_QFontComboBox;

   hb_retptrGC( p );
}
/*
 * QFont currentFont () const
 */
HB_FUNC( QT_QFONTCOMBOBOX_CURRENTFONT )
{
   hb_retptrGC( hbqt_ptrTOgcpointer( new QFont( hbqt_par_QFontComboBox( 1 )->currentFont() ), release_QFont ) );
}

/*
 * FontFilters fontFilters () const
 */
HB_FUNC( QT_QFONTCOMBOBOX_FONTFILTERS )
{
   hb_retni( ( QFontComboBox::FontFilters ) hbqt_par_QFontComboBox( 1 )->fontFilters() );
}

/*
 * void setFontFilters ( FontFilters filters )
 */
HB_FUNC( QT_QFONTCOMBOBOX_SETFONTFILTERS )
{
   hbqt_par_QFontComboBox( 1 )->setFontFilters( ( QFontComboBox::FontFilters ) hb_parni( 2 ) );
}

/*
 * void setWritingSystem ( QFontDatabase::WritingSystem script )
 */
HB_FUNC( QT_QFONTCOMBOBOX_SETWRITINGSYSTEM )
{
   hbqt_par_QFontComboBox( 1 )->setWritingSystem( ( QFontDatabase::WritingSystem ) hb_parni( 2 ) );
}

/*
 * QFontDatabase::WritingSystem writingSystem () const
 */
HB_FUNC( QT_QFONTCOMBOBOX_WRITINGSYSTEM )
{
   hb_retni( ( QFontDatabase::WritingSystem ) hbqt_par_QFontComboBox( 1 )->writingSystem() );
}

/*
 * void setCurrentFont ( const QFont & font )
 */
HB_FUNC( QT_QFONTCOMBOBOX_SETCURRENTFONT )
{
   hbqt_par_QFontComboBox( 1 )->setCurrentFont( *hbqt_par_QFont( 2 ) );
}


/*----------------------------------------------------------------------*/
#endif             /* #if QT_VERSION >= 0x040500 */
/*----------------------------------------------------------------------*/
