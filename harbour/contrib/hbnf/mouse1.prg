/*
 * $Id$
 */

THREAD STATIC t_lCrsState := .F.
THREAD STATIC t_lMInit := .F.

FUNCTION FT_MDBLCLK( nClick, nButton, nInterval, nRow, nCol, nStart )

   LOCAL nVert, nHorz  // local row and col coordinates
   LOCAL lDouble       // double click actually occurred
   LOCAL lDone         // loop flag
   LOCAL nPrs          // number of presses which occurred

   __defaultNIL( @nClick, 1 )
   __defaultNIL( @nButton, 0 )
   __defaultNIL( @nInterval, 0.5 )
   __defaultNIL( @nRow, MRow() )
   __defaultNIL( @nCol, MCol() )
   __defaultNIL( @nStart, Seconds() )

   nVert := nRow
   nHorz := nCol
   lDouble := lDone := ( nClick == 0 )

   // Wait for first press if requested

   DO WHILE ! lDone

      FT_MBUTPRS( nButton, @nPrs, @nVert, @nHorz )
      nVert := Int( nVert / 8 )
      nHorz := Int( nHorz / 8 )

      lDouble := ( nPrs > 0 )
      ldone := Seconds() - nStart >= nInterval .OR. lDouble

   ENDDO

   // if we have not moved then keep the preliminary double click setting

   lDouble := lDouble .AND. ( nVert == nRow .AND. nHorz == nCol )

   // change start time if we waited for first click. nInterval is the
   // maximum time between clicks not the total time for two clicks if
   // requested.

   IF nClick > 0
      nStart := Seconds()
   ENDIF

   // If we have fulfilled all of the requirements then wait for second click

   IF lDouble

      lDouble := lDone := .F.

      DO WHILE ! lDone

         FT_MBUTPRS( nButton, @nPrs, @nVert, @nHorz )
         nVert := Int( nVert / 8 )
         nHorz := Int( nHorz / 8 )

         lDouble := ( nPrs > 0 )
         lDone := Seconds() - nStart >= nInterval .OR. lDouble

      ENDDO

      // make sure we haven't moved
      lDouble := lDouble .AND. nVert == nRow .AND. nHorz == nCol

   ENDIF

   RETURN lDouble

FUNCTION FT_MINREGION( nTR, nLC, nBR, nRC )

   RETURN ;
      MRow() >= nTR .AND. MRow() <= nBR .AND. ;
      MCol() >= nLC .AND. MCol() <= nRC

FUNCTION FT_MMICKEYS( /* @ */ nX, /* @ */ nY )

   nX := MRow() * 8
   nY := MCol() * 8

   RETURN NIL

FUNCTION FT_MGETPOS( /* @ */ nX, /* @ */ nY )

   nX := MRow() * 8
   nY := MCol() * 8

   RETURN ;
      iif( MLeftDown(), 1, 0 ) + ;
      iif( MRightDown(), 2, 0 ) + ;
      iif( hb_MMiddleDown(), 4, 0 )

FUNCTION FT_MSETPOS( nX, nY )

   RETURN MSetPos( nX / 8, nY / 8 )

FUNCTION FT_MGETCOORD( /* @ */ nX, /* @ */ nY )

   nX := MRow()
   nY := MCol()

   RETURN ;
      iif( MLeftDown(), 1, 0 ) + ;
      iif( MRightDown(), 2, 0 ) + ;
      iif( hb_MMiddleDown(), 4, 0 )

FUNCTION FT_MSETCOORD( nX, nY )

   RETURN MSetPos( nX, nY )

FUNCTION FT_MSETSENS( nHoriz, nVert, nDouble )

   LOCAL nCurHoriz, nCurVert, nCurDouble

   // Get current values

   FT_MGETSENS( @nCurHoriz, @nCurVert, @nCurDouble )

   hb_default( @nHoriz, nCurHoriz )
   hb_default( @nVert, nCurVert )
   hb_default( @nDouble, nCurDouble )

   // Fill the registers
   _ft_MSetSensitive( nHoriz, nVert, nDouble )

   RETURN NIL

FUNCTION FT_MVERSION( /* @ */ nMinor, /* @ */ nType, /* @ */ nIRQ )

   nMinor := 20
   nType := 2 /* serial */
   nIRQ := 3

   RETURN 8

FUNCTION FT_MINIT()

// If not previously initialized then try

   IF ! t_lMInit
      t_lMInit := ( FT_MRESET() != 0 )
   ELSE
      MSetBounds()
   ENDIF

   RETURN t_lMInit

FUNCTION FT_MRESET()

   t_lCrsState := .F. // Cursor is off after reset
   MHide()
   MSetBounds()
   MSetPos( ( MaxRow() + 1 ) / 2, ( MaxCol() + 1 ) / 2 )

   RETURN iif( MPresent(), -1, 0 )

FUNCTION FT_MCURSOR( lState )

   LOCAL lSavState := t_lCrsState

   IF HB_ISLOGICAL( lState )
      IF ( t_lCrsState := lState )
         MShow()
      ELSE
         MHide()
      ENDIF
   ENDIF

   RETURN lSavState

FUNCTION FT_MSHOWCRS()

   MShow()

   t_lCrsState := .T.

   RETURN NIL                // no output from function

FUNCTION FT_MHIDECRS() // decrement internal cursor flag and hide cursor

   MHide()

   t_lCrsState := .F.

   RETURN NIL                // no output from function

FUNCTION FT_MXLIMIT( nMin, nMax )

   LOCAL nTop, nBottom

   hb_MGetBounds( @nTop,, @nBottom )
   MSetBounds( nTop, nMin, nBottom, nMax )

   RETURN NIL

FUNCTION FT_MYLIMIT( nMin, nMax )

   LOCAL nLeft, nRight

   hb_MGetBounds(, @nLeft,, @nRight )
   MSetBounds( nMin, nLeft, nMax, nRight )

   RETURN NIL

/* NOTE: This is what original NFLib did, returned
         vertical position (row) as X and
         horizontal position (col) as Y. [vszakats] */

FUNCTION FT_MGETX()

   RETURN MRow()

FUNCTION FT_MGETY()

   RETURN MCol()

FUNCTION FT_MGETPAGE()

   RETURN 0

   /* NOTE: Page is ignored in Harbour */

FUNCTION FT_MSETPAGE( nPage )

   HB_SYMBOL_UNUSED( nPage )

   RETURN NIL
