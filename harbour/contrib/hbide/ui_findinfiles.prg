/*
 * $Id$
 */

/* -------------------------------------------------------------------- */
/* WARNING: Automatically generated source file. DO NOT EDIT!           */
/*          Instead, edit corresponding .ui file,                       */
/*          with Qt Generator, and run hbqtui.exe.                      */
/* -------------------------------------------------------------------- */
/*                                                                      */
/*               Pritpal Bedi <bedipritpal@hotmail.com>                 */
/*                                                                      */
/* -------------------------------------------------------------------- */

FUNCTION uiFindinfiles( qParent )
   LOCAL oUI
   LOCAL oWidget
   LOCAL qObj := {=>}

   hb_hCaseMatch( qObj, .f. )

   oWidget := QDialog():new( qParent )
  
   oWidget:setObjectName( "FindReplInFiles" )
  
   qObj[ "FindReplInFiles"    ] := oWidget
  
   qObj[ "sizePolicy"         ] := QSizePolicy():new(0, 5)
   qObj[ "__qsizePolicy101"   ] := QSizePolicy():configure(qObj[ "FindReplInFiles" ]:sizePolicy())
   qObj[ "gridLayout"         ] := QGridLayout():new(qObj[ "FindReplInFiles" ])
   qObj[ "labelProjects"      ] := QLabel():new(qObj[ "FindReplInFiles" ])
   qObj[ "listProjects"       ] := QListWidget():new(qObj[ "FindReplInFiles" ])
   qObj[ "line_3"             ] := QFrame():new(qObj[ "FindReplInFiles" ])
   qObj[ "labelExpr"          ] := QLabel():new(qObj[ "FindReplInFiles" ])
   qObj[ "comboExpr"          ] := QComboBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkRegEx"         ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkListOnly"      ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "labelRepl"          ] := QLabel():new(qObj[ "FindReplInFiles" ])
   qObj[ "comboRepl"          ] := QComboBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "line_4"             ] := QFrame():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkMatchCase"     ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "horizontalLayout"   ] := QHBoxLayout():new()
   qObj[ "label"              ] := QLabel():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkAll"           ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkPrg"           ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkC"             ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkCpp"           ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkCh"            ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkH"             ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkRc"            ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "line_5"             ] := QFrame():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkOpenTabs"      ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkSubProjects"   ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkSubFolders"    ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "horizontalLayout_2" ] := QHBoxLayout():new()
   qObj[ "buttonFind"         ] := QPushButton():new(qObj[ "FindReplInFiles" ])
   qObj[ "buttonRepl"         ] := QPushButton():new(qObj[ "FindReplInFiles" ])
   qObj[ "buttonStop"         ] := QPushButton():new(qObj[ "FindReplInFiles" ])
   qObj[ "buttonClose"        ] := QPushButton():new(qObj[ "FindReplInFiles" ])
   qObj[ "editResults"        ] := QTextEdit():new(qObj[ "FindReplInFiles" ])
   qObj[ "horizontalLayout_3" ] := QHBoxLayout():new()
   qObj[ "labelFolder"        ] := QLabel():new(qObj[ "FindReplInFiles" ])
   qObj[ "comboFolder"        ] := QComboBox():new(qObj[ "FindReplInFiles" ])
   qObj[ "buttonFolder"       ] := QToolButton():new(qObj[ "FindReplInFiles" ])
   qObj[ "labelStatus"        ] := QLabel():new(qObj[ "FindReplInFiles" ])
   qObj[ "checkFolders"       ] := QCheckBox():new(qObj[ "FindReplInFiles" ])
   
   qObj[ "FindReplInFiles"    ]:resize(422, 472)
   qObj[ "sizePolicy"         ]:setHorizontalStretch(0)
   qObj[ "sizePolicy"         ]:setVerticalStretch(0)
   qObj[ "sizePolicy"         ]:setHeightForWidth(qObj[ "__qsizePolicy101" ]:hasHeightForWidth())
   qObj[ "FindReplInFiles"    ]:setSizePolicy(qObj[ "sizePolicy" ])
   qObj[ "FindReplInFiles"    ]:setMaximumSize(QSize():new(16777215, 16777215))
   qObj[ "labelProjects"      ]:setMaximumSize(QSize():new(52, 16777215))
   qObj[ "labelProjects"      ]:setAlignment(hb_bitOR(hb_bitOR(1,1),32))
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "labelProjects" ], 2, 0, 1, 1)
   qObj[ "listProjects"       ]:setMinimumSize(QSize():new(0, 60))
   qObj[ "listProjects"       ]:setMaximumSize(QSize():new(16777215, 60))
   qObj[ "listProjects"       ]:setEditTriggers(0)
   qObj[ "listProjects"       ]:setSelectionMode(2)
   qObj[ "listProjects"       ]:setSortingEnabled(.F.)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "listProjects" ], 2, 1, 2, 4)
   qObj[ "line_3"             ]:setFrameShape(4)
   qObj[ "line_3"             ]:setFrameShadow(48)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "line_3" ], 12, 0, 1, 5)
   qObj[ "labelExpr"          ]:setMaximumSize(QSize():new(52, 16777215))
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "labelExpr" ], 13, 0, 1, 1)
   qObj[ "comboExpr"          ]:setEditable(.T.)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "comboExpr" ], 13, 1, 1, 4)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "checkRegEx" ], 14, 1, 1, 2)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "checkListOnly" ], 14, 4, 1, 1)
   qObj[ "labelRepl"          ]:setMaximumSize(QSize():new(52, 16777215))
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "labelRepl" ], 15, 0, 1, 1)
   qObj[ "comboRepl"          ]:setEditable(.T.)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "comboRepl" ], 15, 1, 1, 4)
   qObj[ "line_4"             ]:setFrameShape(4)
   qObj[ "line_4"             ]:setFrameShadow(48)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "line_4" ], 16, 0, 1, 5)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "checkMatchCase" ], 14, 3, 1, 1)
   qObj[ "label"              ]:setMinimumSize(QSize():new(52, 0))
   qObj[ "label"              ]:setMaximumSize(QSize():new(52, 16777215))
   qObj[ "horizontalLayout"   ]:addWidget(qObj[ "label" ])
   qObj[ "horizontalLayout"   ]:addWidget(qObj[ "checkAll" ])
   qObj[ "horizontalLayout"   ]:addWidget(qObj[ "checkPrg" ])
   qObj[ "horizontalLayout"   ]:addWidget(qObj[ "checkC" ])
   qObj[ "horizontalLayout"   ]:addWidget(qObj[ "checkCpp" ])
   qObj[ "horizontalLayout"   ]:addWidget(qObj[ "checkCh" ])
   qObj[ "horizontalLayout"   ]:addWidget(qObj[ "checkH" ])
   qObj[ "checkRc"            ]:setMaximumSize(QSize():new(33, 16777215))
   qObj[ "horizontalLayout"   ]:addWidget(qObj[ "checkRc" ])
   qObj[ "gridLayout"         ]:addLayout_1(qObj[ "horizontalLayout" ], 0, 0, 1, 5)
   qObj[ "line_5"             ]:setFrameShape(4)
   qObj[ "line_5"             ]:setFrameShadow(48)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "line_5" ], 1, 0, 1, 5)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "checkOpenTabs" ], 10, 4, 1, 1)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "checkSubProjects" ], 6, 4, 1, 1)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "checkSubFolders" ], 10, 1, 1, 1)
   qObj[ "horizontalLayout_2" ]:addWidget(qObj[ "buttonFind" ])
   qObj[ "horizontalLayout_2" ]:addWidget(qObj[ "buttonRepl" ])
   qObj[ "horizontalLayout_2" ]:addWidget(qObj[ "buttonStop" ])
   qObj[ "horizontalLayout_2" ]:addWidget(qObj[ "buttonClose" ])
   qObj[ "gridLayout"         ]:addLayout_1(qObj[ "horizontalLayout_2" ], 17, 1, 1, 4)
   qObj[ "editResults"        ]:setLineWrapMode(0)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "editResults" ], 19, 0, 1, 5)
   qObj[ "labelFolder"        ]:setMaximumSize(QSize():new(52, 16777215))
   qObj[ "horizontalLayout_3" ]:addWidget(qObj[ "labelFolder" ])
   qObj[ "comboFolder"        ]:setEditable(.T.)
   qObj[ "horizontalLayout_3" ]:addWidget(qObj[ "comboFolder" ])
   qObj[ "horizontalLayout_3" ]:addWidget(qObj[ "buttonFolder" ])
   qObj[ "gridLayout"         ]:addLayout_1(qObj[ "horizontalLayout_3" ], 8, 0, 1, 5)
   qObj[ "labelStatus"        ]:setFrameShape(2)
   qObj[ "labelStatus"        ]:setFrameShadow(48)
   qObj[ "labelStatus"        ]:setWordWrap(.F.)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "labelStatus" ], 20, 0, 1, 5)
   qObj[ "gridLayout"         ]:addWidget_1(qObj[ "checkFolders" ], 6, 1, 1, 1)
   qObj[ "FindReplInFiles"    ]:setWindowTitle(q__tr("FindReplInFiles", "Find & Replace in Files", 0, "UTF8"))
   qObj[ "labelProjects"      ]:setText( [Projects:] )
   qObj[ "labelExpr"          ]:setText( [Expression] )
   qObj[ "checkRegEx"         ]:setText( [RegEx] )
   qObj[ "checkListOnly"      ]:setText( [List only] )
   qObj[ "labelRepl"          ]:setText( [Replace:] )
   qObj[ "checkMatchCase"     ]:setText( [Match case] )
   qObj[ "label"              ]:setText( [File types:] )
   qObj[ "checkAll"           ]:setText( [all] )
   qObj[ "checkPrg"           ]:setText( [.prg] )
   qObj[ "checkC"             ]:setText( [.c] )
   qObj[ "checkCpp"           ]:setText( [.c++] )
   qObj[ "checkCh"            ]:setText( [.ch] )
   qObj[ "checkH"             ]:setText( [.h] )
   qObj[ "checkRc"            ]:setText( [.rc] )
   qObj[ "checkOpenTabs"      ]:setText( [Include open tabs ] )
   qObj[ "checkSubProjects"   ]:setText( [Include sub-projects] )
   qObj[ "checkSubFolders"    ]:setText( [Include sub-folders] )
   qObj[ "buttonFind"         ]:setText( [Find] )
   qObj[ "buttonRepl"         ]:setText( [Replace] )
   qObj[ "buttonStop"         ]:setText( [Stop] )
   qObj[ "buttonClose"        ]:setText( [Close] )
   qObj[ "labelFolder"        ]:setText( [Folder:] )
   qObj[ "buttonFolder"       ]:setText( [...] )
   qObj[ "labelStatus"        ]:setText( [] )
   qObj[ "checkFolders"       ]:setText( [Include folders] )

   oUI         := HbQtUI():new()
   oUI:qObj    := qObj
   oUI:oWidget := oWidget

   RETURN oUI

/*----------------------------------------------------------------------*/

