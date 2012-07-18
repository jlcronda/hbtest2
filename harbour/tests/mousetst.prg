/*
 * $Id$
 */

/*
 * Copyright 2000 Alejandro de Garate <alex_degarate@hotmail.com>
 *
 * Test mouse for Harbour
 */

#include "inkey.ch"

PROCEDURE Main()

   LOCAL nR := 5, nC := 38

   SET CURSOR OFF
   ? "."; CLS
   IF ! MPresent()
      ? " No mouse present !"
      QUIT
   ENDIF

   @  0, 0 TO MaxRow(), MaxCol() DOUBLE
   @ MaxRow() - 2,  0 TO MaxRow(), 18 DOUBLE
   @ MaxRow() - 1,  2 SAY "Y:"
   @ MaxRow() - 1, 10 SAY "X:"

   @ nR    ,  2 SAY "Mouse Type    : "
   @ nR + 1,  2 SAY "Buttons number: "
   @ nR + 1, 18 SAY NUMBUTTONS() PICT "9"

   IF NUMBUTTONS() == 2
      @ nR, 18 SAY "Micros*ft mouse"
   ELSE
      @ nR, 18 SAY "Mouse System"
   ENDIF

   @ MaxRow() - 2, 68 TO MaxRow(), MaxCol() DOUBLE
   @ MaxRow() - 1, 70 SAY "Exit"

   @ 10, 02 SAY " -- Checkings --  "
   @ 11, 02 SAY "Window Boundaries :"
   @ 12, 02 SAY "Press/Release But.:"
   @ 13, 02 SAY "Double Click Left :"
   @ 14, 02 SAY "Double Click Right:"

   TEST1()

   TEST2( nR, nC )

   @ 24, 0 SAY ""

   SET CURSOR ON
   ?

   RETURN

FUNCTION MUPDATE()

   @ MaxRow() - 1, 04 SAY MRow() PICT "9999"
   @ MaxRow() - 1, 12 SAY MCol() PICT "9999"

   RETURN 0

FUNCTION MINRECT( nTop, nLeft, nBott, nRight )

   LOCAL lInside := .F.

   IF MRow() >= nTop .AND. MRow() <= nBott
      IF MCol() >= nLeft .AND. MCol() <= nRight
         lInside := .T.
      ENDIF
   ENDIF

   RETURN lInside

   // First test: Check the boundaries of the main window

PROCEDURE TEST1

   LOCAL nKey

   @ MaxRow() - 3, 25 SAY "Move the cursor until the UPPER side "
   MUPDATE()

   DO WHILE ( nKey := Inkey( 0, INKEY_ALL ) ) != K_TAB
      MUPDATE()
      IF nKey == K_MOUSEMOVE
         IF MRow() < 1
            EXIT
         ENDIF
         CHECKEXIT()
      ENDIF
   ENDDO

   @ MaxRow() - 3, 25 SAY "Move the cursor until the BOTTOM side  "

   DO WHILE ( nKey := Inkey( 0, INKEY_ALL ) ) != K_TAB
      MUPDATE()
      IF nKey == K_MOUSEMOVE
         IF MRow() > MaxRow() - 1
            EXIT
         ENDIF
         CHECKEXIT()
      ENDIF
   ENDDO


   @ MaxRow() - 3, 25 SAY "Move the cursor until the LEFT side  "

   DO WHILE ( nKey := Inkey( 0, INKEY_ALL ) ) != K_TAB
      MUPDATE()
      IF nKey == K_MOUSEMOVE
         IF MCol() < 1
            EXIT
         ENDIF
         CHECKEXIT()
      ENDIF
   ENDDO


   @ MaxRow() - 3, 25 SAY "Move the cursor until the RIGHT side "

   DO WHILE ( nKey := Inkey( 0, INKEY_ALL ) ) != K_TAB
      MUPDATE()
      IF nKey == K_MOUSEMOVE
         IF MCol() > MaxCol() - 1
            EXIT
         ENDIF
         CHECKEXIT()
      ENDIF
   ENDDO

   @ MaxRow() - 3, 20 SAY Space( 50 )
   @ 11, 22 SAY "Pass"

   RETURN

   // Second test: check the button pressing

PROCEDURE TEST2 ( nR, nC )

   LOCAL cSkip := "", nKey, nPress := 0

   @ nR     , nC SAY  "�������������������Ŀ"
   @ nR +  1, nC SAY  "� ���ͻ       ���ͻ �"
   @ nR +  2, nC SAY  "� �   �       �   � �"
   @ nR +  3, nC SAY  "� �   �       �   � �"
   @ nR +  4, nC SAY  "� ���ͼ       ���ͼ �"
   @ nR +  5, nC SAY  "�������������������Ĵ"
   @ nR +  6, nC SAY  "�  Up          Up   �"
   @ nR +  7, nC SAY  "�                   �"
   @ nR +  8, nC SAY  "�                   �"
   @ nR +  9, nC SAY  "�           Harbour �"
   @ nR + 10, nC SAY  "�            mouse  �"
   @ nR + 11, nC SAY  "���������������������"

   IF NUMBUTTONS() == 3
      @ nR + 1, nC SAY  "� ���ͻ ���ͻ ���ͻ �"
      @ nR + 2, nC SAY  "� �   � �   � �   � �"
      @ nR + 3, nC SAY  "� �   � �   � �   � �"
      @ nR + 4, nC SAY  "� ���ͼ ���ͼ ���ͼ �"
      @ nR + 6, nC SAY  "�  Up    Up    Up   �"
   ENDIF

   Set( _Set_EVENTMASK, INKEY_ALL )

   IF ! Empty( cSkip )
      IF Upper( cSkip ) == "BREAK"
         SetCancel( .T. )
      ELSE
         SetCancel( .F. )
      END IF
   END IF

   MUPDATE()

   WHILE ( nKey := Inkey( 0, INKEY_ALL ) ) != K_TAB

      DO CASE
      CASE nKey == K_MOUSEMOVE
         // mouse has been moved
         IF MINRECT( 19, 40, 22, 60 )
            MHide()
         ELSE
            MShow()
         ENDIF
         CHECKEXIT()
         MUPDATE()

      CASE nKey == K_LBUTTONDOWN
         // Left mouse button was pushed
         @ nR + 2, nC + 3 SAY "���"
         @ nR + 3, nC + 3 SAY "���"
         @ nR + 6, nC + 3 SAY "Down"
         nPress ++

      CASE nKey == K_LBUTTONUP
         // Left mouse button was released
         @ nR + 2, nC + 3 SAY "   "
         @ nR + 3, nC + 3 SAY "   "
         @ nR + 6, nC + 3 SAY "Up  "

      CASE nKey == K_MBUTTONDOWN
         // Middle mouse button was pushed
         @ nR + 2, nC + 10 SAY "���"
         @ nR + 3, nC + 10 SAY "���"
         @ nR + 6, nC + 10 SAY "Down"
         nPress ++

      CASE nKey == K_MBUTTONUP
         // Middle mouse button was released
         @ nR + 6, nC + 10 SAY "Up  "

      CASE nKey == K_RBUTTONDOWN
         // Right mouse button was pushed
         @ nR + 2, nC + 15 SAY "���"
         @ nR + 3, nC + 15 SAY "���"
         @ nR + 6, nC + 15 SAY "Down"
         nPress ++

      CASE nKey == K_RBUTTONUP
         // Right mouse button was released
         @ nR + 2, nC + 15 SAY "   "
         @ nR + 3, nC + 15 SAY "   "
         @ nR + 6, nC + 15 SAY "Up  "

      CASE nKey == K_LDBLCLK
         // "The left mouse button was double-clicked."
         @ 13, 22 SAY "Pass"

      CASE nKey == K_RDBLCLK
         // "The right mouse button was double-clicked."
         @ 14, 22 SAY "Pass"

         OTHERWISE
         @ MaxRow(), 20 SAY "A keyboard key was pressed: "
         @ MaxRow(), 48 SAY nKey
         @ MaxRow(), 58 SAY iif( nKey >= 32 .AND. nKey <= 255, Chr( nKey ), "" )
      END CASE

      IF nPress > 6
         EXIT
      ENDIF

   ENDDO

   @ MaxRow() - 3, 20 SAY Space( 50 )
   @ 12, 22 SAY "Pass"

   SET CURSOR ON

   @ 20, 01 SAY "MOUSE TEST FINISH!"
   ?

   RETURN

PROCEDURE CHECKEXIT()

   IF ! MINRECT( MaxRow() - 2, MaxCol() - 11, MaxRow(), MaxCol() )
      RETURN
   ENDIF
   SET CURSOR ON
   CLS
   ? "MOUSE TEST FINISH!"
   ?
   QUIT
