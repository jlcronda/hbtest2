/*
 * $Id$
 */

/*
 * ODBC Database Driver
 *
 * Copyright 2009 Mindaugas Kavaliauskas <dbtopas at dbtopas.lt>
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

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbdate.h"
#include "hbapistr.h"
#include "hbset.h"
#include "hbvm.h"

#if defined( __XCC__ ) || defined( __LCC__ )
#  include "hbrddsql.h"
#else
#  include "../hbrddsql.h"
#endif

/* Required by headers on Windows */
#if defined( HB_OS_WIN )
#  include <windows.h>
#endif

#include <sql.h>
#include <sqlext.h>

#if !defined( HB_OS_WIN )
#  if !defined( SQLLEN ) && !defined( SQLTCHAR )
      typedef unsigned char   SQLTCHAR;
#  endif
#  if !defined( SQLLEN )
#     define SQLLEN           SQLINTEGER
#  endif
#  if !defined( SQLULEN )
#     define SQLULEN          SQLUINTEGER
#  endif
#endif

#if defined( UNICODE )
   #define O_HB_ARRAYGETSTR( arr, n, phstr, plen ) hb_arrayGetStrU16( arr, n, HB_CDP_ENDIAN_NATIVE, phstr, plen )
   #define O_HB_ITEMCOPYSTR( itm, str, len )       hb_itemCopyStrU16( itm, HB_CDP_ENDIAN_NATIVE, str, len )
   #define O_HB_ITEMGETSTR( itm, phstr, plen )     hb_itemGetStrU16( itm, HB_CDP_ENDIAN_NATIVE, phstr, plen )
   #define O_HB_ITEMPUTSTR( itm, str )             hb_itemPutStrU16( itm, HB_CDP_ENDIAN_NATIVE, str )
   #define O_HB_ITEMPUTSTRLEN( itm, str, len )     hb_itemPutStrLenU16( itm, HB_CDP_ENDIAN_NATIVE, str, len )
#else
   #define O_HB_ARRAYGETSTR( arr, n, phstr, plen ) hb_arrayGetStr( arr, n, hb_setGetOSCP(), phstr, plen )
   #define O_HB_ITEMCOPYSTR( itm, str, len )       hb_itemCopyStr( itm, hb_setGetOSCP(), str, len )
   #define O_HB_ITEMGETSTR( itm, phstr, plen )     hb_itemGetStr( itm, hb_setGetOSCP(), phstr, plen )
   #define O_HB_ITEMPUTSTR( itm, str )             hb_itemPutStr( itm, hb_setGetOSCP(), str )
   #define O_HB_ITEMPUTSTRLEN( itm, str, len )     hb_itemPutStrLen( itm, hb_setGetOSCP(), str, len )
#endif

static HB_ERRCODE odbcConnect( SQLDDCONNECTION * pConnection, PHB_ITEM pItem );
static HB_ERRCODE odbcDisconnect( SQLDDCONNECTION * pConnection );
static HB_ERRCODE odbcExecute( SQLDDCONNECTION * pConnection, PHB_ITEM pItem );
static HB_ERRCODE odbcOpen( SQLBASEAREAP pArea );
static HB_ERRCODE odbcClose( SQLBASEAREAP pArea );
static HB_ERRCODE odbcGoTo( SQLBASEAREAP pArea, HB_ULONG ulRecNo );


static SDDNODE odbcdd =
{
   NULL,
   "ODBC",
   ( SDDFUNC_CONNECT )    odbcConnect,
   ( SDDFUNC_DISCONNECT ) odbcDisconnect,
   ( SDDFUNC_EXECUTE )    odbcExecute,
   ( SDDFUNC_OPEN )       odbcOpen,
   ( SDDFUNC_CLOSE )      odbcClose,
   ( SDDFUNC_GOTO )       odbcGoTo,
   ( SDDFUNC_GETVALUE )   NULL,
   ( SDDFUNC_GETVARLEN )  NULL
};


HB_FUNC_EXTERN( SQLBASE );

static void hb_odbcdd_init( void * cargo )
{
   HB_SYMBOL_UNUSED( cargo );

   if ( ! hb_sddRegister( & odbcdd ) )
   {
      hb_errInternal( HB_EI_RDDINVALID, NULL, NULL, NULL );
      HB_FUNC_EXEC( SQLBASE );   /* force SQLBASE linking */
   }
}

HB_FUNC( SDDODBC ) {;}

HB_INIT_SYMBOLS_BEGIN( odbcdd__InitSymbols )
{ "SDDODBC", {HB_FS_PUBLIC}, {HB_FUNCNAME( SDDODBC )}, NULL },
HB_INIT_SYMBOLS_END( odbcdd__InitSymbols )

HB_CALL_ON_STARTUP_BEGIN( _hb_odbcdd_init_ )
   hb_vmAtInit( hb_odbcdd_init, NULL );
HB_CALL_ON_STARTUP_END( _hb_odbcdd_init_ )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup odbcdd__InitSymbols
   #pragma startup _hb_odbcdd_init_
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( odbcdd__InitSymbols ) \
                              HB_DATASEG_FUNC( _hb_odbcdd_init_ )
   #include "hbiniseg.h"
#endif


/*=====================================================================================*/
static HB_USHORT hb_errRT_ODBCDD( HB_ERRCODE errGenCode, HB_ERRCODE errSubCode, const char * szDescription, const char * szOperation, HB_ERRCODE errOsCode )
{
   HB_USHORT uiAction;
   PHB_ITEM pError;

   pError = hb_errRT_New( ES_ERROR, "SDDODBC", errGenCode, errSubCode, szDescription, szOperation, errOsCode, EF_NONE );
   uiAction = hb_errLaunch( pError );
   hb_itemRelease( pError );
   return uiAction;
}


static char * odbcGetError( SQLHENV hEnv, SQLHDBC hConn, SQLHSTMT hStmt, HB_ERRCODE * pErrCode )
{
   SQLTCHAR     szError[ 6 + SQL_MAX_MESSAGE_LENGTH ];
   SQLINTEGER   iNativeErr = 9999;
   SQLSMALLINT  iLen;
   char *       szRet;

   if( SQL_SUCCEEDED( SQLError( hEnv, hConn, hStmt, szError, &iNativeErr, szError + 6, SQL_MAX_MESSAGE_LENGTH, &iLen ) ) )
   {
      PHB_ITEM pRet;

      szError[ 5 ] = ' ';

      pRet = O_HB_ITEMPUTSTR( NULL, szError );
      szRet = hb_strdup( hb_itemGetCPtr( pRet ) );
      hb_itemRelease( pRet );
   }
   else
      szRet = hb_strdup( "HY000 Unable to get error message" );

   if( pErrCode )
      * pErrCode = ( HB_ERRCODE ) iNativeErr;
   return szRet;
}


/*============= SDD METHODS =============================================================*/

static HB_ERRCODE odbcConnect( SQLDDCONNECTION * pConnection, PHB_ITEM pItem )
{
   SQLHENV    hEnv = NULL;
   SQLHDBC    hConnect = NULL;
   char *     szError;
   HB_ERRCODE errCode;

   if( SQL_SUCCEEDED( SQLAllocHandle( SQL_HANDLE_ENV, SQL_NULL_HANDLE, &hEnv ) ) )
   {
      SQLSetEnvAttr( hEnv, SQL_ATTR_ODBC_VERSION, ( SQLPOINTER ) SQL_OV_ODBC3, SQL_IS_UINTEGER );

      if( SQL_SUCCEEDED( SQLAllocHandle( SQL_HANDLE_DBC, hEnv, &hConnect ) ) )
      {
         void *       hConnStr;
         SQLTCHAR     cBuffer[ 1024 ];
         SQLSMALLINT  iLen = HB_SIZEOFARRAY( cBuffer );

         cBuffer[ 0 ] ='\0';

         if( SQL_SUCCEEDED( SQLDriverConnect( hConnect,
                                              NULL,
                                              ( SQLTCHAR * ) O_HB_ARRAYGETSTR( pItem, 2, &hConnStr, NULL ),
                                              ( SQLSMALLINT ) hb_arrayGetCLen( pItem, 2 ),
                                              cBuffer,
                                              HB_SIZEOFARRAY( cBuffer ),
                                              &iLen,
                                              SQL_DRIVER_NOPROMPT ) ) )
         {
            hb_strfree( hConnStr );
            pConnection->hCargo = ( void * ) hEnv;
            pConnection->hConnection = ( void * ) hConnect;
            return HB_SUCCESS;
         }
         else
         {
            hb_strfree( hConnStr );
            szError = odbcGetError( hEnv, hConnect, SQL_NULL_HSTMT, &errCode );
            hb_rddsqlSetError( errCode, szError, NULL, NULL, 0 );
            hb_xfree( szError );
         }
         SQLFreeHandle( SQL_HANDLE_DBC, hConnect );
      }
      else
      {
         szError = odbcGetError( hEnv, SQL_NULL_HDBC, SQL_NULL_HSTMT, &errCode );
         hb_errRT_ODBCDD( EG_OPEN, ESQLDD_CONNALLOC, szError, hb_arrayGetCPtr( pItem, 2 ), errCode );
         hb_xfree( szError );
      }
      SQLFreeHandle( SQL_HANDLE_ENV, hEnv );
   }
   else
   {
      szError = odbcGetError( SQL_NULL_HENV, SQL_NULL_HDBC, SQL_NULL_HSTMT, &errCode );
      hb_errRT_ODBCDD( EG_OPEN, ESQLDD_ENVALLOC, szError, hb_arrayGetCPtr( pItem, 2 ), errCode );
      hb_xfree( szError );
   }
   return HB_FAILURE;
}


static HB_ERRCODE odbcDisconnect( SQLDDCONNECTION * pConnection )
{
   SQLDisconnect( ( SQLHDBC ) pConnection->hConnection );
   SQLFreeHandle( SQL_HANDLE_DBC, ( SQLHDBC ) pConnection->hConnection );
   SQLFreeHandle( SQL_HANDLE_ENV, ( SQLHENV ) pConnection->hCargo );
   return HB_SUCCESS;
}


static HB_ERRCODE odbcExecute( SQLDDCONNECTION * pConnection, PHB_ITEM pItem )
{
   void *       hStatement;
   SQLHSTMT     hStmt;
   SQLLEN       iCount;
   char *       szError;
   HB_ERRCODE   errCode;

   if ( ! SQL_SUCCEEDED( SQLAllocStmt( ( SQLHDBC ) pConnection->hConnection, &hStmt ) ) )
   {
      szError = odbcGetError( ( SQLHENV ) pConnection->hCargo, ( SQLHDBC ) pConnection->hConnection, SQL_NULL_HSTMT, &errCode );
      hb_errRT_ODBCDD( EG_OPEN, ESQLDD_STMTALLOC, szError, hb_itemGetCPtr( pItem ), errCode );
      hb_xfree( szError );
      return HB_FAILURE;
   }

   if ( SQL_SUCCEEDED( SQLExecDirect( hStmt, ( SQLTCHAR * ) O_HB_ITEMGETSTR( pItem, &hStatement, NULL ), hb_itemGetCLen( pItem ) ) ) )
   {
      hb_strfree( hStatement );

      if ( SQL_SUCCEEDED( SQLRowCount( hStmt, &iCount ) ) )
      {
         /* TODO: new id */
         hb_rddsqlSetError( 0, NULL, hb_itemGetCPtr( pItem ), NULL, ( unsigned long ) iCount );
         SQLFreeStmt( hStmt, SQL_DROP );
         return HB_SUCCESS;
      }
   }
   else
      hb_strfree( hStatement );

   szError = odbcGetError( ( SQLHENV ) pConnection->hCargo, ( SQLHDBC ) pConnection->hConnection, hStmt, &errCode );
   hb_rddsqlSetError( errCode, szError, hb_itemGetCPtr( pItem ), NULL, errCode );
   hb_xfree( szError );
   SQLFreeStmt( hStmt, SQL_DROP );
   return HB_FAILURE;
}


static HB_ERRCODE odbcOpen( SQLBASEAREAP pArea )
{
   void *       hQuery;
   SQLHSTMT     hStmt;
   SQLSMALLINT  iNameLen, iDataType, iDec, iNull;
   SQLTCHAR     cName[ 256 ];
   SQLULEN      uiSize;
   PHB_ITEM     pItemEof, pItem;
   DBFIELDINFO  pFieldInfo;
   HB_BOOL      bError;
   HB_USHORT    uiFields, uiIndex;
   HB_ERRCODE   errCode;
   char *       szError;

   if ( ! SQL_SUCCEEDED( SQLAllocHandle( SQL_HANDLE_STMT, ( SQLHDBC ) pArea->pConnection->hConnection, &hStmt ) ) )
   {
      szError = odbcGetError( ( SQLHENV ) pArea->pConnection->hCargo, ( SQLHDBC ) pArea->pConnection->hConnection, SQL_NULL_HSTMT, &errCode );
      hb_errRT_ODBCDD( EG_OPEN, ESQLDD_STMTALLOC, szError, pArea->szQuery, errCode );
      hb_xfree( szError );
      return HB_FAILURE;
   }

   pItem = hb_itemPutC( NULL, pArea->szQuery );

   if ( ! SQL_SUCCEEDED( SQLExecDirect( hStmt, ( SQLTCHAR * ) O_HB_ITEMGETSTR( pItem, &hQuery, NULL ), hb_itemGetCLen( pItem ) ) ) )
   {
      hb_strfree( hQuery );
      hb_itemRelease( pItem );
      szError = odbcGetError( ( SQLHENV ) pArea->pConnection->hCargo, ( SQLHDBC ) pArea->pConnection->hConnection, hStmt, &errCode );
      SQLFreeStmt( hStmt, SQL_DROP );
      hb_errRT_ODBCDD( EG_OPEN, ESQLDD_INVALIDQUERY, szError, pArea->szQuery, errCode );
      hb_xfree( szError );
      return HB_FAILURE;
   }
   else
   {
      hb_strfree( hQuery );
      hb_itemRelease( pItem );
   }

   if ( ! SQL_SUCCEEDED( SQLNumResultCols( hStmt, &iNameLen ) ) )
   {
      szError = odbcGetError( ( SQLHENV ) pArea->pConnection->hCargo, ( SQLHDBC ) pArea->pConnection->hConnection, hStmt, &errCode );
      SQLFreeStmt( hStmt, SQL_DROP );
      hb_errRT_ODBCDD( EG_OPEN, ESQLDD_STMTDESCR + 1000, szError, pArea->szQuery, errCode );
      hb_xfree( szError );
      return HB_FAILURE;
   }

   uiFields = ( HB_USHORT ) iNameLen;
   SELF_SETFIELDEXTENT( ( AREAP ) pArea, uiFields );

   pItemEof = hb_itemArrayNew( uiFields );

   /* HB_TRACE( HB_TR_ALWAYS, ("fieldcount=%d", iNameLen) ); */

   errCode = 0;
   bError = HB_FALSE;
   for ( uiIndex = 0; uiIndex < uiFields; uiIndex++ )
   {
      if ( ! SQL_SUCCEEDED( SQLDescribeCol( hStmt, ( SQLSMALLINT ) uiIndex + 1, ( SQLTCHAR * ) cName, HB_SIZEOFARRAY( cName ), &iNameLen, &iDataType, &uiSize, &iDec, &iNull ) ) )
      {
         hb_itemRelease( pItemEof );
         szError = odbcGetError( ( SQLHENV ) pArea->pConnection->hCargo, ( SQLHDBC ) pArea->pConnection->hConnection, hStmt, NULL );
         SQLFreeStmt( hStmt, SQL_DROP );
         hb_errRT_ODBCDD( EG_OPEN, ESQLDD_STMTDESCR + 1001, szError, pArea->szQuery, 0 );
         hb_xfree( szError );
         return HB_FAILURE;
      }

      cName[ MAX_FIELD_NAME ] = '\0';
      hb_strUpper( ( char * ) cName, MAX_FIELD_NAME + 1 );
      pFieldInfo.atomName = ( char * ) cName;

      pFieldInfo.uiLen = ( HB_USHORT ) uiSize;
      pFieldInfo.uiDec = iDec;

      /* HB_TRACE( HB_TR_ALWAYS, ("field: name=%s type=%d len=%d dec=%d null=%d", pFieldInfo.atomName, iDataType, uiSize, iDec, iNull ) ); */

      switch( iDataType )
      {
         case SQL_CHAR:
         case SQL_VARCHAR:
         case SQL_LONGVARCHAR:
         case SQL_WCHAR:
         case SQL_WVARCHAR:
         case SQL_WLONGVARCHAR:
           pFieldInfo.uiType = HB_FT_STRING;
           break;

         case SQL_TINYINT:
         case SQL_SMALLINT:
         case SQL_INTEGER:
           pFieldInfo.uiType = HB_FT_INTEGER;
           break;

         case SQL_DECIMAL:
           pFieldInfo.uiType = HB_FT_LONG;
           break;

         case SQL_REAL:
         case SQL_FLOAT:
         case SQL_DOUBLE:
           pFieldInfo.uiType = HB_FT_DOUBLE;
           break;

         case SQL_BIT:
           pFieldInfo.uiType = HB_FT_LOGICAL;
           break;

         case SQL_DATE:
         case SQL_TYPE_DATE:
           pFieldInfo.uiType = HB_FT_DATE;
           break;

         case SQL_TIME:
         case SQL_TYPE_TIME:
           pFieldInfo.uiType = HB_FT_DATE;
           break;

         /*  SQL_DATETIME = SQL_DATE = 9 */
         case SQL_TIMESTAMP:
         case SQL_TYPE_TIMESTAMP:
           pFieldInfo.uiType = HB_FT_TIMESTAMP;
           break;

         default:
           /* HB_TRACE( HB_TR_ALWAYS, ("new sql type=%d", iDataType) ); */
           bError = HB_TRUE;
           errCode = ( HB_ERRCODE ) iDataType;
           pFieldInfo.uiType = 0;
           pFieldInfo.uiType = HB_FT_STRING;
           break;
      }

      if ( ! bError )
      {
         switch ( pFieldInfo.uiType )
         {
            case HB_FT_STRING:
            {
               char * pStr;

               pStr = ( char * ) hb_xgrab( ( HB_SIZE ) pFieldInfo.uiLen + 1 );
               memset( pStr, ' ', pFieldInfo.uiLen );
               pStr[ pFieldInfo.uiLen ] = '\0';

               pItem = hb_itemPutCL( NULL, pStr, pFieldInfo.uiLen );
               hb_xfree( pStr );
               break;
            }

            case HB_FT_MEMO:
               pItem = hb_itemPutC( NULL, NULL );
               break;

            case HB_FT_INTEGER:
               pItem = hb_itemPutNI( NULL, 0 );
               break;

            case HB_FT_LONG:
               if( pFieldInfo.uiDec == 0 )
                  pItem = hb_itemPutNLLen( NULL, 0, pFieldInfo.uiLen );
               else
                  pItem = hb_itemPutNDLen( NULL, 0.0, pFieldInfo.uiLen, pFieldInfo.uiDec );
               break;

            case HB_FT_DOUBLE:
               pItem = hb_itemPutNDLen( NULL, 0.0, pFieldInfo.uiLen, pFieldInfo.uiDec );
               break;

            case HB_FT_LOGICAL:
               pItem = hb_itemPutL( NULL, HB_FALSE );
               break;

            case HB_FT_DATE:
               pItem = hb_itemPutDL( NULL, 0 );
               break;

            case HB_FT_TIME:
               pItem = hb_itemPutTDT( NULL, 0, 0 );
               break;

           case HB_FT_TIMESTAMP:
               pItem = hb_itemPutTDT( NULL, 0, 0 );
               break;

            default:
               pItem = hb_itemNew( NULL );
               bError = HB_TRUE;
               break;
         }

         hb_arraySetForward( pItemEof, uiIndex + 1, pItem );
         hb_itemRelease( pItem );

         if ( ! bError )
            bError = ( SELF_ADDFIELD( ( AREAP ) pArea, &pFieldInfo ) == HB_FAILURE );
      }

      if ( bError )
         break;
   }

   if ( bError )
   {
      hb_itemRelease( pItemEof );
      SQLFreeStmt( hStmt, SQL_DROP );
      hb_errRT_ODBCDD( EG_CORRUPTION, ESQLDD_INVALIDFIELD, "Invalid field type", pArea->szQuery, errCode );
      return HB_FAILURE;
   }

   pArea->ulRecCount = 0;
   pArea->ulRecMax = SQLDD_ROWSET_INIT;

   pArea->pRow = ( void ** ) hb_xgrab( SQLDD_ROWSET_INIT * sizeof( void * ) );
   memset( pArea->pRow, 0, SQLDD_ROWSET_INIT * sizeof( void * ) );
   pArea->pRowFlags = ( HB_BYTE * ) hb_xgrab( SQLDD_ROWSET_INIT * sizeof( HB_BYTE ) );
   memset( pArea->pRowFlags, 0, SQLDD_ROWSET_INIT * sizeof( HB_BYTE ) );

   pArea->pRow[ 0 ] = pItemEof;
   pArea->pRowFlags[ 0 ] = SQLDD_FLAG_CACHED;

   pArea->pStmt = ( void * ) hStmt;
   return HB_SUCCESS;
}


static HB_ERRCODE odbcClose( SQLBASEAREAP pArea )
{
   if ( pArea->pStmt )
   {
      SQLFreeStmt( ( SQLHSTMT ) pArea->pStmt, SQL_DROP );
      pArea->pStmt = NULL;
   }
   return HB_SUCCESS;
}


static HB_ERRCODE odbcGoTo( SQLBASEAREAP pArea, HB_ULONG ulRecNo )
{
   SQLHSTMT     hStmt = ( SQLHSTMT ) pArea->pStmt;
   SQLRETURN    res;
   SQLLEN       iLen;
   PHB_ITEM     pArray, pItem;
   LPFIELD      pField;
   HB_USHORT    ui;

   while ( ulRecNo > pArea->ulRecCount && ! pArea->fFetched )
   {
      if( ! SQL_SUCCEEDED( SQLFetch( hStmt ) ) )
      {
         pArea->fFetched = HB_TRUE;
         break;
      }

      pArray = hb_itemArrayNew( pArea->area.uiFieldCount );
      for ( ui = 1; ui <= pArea->area.uiFieldCount; ui++ )
      {
         iLen = SQL_NULL_DATA;
         pItem = NULL;
         res = 0;
         pField = pArea->area.lpFields + ui - 1;
         switch( pField->uiType )
         {
            case HB_FT_STRING:
            {
               /* TODO: it is not clear for me, how can I get string length */
               /* TODO: UNICODE support */

               char *  val = ( char * ) hb_xgrab( 1024 );
               if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_CHAR, ( SQLCHAR * ) val, 1024, &iLen ) ) )
               {
                  if( iLen > 0 )
                     pItem = hb_itemPutCL( NULL, val, ( HB_SIZE ) iLen );
               }
               hb_xfree( val );
               break;
            }

            case HB_FT_INTEGER:
            {
               long int  val = 0;
               if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_LONG, &val, sizeof( val ), &iLen ) ) )
               {
                  pItem = hb_itemPutNLLen( NULL, val, pField->uiLen );
               }
               break;
            }

            case HB_FT_LONG:
               if( pField->uiDec == 0 )
               {
                  long int  val = 0;
                  if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_LONG, &val, sizeof( val ), &iLen ) ) )
                  {
                     pItem = hb_itemPutNLLen( NULL, val, pField->uiLen );
                  }
               }
               else
               {
                  double  val = 0.0;
                  if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_DOUBLE, &val, sizeof( val ), &iLen ) ) )
                  {
                     pItem = hb_itemPutNDLen( NULL, val, pField->uiLen, pField->uiDec );
                  }
               }
               break;

            case HB_FT_DOUBLE:
            {
               double  val = 0.0;
               if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_DOUBLE, &val, sizeof( val ), &iLen ) ) )
               {
                  pItem = hb_itemPutNDLen( NULL, val, pField->uiLen, pField->uiDec );
               }
               break;
            }

            case HB_FT_LOGICAL:
            {
               unsigned char  val = 0;
               if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_BIT, &val, sizeof( val ), &iLen ) ) )
               {
                  pItem = hb_itemPutL( NULL, val != 0 );
               }
               break;
            }

            case HB_FT_DATE:
            {
               DATE_STRUCT  val = {0,0,0};
               if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_DATE, &val, sizeof( val ), &iLen ) ) )
               {
                  pItem = hb_itemPutD( NULL, val.year, val.month, val.day );
               }
               break;
            }

            case HB_FT_TIME:
            {
               TIME_STRUCT  val = {0,0,0};
               if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_TIME, &val, sizeof( val ), &iLen ) ) )
               {
                  pItem = hb_itemPutTDT( NULL, 0, hb_timeEncode( val.hour, val.minute, val.second, 0 ) );
               }
               break;
            }

            case HB_FT_TIMESTAMP:
            {
               TIMESTAMP_STRUCT  val = {0,0,0,0,0,0,0};
               if( SQL_SUCCEEDED( res = SQLGetData( hStmt, ui, SQL_C_TIMESTAMP, &val, sizeof( val ), &iLen ) ) )
               {
                  pItem = hb_itemPutTDT( NULL, hb_dateEncode( val.year, val.month, val.day ),
                                         hb_timeEncode( val.hour, val.minute, val.second, val.fraction / 1000000 ) );
               }
               break;
            }
         }

         /* TODO: check SQL_SUCCEEDED( res ) */
         /* TODO: check for SQL_NO_TOTAL. What does this mean? */
         HB_SYMBOL_UNUSED( res );

         /* NULL -> NIL */
         if( iLen == SQL_NULL_DATA )
         {
            hb_itemRelease( pItem );
            pItem = NULL;
         }

         if( pItem )
         {
            hb_arraySetForward( pArray, ui, pItem );
            hb_itemRelease( pItem );
         }
      }
      if ( pArea->ulRecCount + 1 <= pArea->ulRecMax )
      {
         pArea->pRow = ( void ** ) hb_xrealloc( pArea->pRow, ( pArea->ulRecMax + SQLDD_ROWSET_RESIZE ) * sizeof( void * ) );
         pArea->pRowFlags = ( HB_BYTE * ) hb_xrealloc( pArea->pRowFlags, ( pArea->ulRecMax + SQLDD_ROWSET_RESIZE ) * sizeof( HB_BYTE ) );
         pArea->ulRecMax += SQLDD_ROWSET_RESIZE;
      }

      pArea->ulRecCount++;
      pArea->pRow[ pArea->ulRecCount ] = pArray;
      pArea->pRowFlags[ pArea->ulRecCount ] = SQLDD_FLAG_CACHED;
   }

   if ( ulRecNo == 0 || ulRecNo > pArea->ulRecCount )
   {
      pArea->pRecord = pArea->pRow[ 0 ];
      pArea->bRecordFlags = pArea->pRowFlags[ 0 ];
      pArea->fPositioned = HB_FALSE;
   }
   else
   {
      pArea->pRecord = pArea->pRow[ ulRecNo ];
      pArea->bRecordFlags = pArea->pRowFlags[ ulRecNo ];
      pArea->fPositioned = HB_TRUE;
   }
   return HB_SUCCESS;
}
