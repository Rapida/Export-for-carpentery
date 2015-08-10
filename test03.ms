fn createPoints count:10 _from:[0,0,0] _to:[10,10,0] =
(
	pArr = #()
	point_size = abs(_from.x - _to.x)/10
	for i = 1 to count do
	(
		x = random _from.x _to.x; y = random _from.y _to.y; z = random _from.z _to.z; 
		_pos = [x,y,z]
		p = point pos:_pos size:point_size wirecolor:blue
		append pArr p
	)
	pArr
)
-- pArr = createPoints count:20 _from:[-10,-10,0] 
-- print pArr

po1 = [0,0,0]
po2 = [10,10,10]
fn vector p1 p2 = 
(
	n = p1p2 = [p2.x-p1.x, p2.y-p1.y, p2.z-p1.z]
)

v = vector po1 po2

fn planeBy2Points p1 p2 = 
(
	n = p1p2 = [p2.x-p1.x, p2.y-p1.y, p2.z-p1.z]
	a = p1
	D = -(a.x*n.x)-(a.y*n.y)-(a.z*n.z)
	pl = #(n.x, n.y, n.z, D)
)

projPlane = planeBy2Points po1 po2
format "projectionPlane = %\n" projPlane

fn theMatrix _vector _pos =
(
	_normal = _vector
	worldUpVector = [0,0,1]
	rightVector = normalize (cross worldUpVector _normal)
	upVector = normalize ( cross rightVector _normal )
	theMatrix =matrix3 rightVector upVector _normal _pos
)
testMatrix = theMatrix v po2

	fn findFirstPoint pArr =
	(
		nArr = for n = 1 to pArr.count collect n
		fn compareFNx v1 v2 valArray: = 
		(
			v1i = valArray[v1]; v2i = valArray[v2];
			local d = v1i.x - v2i.x
				case of
				(
					(d < 0): -1
					(d > 0): 1
					default: 0
				)
		)
		fn compareFNy v1 v2 valArray: = 
		(
			v1i = valArray[v1]; v2i = valArray[v2];
			local d = v1i.y - v2i.y
				case of
				(
					(d < 0): -1
					(d > 0): 1
					default: 0
				)
		)
		qsort nArr compareFNy valArray:pArr
		startEnd = #()
		for n = 2 to nArr.count do 
		(
			start = nArr[1]; id = nArr[n]; lookupKey = pArr[start].y ;
			if pArr[start].y == pArr[id].y do append startEnd n
		)
		if startEnd.count > 0 do qsort nArr compareFNx valArray:pArr end:(amax startEnd)
		result = nArr
	)
posArr = for i in pArr collect i.pos
_min  = [-10,-10,0]
sortResult = findFirstPoint posArr 
format " sorted array = %\n" sortResult
fn compareRot1 v1 v2 valArray: = 
(
	v0 = valArray[firstPoint]; v1i = valArray[v1]; v2i = valArray[v2]
-- 	if firstPoint == v1 do exit;
	a1 = v0.x; b1 = v0.y; c1 = 1;
	a2 = v1i.x; b2 = v1i.y; c2 = 1;
	a3 = v2i.x; b3 = v2i.y; c3 = 1;
	d = a1*b2*c3+a3*b1*c2+a2*b3*c1-a2*b2*c1-a1*b3*c2-a2*b1*c3
-- 	format "v0 = %; v1 = %; v2 = % d = %;\n" firstPoint v1 v2 d
	case of
	(
-- 		(firstPoint = v2): 0
		( d > 0 ): -1
		( d < 0 ): 1
		default: 0
	)
)
fn compareRot2 v1 v2 valArray: = 
(
	v0 = valArray[firstPoint]; v1i = valArray[v1]; v2i = valArray[v2]
	_bx = v0.x; _by = v0.y; c1 = 1;
	_qx = v1i.x; _qy = v1i.y; c2 = 1;
	_rx = v2i.x; _ry = v2i.y; c3 = 1;
	d = (_qx - _bx)*(_ry - _by) - (_qy - _by)*(_rx - _bx)
	case of
	(
		( d > 0 ): -1
		( d < 0 ): 1
		default: 0
	)
)
fn findBorder sourcePosArray firstSortedArray = 
(
	_source = sourcePosArray; _firstPoint = firstSortedArray;
	_temp = deepCopy firstSortedArray; deleteItem _temp 1;
	new_temp = deepCopy _temp
	result = #(); append result _firstPoint[1]
	for i = 1 to _temp.count do
	(
		firstPoint = result[result.count]
		if i > 1 do appendIfUnique new_temp _firstPoint[1]
			qsort new_temp compareRot2 valArray:sourcePosArray
			format "% = %\n" i new_temp
		appendIfUnique result new_temp[1]
		if new_temp[2] == _firstPoint[1] do exit;
	)
	result
)
-- border = findBorder posArr sortResult

fn DrawSpline arr = 
(
	ss = SplineShape pos:posArr[arr[1]]
		addNewSpline ss
		for n = 1 to arr.count do
		(
			addKnot ss 1 #corner #line posArr[arr[n]]
		)
		if (numSegments ss 1) > 1 and (isClosed ss 1) == false do close ss 1

		updateShape ss
	ss
)
-- DrawSpline border
