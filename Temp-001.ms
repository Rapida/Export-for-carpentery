for i in selection do convertToSplineShape i
for i in selection do (i.wirecolor = blue; i.vertexTicks = off;)
for i in selection do i.name = ("v-" + (i.pos.z as string))

sides = #("k1-","")
for i in selection do i.name = ("v-" + sides[1] + ((( ceil i.pos.z) as integer) as string) + sides[2] + "-001")
	
	
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
for i = 1 to selArray.count do selArray[i].name = ("k" + alphabet[i] + "-001")

selArray = selection
for i = 1 to selArray.count do selArray[i].name = ("k" + (i as string) + "-001")

for i in selection do
(
	str = "C-3-v-"
	_pos = i.pos.z 
	_pos = (_pos as integer) as string
	str2 = "-001"
	i.name = str + _pos + str2
	print i.name
)