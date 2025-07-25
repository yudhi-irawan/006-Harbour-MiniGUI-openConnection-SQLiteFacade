*20140131
#include <hmg.ch>
#include "hbclass.ch"

CLASS TLookUp

    DATA 	myLookUpFormName 
	
	DATA	TableName
	DATA	FieldNames
	DATA	FieldSearchCode
	DATA	FieldSearchDescription

	DATA	oConnection //Class ini tidak meng-close oConnection ! (????)
	
	DATA	GridData_headers				
	DATA	GridData_widths				
	DATA	GridData_justify			
	DATA	GridData_columncontrols	
	
	DATA    OutPut
	
    METHOD 	Version		INLINE '20140504'  //'20140131' 


	METHOD 	New( cfrmLookUpName )
	METHOD	FormShow(cKey)		
	METHOD	Show1st(cKey)		
	METHOD	Search
	METHOD	GridData_on_dblclick
				
	METHOD Exec
	METHOD Release
	 
ENDCLASS

METHOD New( cfrmLookUpName )
::myLookUpFormName:=cfrmLookUpName
::OutPut:={}
RETURN SELF

METHOD Exec
*DEFINE WINDOW &(::myLookUpFormName) AT 0 , 0 WIDTH nWidth-800 HEIGHT nHeight-100 MODAL NOSIZE;	
DEFINE WINDOW &(::myLookUpFormName) AT 0 , 0 WIDTH 466 HEIGHT 568 MODAL NOSIZE;	
on init ( ::FormShow() );							
on release ( nil );														
font 'ms sans serif' size 10							
		 
    @ 20, 10 LABEL  LABEL_1 VALUE 'SEARCH DATA '+::TableName WIDTH 400 BOLD
 
    *@ 40, 10 FRAME Frame_1 WIDTH nWidth - 830 HEIGHT 150 //230
	@ 40, 10 FRAME Frame_1 WIDTH 436 HEIGHT 150 //230
	   
    @ 60, 20 LABEL  LABEL_2 VALUE ' Code ' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
	@ 85, 20 LABEL  LABEL_3 VALUE ' Description ' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
	
	@ 60, 195 TEXTBOX meCode width 200 MaxLength 15
	@ 85, 195 TEXTBOX meDescription width 200 MaxLength 30

	DEFINE BUTTON btnSearch					
		ROW		150	
		COL		20		
		WIDTH		80	
		CAPTION		'Search'		
		ACTION		::Search()		
	END BUTTON		
/*
	DEFINE BUTTON btnShowAll					
		ROW		150	
		COL		110		
		WIDTH		100		
		CAPTION		'Show All'		
		ACTION		::Show1st() //ShowAll()		
	END BUTTON		
*/
    @ 220, 10 LABEL  LABEL_4 VALUE 'List Of '+::TableName WIDTH 200 BOLD					
	DEFINE GRID GridData						
			row 240				
			col 10				
			width 436  //nWidth - 830				
			height 218 //nHeight - 450				
			headers ::GridData_headers				
			widths ::GridData_widths			
			justify ::GridData_justify			
			columncontrols	::GridData_columncontrols	
			MULTISELECT .T.				
            CHECKBOXES .F.							
			on dblclick (::GridData_on_dblclick(), DoMethod( ::myLookUpFormName, "Release" ))
			on change nil //GridData_on_change()		
			
	END GRID
/*	
	DEFINE CHECKBOX CheckSelectedAll						
			Row		480		
			Col		20		
			Value		.F.		
			Caption		''		
			Width		25		
			OnChange nil //CheckSelectedAll_on_change()		
	END CHECKBOX						
*/							
	DEFINE BUTTON btnOk						
			ROW		480		
			COL		65		
			WIDTH		120		
			CAPTION		'OK'		
			ACTION		(::GridData_on_dblclick(), DoMethod( ::myLookUpFormName, "Release" ))	
	END BUTTON	
							
END WINDOW

&(::myLookUpFormName).Center
&(::myLookUpFormName).Activate


//SetProperty( 'frmPositionChild', 'meOrganizationDescription', 'Value', 'zzzzzzzzAAzzzzzzz')

RETURN SELF
*
METHOD Release
//
RETURN SELF
*
METHOD FormShow(cKey)
 ::Show1st(cKey)
RETURN SELF

METHOD Show1st(cKey)
local nI, nPos:=1, nLen
local aDataCell, xDataCell
local Str
local oQuery:=''

Str:="SELECT "
nLen:=len(::FieldNames)
for nI:=1 to nLen
 Str+=::FieldNames[nI]+iif(nI=nLen," ",", ")
next
Str+=' FROM '+::TableName+' ORDER BY '+::FieldNames[1]

//msginfo(Str)

 &(::myLookUpFormName).GridData.Deleteallitems

/****
 ::oConnection:Setsql(Str)  
 if !::oConnection:Open()
		msgstop("Can't connect to database")
 else
		for nI= 1 to len( ::oConnection:aRecordset )
			&(::myLookUpFormName).GridData.additem( ::oConnection:aRecordset[nI] )

            aDataCell:=&(::myLookUpFormName).GridData.Item (nI)
            xDataCell:=aDataCell[1]
            if cKey<>nil
             if cKey=xDataCell
              nPos:=nI
             endif
            endif

		next
		&(::myLookUpFormName).GridData.value := nPos //1 //n
 end
 ****/
 oQuery := ::oConnection:prepare( Str+";" )
rs := oQuery:executeQuery()

	nI:=0
	WHILE rs:Next()
		nI+=1
		
		//aData:={}
		//for nI:=1 to len(::FieldNames)
		//	if 
		//	aadd(aData,
		//next
		
		&(::myLookUpFormName).GridData.AddItem ({;
			rs:getInteger(1);
			,rs:GetString(2);
			,rs:GetString(3);
			,rs:GetString(4);
			,rs:getFloat(5);
		})

            aDataCell:=&(::myLookUpFormName).GridData.Item (nI)
            xDataCell:=aDataCell[1]
            if cKey<>nil
             if cKey=xDataCell
              nPos:=nI
             endif
            endif
			
	ENDDO


	//for nI= 1 to len( ::oConnection:aRecordset )


	//next
	
	
	oQuery:close()
	rs:close()



 
 ////::oConnection:Close()

 &(::myLookUpFormName).GridData.setfocus

RETURN SELF
*
*
*
METHOD Search()
local Str
private cID, meCode, meDescription, cWhereCode, cWhereDescription

meCode:=&(::myLookUpFormName).meCode.value
meDescription:=&(::myLookUpFormName).meDescription.value

cWhereCode:='1=1'
if !empty(alltrim(meCode))
 cWhereCode:="UPPER("+::FieldSearchCode+") LIKE UPPER("+QuotedStrPercent(meCode)+")"
endif

cWhereDescription:='2=2'
if !empty(alltrim(meDescription))
 cWhereDescription:="UPPER("+::FieldSearchDescription+") LIKE UPPER("+QuotedStrPercent(meDescription)+")"
endif

&(::myLookUpFormName).GridData.Deleteallitems

Str:="SELECT "
nLen:=len(::FieldNames)
for nI:=1 to nLen
 Str+=::FieldNames[nI]+iif(nI=nLen," ",", ")
next
Str+=' FROM '+::TableName + ' WHERE '
Str+=          cWhereCode + ' AND '
Str+=          cWhereDescription +' ORDER BY '+::FieldNames[1]

/*****
//msginfo(STR)

  ::oConnection:Setsql( Str )
  
 if !::oConnection:Open()
		msgstop("Can't connect to database")
 else
		for nI= 1 to len( ::oConnection:aRecordset )
			&(::myLookUpFormName).GridData.additem( ::oConnection:aRecordset[nI] )

		next
		&(::myLookUpFormName).GridData.value := 1
 end
 ::oConnection:Close()
****/



oQuery := ::oConnection:prepare( Str+";" )
rs := oQuery:executeQuery()

	WHILE rs:Next()	
		&(::myLookUpFormName).GridData.AddItem ({;
			rs:getInteger(1);
			,rs:GetString(2);
			,rs:GetString(3);
			,rs:GetString(4);
			,rs:getFloat(5);
		})	
	ENDDO
	oQuery:close()
	rs:close()

	

 &(::myLookUpFormName).GridData.setfocus
 
RETURN SELF
*
*
*
METHOD	GridData_on_dblclick
local aItems:=Array(len(::FieldNames))
local aPosition, aDataCell
local nI

  aPosition:=&(::myLookUpFormName).GridData.value
  if len(aPosition)=0  
  else
	aDataCell:=&(::myLookUpFormName).GridData.Item (aPosition[1])
	
	  for nI:=1 to len(::FieldNames)
	    aItems[nI]:=aDataCell[nI]  
	  next
  endif	  

::OutPut:=aItems

RETURN SELF

*====================================================
static function DoubleQuotedStr(cParam)
return '"'+alltrim(cParam)+'"'

static function QuotedStr(cParam)
return "'"+alltrim(cParam)+"'"

static function QuotedStrPercent(cParam)
return "'%"+alltrim(cParam)+"%'"