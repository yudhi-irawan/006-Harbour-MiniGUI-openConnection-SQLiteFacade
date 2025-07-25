*--------------------------------------------------------------*
function openConnection()                         
*--------------------------------------------------------------*
LOCAL cFileDB:=M->csample_lookup
LOCAL oServer := SQLiteFacade():new( cFileDB )
oServer:open()
Return oServer