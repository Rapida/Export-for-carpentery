targetObj = $
vertsCount = polyop.getNumVerts targetObj
facesCount = polyop.getNumFaces targetObj
frontVerts = (polyop.getVertsUsingFace targetObj 1)as array
backVerts = (polyop.getVertsUsingFace targetObj facesCount) as array
-- vertsBitArray = #{1..vertsCount}
-- vertsForTest = vertsBitArray - frontVerts
-- polyop.chamferVerts $ vertsForTest 3.0
localName = targetObj.name
filteredName = filterString localName "-"
sourceName = filteredName[1]
for i = 2 to filteredName.count - 2 do sourceName += ("-" + filteredName[i])
sourceObj = execute ("$'" + sourceName + "'")
sourcePolygonNum = filteredName[filteredName.count-1] as integer
sourceVerts = polyop.getVertsUsingFace sourceObj sourcePolygonNum
sourceNum = (sourceVerts as array)
format "%\n" frontVerts
newOrder = #()
for i = 1 to frontVerts.count do
(
	a = polyop.getVert targetObj frontVerts[i]
	a.x = a.x as integer; a.y = a.y as integer; a.z = a.z as integer;
	for n in sourceNum do
	(
		b = polyop.getVert sourceObj n
		b.x = b.x as integer; b.y = b.y as integer; b.z = b.z as integer;
		if a.x == b.x and a.y == b.y and a.z == b.z do
		(
			if i > 1 and newOrder[i-1] == undefined then i = i-1
			insertItem n newOrder i
			format "n = %; i = %; newOrder = %\n" n i newOrder
		)
	)
)
while (findItem newOrder undefined) != 0 do
(
	_id = findItem newOrder undefined
	deleteItem newOrder _id
)

chamferVertsArr = #()
for n = 1 to newOrder.count do
(
	j = newOrder[n]
	format "n = %; j = %; newOrder = %\n" n j newOrder
	fBitArr = polyop.GetFacesUsingVert sourceObj j
	fArr = fBitArr as array
	if fArr.count > 2 do
	(
		p = frontVerts[n]
		vertsEdges = polyop.getEdgesUsingVert targetObj p
		faceEdges = polyop.getEdgesUsingFace targetObj 1
		theEdge = vertsEdges - faceEdges
		vertsForMesurment = (polyop.getVertsUsingEdge targetObj theEdge)
		vertsArr = vertsForMesurment as array
		targetVert = vertsForMesurment - #{p}
		dist = distance (polyop.getVert targetObj vertsArr[1]) (polyop.getVert targetObj vertsArr[2])
		chamferDataArr = #(dist, (polyop.getVert targetObj (targetVert as array)[1]))
		print (chamferDataArr as string)
			append chamferVertsArr chamferDataArr
		format "mesurEdge = %; dist = %; theVert = %\n" theEdge dist targetVert
	)
)
format "%\n" chamferVertsArr
fn findVert _pos _obj = 
(
	n = undefined
	co = polyop.getNumVerts _obj
	for i = 1 to co do
	(
		if polyop.getVert _obj i == _pos do n = i
	)
	n
)
weldArr = frontVerts as bitarray
for i = 1 to chamferVertsArr.count do
(
	p = chamferVertsArr[i][2]
	ch = chamferVertsArr[i][1]
	startCount = polyop.getNumVerts targetObj
	endCount = if i == 1 then startCount else startCount + (i - 1)*3
	t = findVert p targetObj
	append weldArr t
	polyop.chamferVerts targetObj t ch
)
format "%\n" weldArr
polyop.weldVertsByThreshold targetObj weldArr
targetObj.vertexTicks = off
if targetObj.wirecolor == red do targetObj.wirecolor = blue
