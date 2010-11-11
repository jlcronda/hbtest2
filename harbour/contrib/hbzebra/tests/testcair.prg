/*
 * $Id$
 */

#include "hbzebra.ch"
#include "hbcairo.ch"

PROCEDURE main()
   LOCAL hCairo, hSurface

   hSurface := cairo_pdf_surface_create( "testcair.pdf", 567, 794 )  // A4

   hCairo := cairo_create( hSurface )
   cairo_set_source_rgb( hCairo, 1.0, 1.0, 1.0 )
   cairo_paint( hCairo )
   cairo_select_font_face( hCairo, "sans-serif", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL )
   cairo_set_font_size( hCairo, 10 )
   cairo_set_source_rgb( hCairo, 0, 0, 0 )

   DrawBarcode( hCairo,  20,   1, "EAN13",   "477012345678" )
   DrawBarcode( hCairo,  40,   1, "EAN8",    "1234567" )
   DrawBarcode( hCairo,  60,   1, "UPCA",    "01234567891" )
   DrawBarcode( hCairo,  80,   1, "UPCE",    "123456" )
   DrawBarcode( hCairo, 100,   1, "CODE39",  "ABC123" )
   DrawBarcode( hCairo, 120,   1, "CODE39",  "ABC123", HB_ZEBRA_FLAG_CHECKSUM )
   DrawBarcode( hCairo, 140, 0.5, "CODE39",  "ABC123", HB_ZEBRA_FLAG_CHECKSUM + HB_ZEBRA_FLAG_WIDE2_5 )
   DrawBarcode( hCairo, 160,   1, "CODE39",  "ABC123", HB_ZEBRA_FLAG_CHECKSUM + HB_ZEBRA_FLAG_WIDE3 )
   DrawBarcode( hCairo, 180,   1, "ITF",     "1234", HB_ZEBRA_FLAG_WIDE3 )
   DrawBarcode( hCairo, 200,   1, "ITF",     "12345678901", HB_ZEBRA_FLAG_CHECKSUM )
   DrawBarcode( hCairo, 220,   1, "MSI",     "1234" )
   DrawBarcode( hCairo, 240,   1, "MSI",     "1234", HB_ZEBRA_FLAG_CHECKSUM + HB_ZEBRA_FLAG_WIDE3 )
   DrawBarcode( hCairo, 260,   1, "MSI",     "1234567", HB_ZEBRA_FLAG_CHECKSUM )
   DrawBarcode( hCairo, 280,   1, "CODABAR", "40156", HB_ZEBRA_FLAG_WIDE3 )
   DrawBarcode( hCairo, 300,   1, "CODABAR", "-1234", HB_ZEBRA_FLAG_WIDE3 )
   DrawBarcode( hCairo, 320,   1, "CODE93",  "ABC-123" )
   DrawBarcode( hCairo, 340,   1, "CODE93",  "TEST93" )
   DrawBarcode( hCairo, 360,   1, "CODE11",  "12", HB_ZEBRA_FLAG_WIDE3 )
   DrawBarcode( hCairo, 380,   1, "CODE11",  "1234567890", HB_ZEBRA_FLAG_CHECKSUM + HB_ZEBRA_FLAG_WIDE3 )
   DrawBarcode( hCairo, 400,   1, "CODE128", "Code 128")
   DrawBarcode( hCairo, 420,   1, "CODE128", "1234567890")
   DrawBarcode( hCairo, 440,   1, "CODE128", "Wikipedia")
   DrawBarcode( hCairo, 460,   1, "PDF417",  "Hello, World of Harbour!!! It's 2D barcode PDF417 :)" )

   cairo_destroy( hCairo )
   cairo_surface_write_to_png( hSurface, "testcair.png" )
   cairo_surface_destroy( hSurface )
   RETURN


PROCEDURE DrawBarcode( hCairo, nY, nLineWidth, cType, cCode, nFlags )
   LOCAL hZebra, nLineHeight

   IF cType == "EAN13"
      hZebra := hb_zebra_create_ean13( cCode, nFlags )
   ELSEIF cType == "EAN8"
      hZebra := hb_zebra_create_ean8( cCode, nFlags )
   ELSEIF cType == "UPCA"
      hZebra := hb_zebra_create_upca( cCode, nFlags )
   ELSEIF cType == "UPCE"
      hZebra := hb_zebra_create_upce( cCode, nFlags )
   ELSEIF cType == "CODE39"
      hZebra := hb_zebra_create_code39( cCode, nFlags )
   ELSEIF cType == "ITF"
      hZebra := hb_zebra_create_itf( cCode, nFlags )
   ELSEIF cType == "MSI"
      hZebra := hb_zebra_create_msi( cCode, nFlags )
   ELSEIF cType == "CODABAR"
      hZebra := hb_zebra_create_codabar( cCode, nFlags )
   ELSEIF cType == "CODE93"
      hZebra := hb_zebra_create_code93( cCode, nFlags )
   ELSEIF cType == "CODE11"
      hZebra := hb_zebra_create_code11( cCode, nFlags )
   ELSEIF cType == "CODE128"
      hZebra := hb_zebra_create_code128( cCode, nFlags )
   ELSEIF cType == "PDF417"
      hZebra := hb_zebra_create_pdf417( cCode, nFlags )
      nLineHeight := nLineWidth * 3
   ENDIF
   IF hZebra != NIL
      IF hb_zebra_geterror( hZebra ) == 0
         IF EMPTY( nLineHeight )
            nLineHeight := 16
         ENDIF
         cairo_move_to( hCairo, 40, nY + 13 )
         cairo_show_text( hCairo, cType )
         cairo_move_to( hCairo, 100, nY + 13 )
         cairo_show_text( hCairo, hb_zebra_getcode( hZebra ) )
         hb_zebra_draw_cairo( hZebra, hCairo, 220, nY, nLineWidth, nLineHeight )
      ELSE
         ? "Type", cType, "Code", cCode, "Error", hb_zebra_geterror( hZebra )
      ENDIF
      hb_zebra_destroy( hZebra )
   ELSE
      ? "Invalid barcode type", cType
   ENDIF
   RETURN

STATIC FUNCTION hb_zebra_draw_cairo( hZebra, hCairo, ... )

   IF hb_zebra_GetError( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF

   cairo_save( hCairo )
   hb_zebra_draw( hZebra, {| x, y, w, h | cairo_rectangle( hCairo, x, y, w, h ), cairo_fill( hCairo ) }, ... )
   cairo_restore( hCairo )

   RETURN 0
