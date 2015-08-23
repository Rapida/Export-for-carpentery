for i in selection do convertToSplineShape i
for i in selection do (i.wirecolor = blue; i.vertexTicks = off;)
for i in selection do i.name = ("C-8-V-" + (i.pos.z as string))
	
	
macros.run "Modifier Stack" "SubObject_1"
actionMan.executeAction 0 "40021"  -- Selection: Select All
macros.run "Editable Spline Object" "ESpline_Weld"
subobjectLevel = 0
actionMan.executeAction 0 "40044"
	

fn centerFloor obj = 
(
	_center = obj.center
	_center.z = obj.min.z
	obj.pivot = _center
)
for i in selection do centerFloor i
	
alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
selArray = selection
for i = 1 to selArray.count do selArray[i].name = ("C-5-k" + alphabet[i] + "-001")

for i in selection do
(
	str = "C-5-A-V-k10-"
	_pos = i.pos.z 
	_pos = (_pos as integer) as string
	str2 = "-k11"
	i.name = str + _pos + str2
	print i.name
)