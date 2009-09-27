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
#include "hbqt.h"

/*----------------------------------------------------------------------*/
#if QT_VERSION >= 0x040500
/*----------------------------------------------------------------------*/

/*
 *  enum PrintDialogOption
 *  flags PrintDialogOptions
 */


#include <QtGui/QPrintDialog>


/*
 * QPrintDialog ( QPrinter * printer, QWidget * parent = 0 )
 * QPrintDialog ( QWidget * parent = 0 )
 * ~QPrintDialog ()
 */
HB_FUNC( QT_QPRINTDIALOG )
{
   hb_retptr( ( QPrintDialog* ) new QPrintDialog ( hbqt_par_QWidget( 1 ) ) );
}

/*
 * DESTRUCTOR
 */
HB_FUNC( QT_QPRINTDIALOG_DESTROY )
{
   delete hbqt_par_QPrintDialog( 1 );
}

/*
 * virtual void done ( int result )
 */
HB_FUNC( QT_QPRINTDIALOG_DONE )
{
   hbqt_par_QPrintDialog( 1 )->done( hb_parni( 2 ) );
}

/*
 * void open ( QObject * receiver, const char * member )
 */
HB_FUNC( QT_QPRINTDIALOG_OPEN )
{
   hbqt_par_QPrintDialog( 1 )->open( hbqt_par_QObject( 2 ), hbqt_par_char( 3 ) );
}

/*
 * PrintDialogOptions options () const
 */
HB_FUNC( QT_QPRINTDIALOG_OPTIONS )
{
   hb_retni( ( QPrintDialog::PrintDialogOptions ) hbqt_par_QPrintDialog( 1 )->options() );
}

/*
 * QPrinter * printer () const
 */
HB_FUNC( QT_QPRINTDIALOG_PRINTER )
{
   hb_retptr( ( QPrinter* ) hbqt_par_QPrintDialog( 1 )->printer() );
}

/*
 * QPrinter * printer ()
 */
HB_FUNC( QT_QPRINTDIALOG_PRINTER_1 )
{
   hb_retptr( ( QPrinter* ) hbqt_par_QPrintDialog( 1 )->printer() );
}

/*
 * void setOption ( PrintDialogOption option, bool on = true )
 */
HB_FUNC( QT_QPRINTDIALOG_SETOPTION )
{
   hbqt_par_QPrintDialog( 1 )->setOption( ( QPrintDialog::PrintDialogOption ) hb_parni( 2 ), hb_parl( 3 ) );
}

/*
 * void setOptions ( PrintDialogOptions options )
 */
HB_FUNC( QT_QPRINTDIALOG_SETOPTIONS )
{
   hbqt_par_QPrintDialog( 1 )->setOptions( ( QPrintDialog::PrintDialogOptions ) hb_parni( 2 ) );
}

/*
 * virtual void setVisible ( bool visible )
 */
HB_FUNC( QT_QPRINTDIALOG_SETVISIBLE )
{
   hbqt_par_QPrintDialog( 1 )->setVisible( hb_parl( 2 ) );
}

/*
 * bool testOption ( PrintDialogOption option ) const
 */
HB_FUNC( QT_QPRINTDIALOG_TESTOPTION )
{
   hb_retl( hbqt_par_QPrintDialog( 1 )->testOption( ( QPrintDialog::PrintDialogOption ) hb_parni( 2 ) ) );
}


/*----------------------------------------------------------------------*/
#endif             /* #if QT_VERSION >= 0x040500 */
/*----------------------------------------------------------------------*/
