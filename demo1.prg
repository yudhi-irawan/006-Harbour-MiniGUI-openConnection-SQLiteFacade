//2020-12-01

#include 'hmg.ch'
*#include "minigui.ch"

FUNCTION Main()
	LOCAL cFontName := 'Tahoma', nFontSize := 10
	PUBLIC csample_lookup:="sample_lookup.db"
	Private oConnection:=openConnection()
	
	SET DATE FORMAT "yyyy-mm-dd"

	CreateDatabase()
	CreateTable()
	FillData_tblbrg()

	DEFINE WINDOW MainForm;
		MAIN;
		WIDTH  740;
		HEIGHT 600;
		VIRTUAL WIDTH 1200; 
		VIRTUAL HEIGHT 1000;
		TITLE  'Lookup - SQLite';
		ICON "icon_generator" ;
		FONT cFontName;  
		SIZE nFontSize;
		NOMAXIMIZE;
		NOSIZE;
		ON INIT nil;
		ON RELEASE nil


		one_display_label()
		one_display_textbox(1)


	END WINDOW

	
	MainForm.Center
	MainForm.Activate

RETURN NIL

static function one_display_label()
local aLabel, nRow := 10

//@ nRow+0,10	LABEL lblid_tblmaster VALUE 'id_tblmaster' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
@ nRow+25,10	LABEL lblnotrx VALUE 'notrx' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
@ nRow+50,10	LABEL lblketerangan VALUE 'keterangan' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
//@ nRow+75,10	LABEL lblid_tblbrg VALUE 'id_tblbrg' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150

@ nRow+100,10	LABEL lblkode VALUE 'kode' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
@ nRow+125,10	LABEL lblnama VALUE 'nama' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
@ nRow+150,10	LABEL lblsatuan VALUE 'satuan' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
@ nRow+175,10	LABEL lblharga VALUE 'harga' VCENTERALIGN BORDER BACKCOLOR YELLOW WIDTH 150
return nil
*
*
*
static function one_display_textbox(nI)
local nX, nRow := 10, nCol
local aPosition, aDataCell, xDataCell, cToolTipGrid:=''

if nI=1
	//@ nRow+0, 225 GETBOX meid_tblmaster Value 0 Width 100 Picture '99999'
	@ nRow+25, 225 GETBOX menotrx Value '' Width 300 Picture '@K! XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
	@ nRow+50, 225 GETBOX meketerangan Value '' Width 300 Picture '@K! XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
	//@ nRow+75, 225 GETBOX meid_tblbrg Value 0 Width 100 Picture '99999'
	
	@ nRow+100, 225 GETBOX mekode Value '' Width 300 Picture '@K! XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' ACTION LookUp_Barang("MainForm","mekode","frmLookUpBarang",oConnection) IMAGE ".\resources\btn02.bmp" BUTTONWIDTH 24 TOOLTIP "" VALID {|| ( len(alltrim(This.Value)) >= 2)} VALIDMESSAGE "Minimum 2 characters" MESSAGE "Character Input"

	@ nRow+125, 225 GETBOX menama Value '' Width 300 Picture '@K! XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
	@ nRow+150, 225 GETBOX mesatuan Value '' Width 300 Picture '@K! XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'	
	@ nRow+175, 225 GETBOX meharga Value 0 Width 100 Picture '99999'
	
	
else  //----------------------------------------------------------> if nI=1 
	//	
endif
return nil



*------------------------------------------
STATIC FUNCTION CreateDatabase()
	LOCAL db := SQLiteFacade():new( M->csample_lookup )
  
	db:open()
	db:close()
	IF ( !FILE( M->csample_lookup ) )
		//ForceFail()
	ENDIF
   
RETURN ( NIL )


STATIC FUNCTION CreateTable()
	LOCAL db := SQLiteFacade():new( M->csample_lookup )
	LOCAL stmt
	db:open()

	*----------------------------------------------	
	stmt := db:prepare( ;
		"CREATE TABLE IF NOT EXISTS tblmaster " +;
		"(" + ;
			"id_tblmaster INTEGER PRIMARY KEY AUTOINCREMENT" +;
			",notrx TEXT" +;
			",keterangan TEXT DEFAULT ''" +;
			",id_tblbrg INTEGER DEFAULT 0" +;
			",hargabeli REAL DEFAULT 0.0" +;
		");";
	)  				 
	IF !( stmt:executeUpdate() == 0 )
		//ForceFail( "Creating a table tblmaster isn't expected to affect rows" )
	ENDIF
	stmt:close()
	*----------------------------------------------
		
	*----------------------------------------------	
	stmt := db:prepare( ;
		"CREATE TABLE IF NOT EXISTS tblbrg " +;
		"(" + ;
			"id_tblbrg INTEGER PRIMARY KEY AUTOINCREMENT" +;
			",kode TEXT" +;
			",nama TEXT DEFAULT ''" +;
			",satuan TEXT DEFAULT ''" +;
			",harga REAL DEFAULT 0.0" +;
		");";
	)  				 
	IF !( stmt:executeUpdate() == 0 )
		//ForceFail( "Creating a table tblbrg isn't expected to affect rows" )
	ENDIF
	stmt:close()
	*----------------------------------------------
	
	db:close()	
RETURN ( NIL )


*------------------------------------------

	
	
STATIC FUNCTION FillData_tblbrg()
	LOCAL db := SQLiteFacade():new( M->csample_lookup )
	LOCAL stmt
	
	db:open()


	cStr:="INSERT INTO tblbrg ("
	cStr+="id_tblbrg"
	cStr+=",kode"
	cStr+=",nama"
	cStr+=",satuan"
	cStr+=",harga"
	cStr+=") VALUES ("
	cStr+=":id_tblbrg"
	cStr+=",:kode"
	cStr+=",:nama"
	cStr+=",:satuan"
	cStr+=",:harga"
	cStr+=")"
	
	stmt := db:prepare( cStr+";" )	
	stmt:setInteger( ":id_tblbrg", 1 )
	stmt:setString( ":kode", 'S01' )
	stmt:setString( ":nama", 'satu' )
	stmt:setString( ":satuan", 'pcs' )
	stmt:setFloat( ":harga", 100.00 )
	stmt:executeUpdate()
	
	stmt:reuse():clear()
	stmt:setInteger( ":id_tblbrg", 2 )
	stmt:setString( ":kode", 'D01' )
	stmt:setString( ":nama", 'dua' )
	stmt:setString( ":satuan", 'kg' )
	stmt:setFloat( ":harga", 10.50 )
	stmt:executeUpdate()
	
	
	
	stmt:close()
	db:close()
   
RETURN ( NIL )


	

#include "data_lookup.prg"
#include ".\lib\datamodule.prg"
#include ".\lib\lookup.prg"