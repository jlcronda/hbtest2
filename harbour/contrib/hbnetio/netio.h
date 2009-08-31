/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *    demonstration code for alternative RDD IO API which uses own
 *    very simple TCP/IP file server.
 *    All files which names starts with 'net:' are redirected to this API.
 *    This is header file used by client and server code with some constant
 *    definitions.
 *
 * Copyright 2009 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
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

/* file name prefix used by this file IO implementation */
#define NETIO_FILE_PREFIX     "net:"
#define NETIO_FILE_PREFIX_LEN strlen( NETIO_FILE_PREFIX )

/* default server address, port and timeout */
#define NETIO_DEFAULT_SERVER  "127.0.0.1"
#define NETIO_DEFAULT_PORT    2941
#define NETIO_DEFAULT_TIMEOUT -1

/* message size */
#define NETIO_MSGLEN          24

/* maximal number of open files per connection */
#define NETIO_FILES_MAX       8192

/* maximal length of server name */
#define NETIO_SERVERNAME_MAX  256

/* login string */
#define NETIO_LOGINSTRID      "HarbourFileTcpIpServer\003"

/* messages */
#define NETIO_LOGIN           1
#define NETIO_EXISTS          2
#define NETIO_DELETE          3
#define NETIO_COMMIT          4
#define NETIO_SIZE            5
#define NETIO_TRUNC           6
#define NETIO_READ            7
#define NETIO_WRITE           8
#define NETIO_LOCK            9
#define NETIO_OPEN            10
#define NETIO_CLOSE           11
#define NETIO_ERROR           12
#define NETIO_CONNECTED       0x4321DEAD

/* messages format */
/* { NETIO_LOGIN,  len[ 2 ]... } + loginstr[ len ] -> { NETIO_LOGIN, NETIO_CONNECTED[ 4 ], ... } */
/* { NETIO_EXISTS, len[ 2 ]... } + filename[ len ] -> { NETIO_EXISTS, ... } */
/* { NETIO_DELETE, len[ 2 ]... } + filename[ len ] -> { NETIO_DELETE, ... } */
/* { NETIO_OPEN,   len[ 2 ], flags[ 2 ], def_ext[], 0, ... } + filename[ len ] -> { NETIO_OPEN, file_no[2], ... } */
/* { NETIO_READ,   file_no[2], size[ 4 ], offset[ 8 ], ... } -> { NETIO_READ, read[ 4 ], err[ 2 ], ... } + data[ read ] */
/* { NETIO_WRITE,  file_no[2], size[ 4 ], offset[ 8 ], ... } + data[ size ] -> { NETIO_WRITE, written[ 4 ], err[ 2 ], ... } */
/* { NETIO_LOCK,   file_no[2], start[ 8 ], len[ 8 ], flags[ 2 ], ... } -> { NETIO_LOCK, ... } */
/* { NETIO_TRUNC,  file_no[2], offset[ 8 ], ... } -> { NETIO_TRUNC, ... } */
/* { NETIO_SIZE,   file_no[2], ... } -> { NETIO_SIZE, size[ 8 ], err[ 2 ], ... } */
/* { NETIO_COMMIT, file_no[2], ... } -> NULL */
/* { NETIO_CLOSE,  file_no[2], ... } -> { NETIO_CLOSE, ... } */

/* netio errors */
#define NETIO_ERR_UNKNOWN_COMMAND   0xff01
#define NETIO_ERR_WRONG_PARAM       0xff02
#define NETIO_ERR_WRONG_FILE_PATH   0xff03
#define NETIO_ERR_WRONG_FILE_HANDLE 0xff04
#define NETIO_ERR_FILES_MAX         0xff05
#define NETIO_ERR_READ              0xff06
