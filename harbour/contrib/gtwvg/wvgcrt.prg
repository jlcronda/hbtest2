/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Source file for the Wvg*Classes
 *
 * Copyright 2008 Pritpal Bedi <pritpal@vouchcac.com>
 * http://www.harbour-project.org
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
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
 *
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                    Xbase++ Compatible xbpCrt Class
 *
 *                 Pritpal Bedi  <pritpal@vouchcac.com>
 *                              08Nov2008
 *
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/

#include 'hbclass.ch'
#include 'common.ch'
#include 'inkey.ch'
#include 'hbgtinfo.ch'

#include 'hbgtwvg.ch'
#include 'wvtwin.ch'
#include 'wvgparts.ch'

/*----------------------------------------------------------------------*/

CLASS WvgCrt  INHERIT  WvgWindow, WvgPartHandler

   DATA     oMenu

   /*  CONFIGURATION */
   DATA     alwaysOnTop                           INIT  .F.        /* Determines whether the dialog can be covered by other windows */
   DATA     border                                INIT  0          /* Border type for the XbpCrt window */
   DATA     clipChildren                          INIT  .F.
   DATA     closable                              INIT  .T.
   DATA     fontHeight                            INIT  16
   DATA     fontName                              INIT  'Courier New'
   DATA     fontWidth                             INIT  8
   DATA     gridMove                              INIT  .F.
   DATA     icon                                  INIT  0
   DATA     minMax                                INIT  .T.
   DATA     sysMenu                               INIT  .T.
   DATA     taskList                              INIT  .T.
   DATA     title                                 INIT  ' '
   DATA     titleBar                              INIT  .T.
   DATA     visible                               INIT  .T.

   DATA     autoFocus                             INIT  .T.
   DATA     autoMark                              INIT  .T.
   DATA     dropFont                              INIT  .T.
   DATA     dropZone                              INIT  .F.
   DATA     helpLink                              INIT  NIL
   DATA     maxCol                                INIT  79
   DATA     maxRow                                INIT  24
   DATA     mouseMode                             INIT  1          /* Determines whether mouse coordinates are given as graphics or text coordinates.*/
   DATA     modalResult                           INIT  NIL        /* Specifies the result of a modal dialog.                                        */
   DATA     aSyncFlush                            INIT  .F.        /* Determines the display behavior of text-mode output.                           */
   DATA     tooltipText                           INIT  ''
   DATA     useShortCuts                          INIT  .F.        /* Enables shortcut keys for the system menu                                      */
   DATA     xSize                                 INIT  640 READONLY
   DATA     ySize                                 INIT  400 READONLY

   /*  GUI Specifics */
   DATA     animate                               INIT  .F.
   DATA     clipParent                            INIT  .F.
   DATA     clipSiblings                          INIT  .T.
   DATA     group                                 INIT  0          /* XBP_NO_GROUP */
   DATA     sizeRedraw                            INIT  .F.
   DATA     tabStop                               INIT  .F.

   /*  CALLBACK SLOTS */
   DATA     sl_enter
   DATA     sl_leave
   DATA     sl_lbClick
   DATA     sl_lbDblClick
   DATA     sl_lbDown
   DATA     sl_lbUp
   DATA     sl_mbClick
   DATA     sl_mbDblClick
   DATA     sl_mbDown
   DATA     sl_mbUp
   DATA     sl_motion
   DATA     sl_rbClick
   DATA     sl_rbDblClick
   DATA     sl_rbDown
   DATA     sl_rbUp
   DATA     sl_wheel

   DATA     sl_close
   DATA     sl_helpRequest
   DATA     sl_keyboard
   DATA     sl_killDisplayFocus                    /* only for CRT */
   DATA     sl_killInputFocus
   DATA     sl_move
   DATA     sl_paint                               /* only for gui dialogs */
   DATA     sl_quit
   DATA     sl_resize
   DATA     sl_setDisplayFocus                     /* only for CRT */
   DATA     sl_setInputFocus
   DATA     sl_dragEnter
   DATA     sl_dragMotion
   DATA     sl_dragLeave
   DATA     sl_dragDrop

EXPORTED:
   /*  LIFE CYCLE */
   METHOD   init()
   METHOD   create()
   METHOD   configure()
   METHOD   destroy()

   METHOD   setTitle( cTitle )                    INLINE ::title := cTitle, hb_gtInfo( HB_GTI_WINTITLE, cTitle )
   METHOD   getTitle()                            INLINE hb_gtInfo( HB_GTI_WINTITLE )

   /*  METHODS */
   METHOD   currentPos()
   METHOD   currentSize()
   METHOD   captureMouse()
   METHOD   disable()
   METHOD   enable()
   METHOD   getFrameState()
   METHOD   getHWND()
   METHOD   getModalState()
   METHOD   hasInputFocus()
   METHOD   hide()
   METHOD   invalidateRect()
   METHOD   isEnabled()
   METHOD   isVisible()
   METHOD   lockPS()
   METHOD   lockUpdate()
   METHOD   menuBar()
   METHOD   setColorBG()
   METHOD   setColorFG()
   METHOD   setFont()
   METHOD   setFontCompoundName()
   METHOD   setFrameState()
   METHOD   setPresParam()
   METHOD   setModalState()
   METHOD   setPointer()
   METHOD   setTrackPointer()
   METHOD   setPos()
   METHOD   setPosAndSize()
   METHOD   setSize()
   METHOD   showModal()
   METHOD   show()
   METHOD   toBack()
   METHOD   toFront()
   METHOD   unlockPS()
   METHOD   winDevice()

   /* MESSAGES  */
   METHOD   enter()                               SETGET
   METHOD   leave()                               SETGET
   METHOD   lbClick()                             SETGET
   METHOD   lbDblClick()                          SETGET
   METHOD   lbDown()                              SETGET
   METHOD   lbUp()                                SETGET
   METHOD   mbClick()                             SETGET
   METHOD   mbDblClick()                          SETGET
   METHOD   mbDown()                              SETGET
   METHOD   mbUp()                                SETGET
   METHOD   motion()                              SETGET
   METHOD   rbClick()                             SETGET
   METHOD   rbDblClick()                          SETGET
   METHOD   rbDown()                              SETGET
   METHOD   rbUp()                                SETGET
   METHOD   wheel()                               SETGET

   /*  OTHER MESSAGES */
   METHOD   close()                               SETGET
   METHOD   helpRequest()                         SETGET
   METHOD   keyboard()                            SETGET
   METHOD   killDisplayFocus()                    SETGET
   METHOD   killInputFocus()                      SETGET
   METHOD   move()                                SETGET
   METHOD   paint()                               SETGET
   METHOD   quit()                                SETGET
   METHOD   resize()                              SETGET
   METHOD   setDisplayFocus()                     SETGET
   METHOD   setInputFocus()                       SETGET
   METHOD   dragEnter()                           SETGET
   METHOD   dragMotion()                          SETGET
   METHOD   dragLeave()                           SETGET
   METHOD   dragDrop()                            SETGET

   /*  HARBOUR implementation */
   DATA     resizable                             INIT  .t.
   DATA     resizeMode                            INIT  HB_GTI_RESIZEMODE_FONT
   DATA     style                                 INIT  (WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + WS_SIZEBOX + WS_MINIMIZEBOX + WS_MAXIMIZEBOX)
   DATA     exStyle                               INIT  0
   DATA     lModal                                INIT  .f.
   DATA     pGTp
   DATA     pGT
   DATA     objType                               INIT  objTypeCrt
   DATA     ClassName                             INIT  'WVGCRT'

   METHOD   setFocus()

   DATA     drawingArea
   DATA     hWnd
   DATA     aPos                                  INIT  { 0,0 }
   DATA     aSize                                 INIT  { 24,79 }
   DATA     aPresParams                           INIT  {}

   DATA     lHasInputFocus                        INIT  .F.
   DATA     nFrameState                           INIT  0  /* normal */

   METHOD   showWindow()                          INLINE ::show()
   METHOD   refresh()                             INLINE ::invalidateRect()
   ENDCLASS

/*----------------------------------------------------------------------*/
 *                         Instance Initiation
/*----------------------------------------------------------------------*/

METHOD init( oParent, oOwner, aPos, aSize, aPresParams, lVisible ) CLASS WvgCrt

   ::WvgWindow:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   if hb_isArray( aPos )
      ::aPos := aPos
   endif
   if hb_isArray( aSize )
      ::aSize := aSize
   endif
   if hb_isArray( aPresParams )
      ::aPresParams := aPresParams
   endif
   if hb_isLogical( lVisible )
      ::visible := lVisible
   endif

   RETURN Self

/*----------------------------------------------------------------------*/
 *                              Life Cycle
/*----------------------------------------------------------------------*/

METHOD create( oParent, oOwner, aPos, aSize, aPresParams, lVisible ) CLASS WvgCrt
   Local lRowCol := .T.

   DEFAULT oParent     TO ::oParent
   DEFAULT oOwner      TO ::oOwner
   DEFAULT aPos        TO ::aPos
   DEFAULT aSize       TO ::aSize
   DEFAULT aPresParams TO ::aPresParams
   DEFAULT lVisible    TO ::visible

   ::oParent     := oParent
   ::oOwner      := oOwner
   ::aPos        := aPos
   ::aSize       := aSize
   ::aPresParams := aPresParams
   ::visible     := lVisible

   ::maxRow := ::aSize[ 1 ]
   ::maxCol := ::aSize[ 2 ]

   ::WvgWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   if ::lModal
      ::pGT  := hb_gtCreate( 'WVG' )
      ::pGTp := hb_gtSelect( ::pGT )
   else
      hb_gtReload( 'WVG' )
      ::pGT := hb_gtSelect()
   endif

   if ::lModal
      ::style := WS_POPUP + WS_CAPTION + WS_SYSMENU
      #if 0
      if !( ::resizable )
         ::exStyle := WS_EX_DLGMODALFRAME
         ::style += WS_DLGFRAME
      ENDIF
      #endif
   endif

   hb_gtInfo( HB_GTI_PRESPARAMS, { ::exStyle, ::style, ::aPos[ 1 ], ::aPos[ 2 ], ;
                           ::maxRow+1, ::maxCol+1, ::pGTp, .F., lRowCol, HB_WNDTYPE_CRT } )
   hb_gtInfo( HB_GTI_SETFONT, { ::fontName, ::fontHeight, ::fontWidth } )

   IF hb_isNumeric( ::icon )
      hb_gtInfo( HB_GTI_ICONRES, ::icon )
   ELSE
      IF ( '.ico' $ lower( ::icon ) )
         hb_gtInfo( HB_GTI_ICONFILE, ::icon )
      ELSE
         hb_gtInfo( HB_GTI_ICONRES, ::icon )
      ENDIF
   ENDIF

   /* CreateWindow() be forced to execute */
   ? ' '
   ::hWnd := hb_gtInfo( HB_GTI_SPEC, HB_GTS_WINDOWHANDLE )

   hb_gtInfo( HB_GTI_RESIZABLE , ::resizable )
   Hb_GtInfo( HB_GTI_CLOSABLE  , ::closable  )
   hb_gtInfo( HB_GTI_WINTITLE  , ::title     )
   hb_gtInfo( HB_GTI_RESIZEMODE, if( ::resizeMode == HB_GTI_RESIZEMODE_ROWS, HB_GTI_RESIZEMODE_ROWS, HB_GTI_RESIZEMODE_FONT ) )


   IF ::lModal
      hb_gtInfo( HB_GTI_DISABLE, ::pGTp )
   ENDIF

   IF ::visible
      Hb_GtInfo( HB_GTI_SPEC, HB_GTS_SHOWWINDOW, SW_NORMAL )
      ::lHasInputFocus := .t.
   ENDIF

   /*  Drawing Area of oCrt will point to itself */
   ::drawingArea := self

   HB_GtInfo( HB_GTI_NOTIFIERBLOCK, {|nEvent, ...| ::notifier( nEvent, ... ) } )

   /*  Not working yet. need to investigate how I have implemented it. */
   if !empty( ::toolTipText )
      Wvt_SetTooltip( ::toolTipText )
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible ) CLASS WvgCrt

   DEFAULT oParent     TO ::oParent
   DEFAULT oOwner      TO ::oOwner
   DEFAULT aPos        TO ::aPos
   DEFAULT aSize       TO ::sSize
   DEFAULT aPresParams TO ::aPresParams
   DEFAULT lVisible    TO ::visible

   ::oParent     := oParent
   ::oOwner      := oOwner
   ::aPos        := aPos
   ::aSize       := aSize
   ::aPresParams := aPresParams
   ::visible     := lVisible

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD destroy() CLASS WvgCrt

   IF hb_isObject( ::oMenu )
      ::oMenu:destroy()
   ENDIF

   IF Len( ::aChildren ) > 0
      aeval( ::aChildren, {|o| o:destroy() } )
   ENDIF

   if ::lModal
      hb_gtInfo( HB_GTI_ENABLE  , ::pGTp )
      hb_gtSelect( ::pGTp )
      hb_gtInfo( HB_GTI_SETFOCUS, ::pGTp )
   ENDIF

   ::pGT  := NIL
   ::pGTp := NIL

   RETURN Self

/*----------------------------------------------------------------------*/
 *                              Methods
/*----------------------------------------------------------------------*/

METHOD currentPos() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD currentSize() CLASS WvgCrt

   RETURN { hb_gtInfo( HB_GTI_SCREENWIDTH ), hb_gtInfo( HB_GTI_SCREENHEIGHT ) }

/*----------------------------------------------------------------------*/

METHOD captureMouse() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD disable() CLASS WvgCrt

   hb_gtInfo( HB_GTI_DISABLE, ::pGT )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD enable() CLASS WvgCrt

   hb_gtInfo( HB_GTI_ENABLE, ::pGT )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD getFrameState() CLASS WvgCrt

   IF Win_IsIconic( ::hWnd )
      RETURN WVGDLG_FRAMESTAT_MINIMIZED
   ENDIF
   IF Win_IsZoomed( ::hWnd )
      RETURN WVGDLG_FRAMESTAT_MAXIMIZED
   ENDIF

   RETURN WVGDLG_FRAMESTAT_NORMALIZED

/*----------------------------------------------------------------------*/

METHOD getHWND() CLASS WvgCrt

   RETURN ::hWnd

/*----------------------------------------------------------------------*/

METHOD getModalState() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD hasInputFocus() CLASS WvgCrt

   RETURN ::lHasInputFocus

/*----------------------------------------------------------------------*/

METHOD hide() CLASS WvgCrt

   hb_gtInfo( HB_GTI_SPEC, HB_GTS_SHOWWINDOW, HB_GTS_SW_HIDE )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD invalidateRect( nTop, nLeft, nBottom, nRight ) CLASS WvgCrt

   DEFAULT nTop TO 0
   DEFAULT nLeft TO 0
   DEFAULT nBottom TO maxrow()
   DEFAULT nRight TO maxcol()

   Wvt_InvalidateRect( nTop, nLeft, nBottom, nRight )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD isEnabled() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD isVisible() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD lockPS() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD lockUpdate() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD menuBar() CLASS WvgCrt

   IF !( hb_isObject( ::oMenu ) )
      ::oMenu := WvgMenuBar():New( self ):create()
   ENDIF

   RETURN ::oMenu

/*----------------------------------------------------------------------*/

METHOD setColorBG() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setColorFG() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setFont() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setFontCompoundName() CLASS WvgCrt

   RETURN ''

/*----------------------------------------------------------------------*/

METHOD setFrameState( nState ) CLASS WvgCrt
   Local lSuccess := .f.

   DO CASE

   CASE nState == WVGDLG_FRAMESTAT_MINIMIZED
      lSuccess := ::sendMessage( WM_SYSCOMMAND, SC_MINIMIZE, 0 )

   CASE nState == WVGDLG_FRAMESTAT_MAXIMIZED
      lSuccess := ::sendMessage( WM_SYSCOMMAND, SC_MAXIMIZE, 0 )

   CASE nState == WVGDLG_FRAMESTAT_NORMALIZED
      lSuccess := ::sendMessage( WM_SYSCOMMAND, SC_RESTORE, 0 )

   ENDCASE

   RETURN lSuccess
/*----------------------------------------------------------------------*/

METHOD setModalState() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setPointer() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setTrackPointer() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setPos() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setPosAndSize() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setPresParam() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setSize( aSize, lPaint ) CLASS WvgCrt

   if hb_isArray( aSize )
      DEFAULT lPaint TO .T.

      hb_gtInfo( HB_GTI_SCREENHEIGHT, aSize[ 1 ] )
      hb_gtInfo( HB_GTI_SCREENWIDTH , aSize[ 2 ] )
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD show() CLASS WvgCrt

   Hb_GtInfo( HB_GTI_SPEC, HB_GTS_SHOWWINDOW, SW_NORMAL )
   ::lHasInputFocus := .t.

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD showModal() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD toBack() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD toFront() CLASS WvgCrt
   RETURN Win_SetWindowPosToTop( ::hWnd )

/*----------------------------------------------------------------------*/

METHOD unlockPS() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD winDevice() CLASS WvgCrt

   RETURN Self

/*----------------------------------------------------------------------*/
 *                           Callback Methods
/*----------------------------------------------------------------------*/

METHOD enter( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_enter )
      eval( ::sl_enter, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_enter := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD leave( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_leave )
      eval( ::sl_leave, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_leave := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD lbClick( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_lbClick )
      eval( ::sl_lbClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_lbClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD lbDblClick( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_lbDblClick )
      eval( ::sl_lbDblClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_lbDblClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD lbDown( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_lbDown )
      eval( ::sl_lbDown, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_lbDown := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD lbUp( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_lbUp )
      eval( ::sl_lbUp, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_lbUp := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD mbClick( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_mbClick )
      eval( ::sl_mbClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_mbClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD mbDblClick( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_mbDblClick )
      eval( ::sl_mbDblClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_mbDblClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD mbDown( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_mbDown )
      eval( ::sl_mbDown, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_mbDown := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD mbUp( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_mbUp )
      eval( ::sl_mbUp, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_mbUp := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD motion( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_motion )
      eval( ::sl_motion, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_motion := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD rbClick( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_rbClick )
      eval( ::sl_rbClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_rbClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD rbDblClick( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_rbDblClick )
      eval( ::sl_rbDblClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_rbDblClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD rbDown( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_rbDown )
      eval( ::sl_rbDown, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_rbDown := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD rbUp( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_rbUp )
      eval( ::sl_rbUp, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_rbUp := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD wheel( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_wheel )
      eval( ::sl_wheel, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_wheel := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/
 *                           Other Messages
/*----------------------------------------------------------------------*/

METHOD close( xParam ) CLASS WvgCrt

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_close )
      eval( ::sl_close, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_close := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD helpRequest( xParam ) CLASS WvgCrt

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_helpRequest )
      eval( ::sl_helpRequest, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_helpRequest := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD keyboard( xParam ) CLASS WvgCrt

   if hb_isNumeric( xParam ) .and. hb_isBlock( ::sl_keyboard )
      eval( ::sl_keyboard, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_keyboard := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD killDisplayFocus( xParam ) CLASS WvgCrt

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_killDisplayFocus )
      eval( ::sl_killDisplayFocus, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_killDisplayFocus := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD killInputFocus( xParam ) CLASS WvgCrt

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_killInputFocus )
      eval( ::sl_killInputFocus, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_killInputFocus := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD move( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_move )
      eval( ::sl_move, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_move := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD paint( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_paint )
      eval( ::sl_paint, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_paint := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD quit( xParam, xParam1 ) CLASS WvgCrt

   if hb_isNumeric( xParam ) .and. hb_isBlock( ::sl_quit )
      eval( ::sl_quit, xParam, xParam1, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_quit := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD resize( xParam ) CLASS WvgCrt

   if hb_isBlock( xParam )/* .or. hb_isNil( xParam ) */
      ::sl_resize := xParam
      RETURN NIL
   endif
   IF empty( xParam )
      ::sendMessage( WM_SIZE, 0, 0 )
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setDisplayFocus( xParam ) CLASS WvgCrt

   if hb_isNil( xParam ) .and. hb_isBlock( ::setDisplayFocus )
      eval( ::setDisplayFocus, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::setDisplayFocus := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD setInputFocus( xParam ) CLASS WvgCrt

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_setInputFocus )
      eval( ::sl_setInputFocus, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_setInputFocus := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD dragEnter( xParam, xParam1 ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_dragEnter )
      eval( ::sl_dragEnter, xParam, xParam1, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_dragEnter := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD dragMotion( xParam ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_dragMotion )
      eval( ::sl_dragMotion, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_dragMotion := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD dragLeave( xParam ) CLASS WvgCrt

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_dragLeave )
      eval( ::sl_dragLeave, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_dragLeave := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD dragDrop( xParam, xParam1 ) CLASS WvgCrt

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_dragDrop )
      eval( ::sl_dragDrop, xParam, xParam1, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_dragDrop := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/
 *                          HARBOUR SPECIFIC
/*----------------------------------------------------------------------*/
METHOD SetFocus() CLASS WvgCrt

   ::sendMessage( WM_ACTIVATE, 1, 0 )
   /* ::sendMessage( WM_SETFOCUS, 0, 0 ) */

   RETURN Self
/*----------------------------------------------------------------------*/
