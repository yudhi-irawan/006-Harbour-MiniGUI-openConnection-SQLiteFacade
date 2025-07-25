#include <hmg.ch>

/*
1.  LookUp_Barang
*/

********************************************************************************************************************************************
*1
function LookUp_Barang(cFormTarget,cLabelNameTarget,cfrmLookUpName,oConnection)

myLookUp:=TLookUp():New(cfrmLookUpName)
myLookUp:oConnection:=oConnection


myLookUp:TableName:='tblBrg'
myLookUp:FieldNames:={'id_tblbrg','kode','nama','satuan','harga'}
myLookUp:FieldSearchCode:='kode'
myLookUp:FieldSearchDescription:='nama'

myLookUp:GridData_headers:={'id_tblbrg','Kode','nama','satuan','harga'}
myLookUp:GridData_widths:={100,100,250,100,100}				
myLookUp:GridData_justify:={BROWSE_JTFY_RIGHT,BROWSE_JTFY_LEFT,BROWSE_JTFY_LEFT,BROWSE_JTFY_LEFT,BROWSE_JTFY_RIGHT}			
myLookUp:GridData_columncontrols:={ {'TEXTBOX','NUMERIC'}, {'TEXTBOX','CHARACTER'}, {'TEXTBOX','CHARACTER'}, {'TEXTBOX','CHARACTER'}, {'TEXTBOX','NUMERIC'} }	

myLookUp:Exec()

if len(myLookUp:OutPut) = 2+1+2
 //SetProperty( cFormTarget, 'meid_tblbrg', 'Value', myLookUp:OutPut[1] )
 SetProperty( cFormTarget, 'mekode', 'Value', myLookUp:OutPut[2] )
 SetProperty( cFormTarget, 'menama', 'Value', myLookUp:OutPut[3] )
 SetProperty( cFormTarget, 'mesatuan', 'Value', myLookUp:OutPut[4] )
 SetProperty( cFormTarget, 'meharga', 'Value', myLookUp:OutPut[5] )
 
 //SetProperty( cFormTarget, 'meOrganizationDescription', 'Value', myLookUp:OutPut[2] )
 //SetProperty( cFormTarget, 'meOrganizationDescription', 'Enabled', .F. )
endif
		  
myLookUp:Release()

return nil
*
*
*
