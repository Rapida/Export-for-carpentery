theObj = $'B'
thicknes = 1.7
baseName = theObj.name
fn iniPos obj po = 
(
	faceNormal = in coordsys obj (polyop.getFaceNormal obj po) --get the face normal
	worldUpVector = [0,0,1]
	rightVector = normalize ( cross worldUpVector faceNormal)
	upVector = normalize (cross rightVector faceNormal)
	theMatrix = matrix3 rightVector upVector faceNormal (polyop.getFaceCenter obj po)
	theMatrix
)
fn getVerts obj po =
(
	meshPos = iniPos obj po
	verts = polyop.getFaceVerts obj po
	vertsPos = for i in verts collect polyop.getVert obj i
	result = #(verts,vertsPos)
)
fn getEdges obj po =
(
	meshPos = iniPos obj po
	edges = polyop.getFaceEdges obj po
	edgeVerts = for i in edges collect polyop.getEdgeVerts obj i
	vertsPos = #()
	for i in edgeVerts do
	(
		ed = for n in i collect polyop.getVert obj n
		append vertsPos ed
	)
	edgeFaceCount = for i in edges collect polyop.getEdgeFaces obj i
	result = #(edges,edgeFaceCount,edgeVerts,vertsPos)
)
fn planerFn inArr =
(
	c1 = inArr[1]; c2 = inArr[2]; c3 = inArr[3];
	xa = c1.x; ya = c1.y; za = c1.z;
	xb = c2.x; yb = c2.y; zb = c2.z;
	xc = c3.x; yc = c3.y; zc = c3.z;
	a1 = -xa; a2 = -ya; a3 = -za;
-- 	format " % % % \n" a1 a2 a3
	b1 = xb-xa; b2 = yb-ya; b3 = zb-za;
-- 	format " % % % \n" b1 b2 b3
	d1 = xc-xa; d2 = yc-ya; d3 = zc-za;
-- 	format " % % % \n" d1 d2 d3
	ql1 = b2*d3 - b3*d2; ql2 = -(b1*d3 - b3*d1); ql3 = b1*d2 - b2*d1; 
-- 	format " % % % \n" ql1 ql2 ql3
	ds1 = ql1*a1; ds2 = ql2*a2; ds3 = ql3*a3;
	f1 = (ds1)+(ds2)+(ds3)
	#(ql1, ql2, ql3, f1)
)
fn addVert theMesh =
(
	newVertId = ((getNumVerts theMesh) + 1)
	setNumVerts theMesh newVertId true
	newVertId
)
fn parraPlane sArr poPos =
(
	n1 = sArr[1]; n2 = sArr[2]; n3 = sArr[3];
	x0 = poPos.x; y0 = poPos.y; z0 = poPos.z;
	d1 = n1*(-x0); d2 = n2*(-y0); d3 = n3*(-z0);
	D = d1+d2+d3
	result = #(n1,n2,n3,D)
)
fn edgeCenter vArr =
(
	a = vArr[1]; b = vArr[2];
	xa = a.x; ya = a.y; za = a.z;
	xb = b.x; yb = b.y; zb = b.z;
	xc = (xa+xb)/2; yc = (ya+yb)/2; zc = (za+zb)/2;
	center = [xc,yc,zc]
)
fn findFuckingPoint c1 c2 c3 =
	(
		n = [c1.x-c2.x, c1.y-c2.y, c1.z-c2.z]
		x1 = c3.x; y1 = c3.y; z1 = c3.z;
		ux = n.x; uy = n.y; uz = n.z;
		s1 = -ux*x1; s2 = -uy*y1; s3 = -uz*z1;
		ss = s1 + s2 + s3
		pli = #(ux, uy, uz, ss)
		t1 = pli[1]^2; t2 = pli[2]^2; t3 = pli[3]^2
		tt = t1 + t2 + t3
		st1 = ux*c2.x; st2 = uy*c2.y; st3 = uz*c2.z;
		stt = st1 + st2 + st3 + pli[4]
		t0 = -stt/tt
		x = ux*t0 + c2.x; y = uy*t0 + c2.y; z = uz*t0 + c2.z;
		p = [x,y,z]
	)
fn findIntersectionPoint plArr = 
(
	fn sortFunc inArr =
	(
		sortArr = #()
		for i = 1 to (inArr.count - 1) do
		(
			if i != (inArr.count - 1) then
			(t = #(inArr.count, i, i+1); append sortArr t;)
			else
			(t = #(inArr.count, i, 1);append sortArr t;)
		)
		sortArr
	)
	sortedArr = sortFunc plArr
	format "%\n" sortedArr
	fn plIntersect inArr sortArr =
	(
		result = #()
		for i = 1 to sortArr.count do 
		(
			fnIn = #()
			for n in sortArr[i] do
			(
				h = inArr[n]
				append fnIn h
	-- 			format "%: %\n" n h
			)
	-- 		print (fnIn as string)
			a1 = fnIn[1][1]; b1 = fnIn[1][2]; c1 = fnIn[1][3]; s1 = -fnIn[1][4];
			a2 = fnIn[2][1]; b2 = fnIn[2][2]; c2 = fnIn[2][3]; s2 = -fnIn[2][4]; 
			a3 = fnIn[3][1]; b3 = fnIn[3][2]; c3 = fnIn[3][3]; s3 = -fnIn[3][4]; 
	-- 		format "% % % %\n" a1 b1 c1 s1
	-- 		format "% % % %\n" a2 b2 c2 s2
	-- 		format "% % % %\n" a3 b3 c3 s3
			D = a1*b2*c3 + a3*b1*c2+a2*b3*c1-a3*b2*c1-a1*b3*c2-a2*b1*c3
	-- 		print (D == 0.0)
			if D != 0.0 then
			(
				D1 = s1*b2*c3 + s3*b1*c2+s2*b3*c1-s3*b2*c1-s1*b3*c2-s2*b1*c3
				D2 = a1*s2*c3 + a3*s1*c2+a2*s3*c1-a3*s2*c1-a1*s3*c2-a2*s1*c3
				D3 = a1*b2*s3 + a3*b1*s2+a2*b3*s1-a3*b2*s1-a1*b3*s2-a2*b1*s3
				fx = D1/D; fy = D2/D; fz = D3/D;
	-- 			format "D = % D1 = % D2 = % D3 = %\n" D D1 D2 D3
				fin = [fx, fy, fz]
-- 				print fin
				append result fin
				te1 = a1*fx+b1*fy+c1*fz
				te2 = a2*fx+b2*fy+c2*fz
				te3 = a3*fx+b3*fy+c3*fz
	-- 			format " % \n % \n % \n" te1 te2 te3
			)
		)
		result
	)

	intArr = plIntersect plArr sortedArr
-- 	for i in intArr do point pos:i size:0.1
	result = intArr
)
fn faceSort v1 v2 =
(
	result = #()
	for i = 2 to v1.count do
	(
		if i != v1.count then
		(
			n = #(v1[i], v1[i+1], v2[i], v2[i-1])
			append result n
		)
		else
		(
			n = #(v1[1], v1[i],  v2[i-1],v2[i])
			append result n
		)
	)
	n = #(v1[1], v1[2], result[1][4], v2[v2.count])
	append result n
	result
)
-- END OF FUNCTIONS --

faceCount = polyop.getNumFaces theObj
meshesArr = #()
for i = 1 to faceCount do
(
	format "Im work on % face\n" i
	meshPos = iniPos theObj i
	polygonVerts = getVerts theObj i
	polyEdges = getEdges theObj i
	meshName = uniqueName (baseName +"-"+ ( i  as string ) + "-")
	meshFases = if polygonVerts[1].count == 4 then #([1,2,3],[1,3,4]) else #([1,2,3])
	theMesh = editable_mesh name:meshName pos:(polyop.getFaceCenter theObj i) dir:(polyop.getFaceNormal theObj i) vertexTicks:on wireColor:blue
	meshPos = theMesh.transform
	for i = 1 to polygonVerts[2].count do 
	(
		newVert = addVert theMesh
		meshop.setVert theMesh newVert polygonVerts[2][i]
	)
	setNumFaces theMesh meshFases.count
	for i = 1 to meshFases.count do setFace theMesh i meshFases[i]
	newVert = addVert theMesh
	in coordsys meshPos meshop.moveVert theMesh newVert [0.0,0.0,-thicknes]
	in coordsys world newPoint = getVert theMesh newVert
-- 	format "newCenter: %\n" newPoint
	deleteVert theMesh newVert
	newMeshVertsArr = #()
	plansArr = #()
	for ed = 1 to polyEdges[1].count do
	(
		if polyEdges[2][ed].count == 1 then
		(
			vArr = polyEdges[4][ed] -- this Array have two verteces of source poly
			center = edgeCenter vArr
			newVert = addVert theMesh
			meshop.setVert theMesh newVert center
			in coordsys meshPos meshop.moveVert theMesh newVert [0.0,0.0,-thicknes]
				newCoord = getVert theMesh newVert
			append vArr newCoord
-- 			format "#(%, %, %)\n" vArr[1] vArr[2] vArr[3]
			localPlane = planerFn vArr
			deleteVert theMesh newVert
			append plansArr localPlane
-- 			format"pl%% = %\n" i ed localPlane
-- 			format "side open face: (%x) + (%y) + (%z) + (%)\n" localPlane[1] localPlane[2] localPlane[3] localPlane[4] 
		)
		else
		(
			newVert = addVert theMesh
			meshop.setVert theMesh newVert (edgeCenter (polyEdges[4][ed]))
			vArr = for p in polyEdges[2][ed] collect (polyop.getFaceCenter theObj p)
			center = findFuckingPoint vArr[1] vArr[2] (getVert theMesh newVert)
			vArr = polyEdges[4][ed]
			meshop.setVert theMesh newVert center
				newCoord = getVert theMesh newVert
			append vArr newCoord
			localPlane = planerFn vArr
			deleteVert theMesh newVert
			append plansArr localPlane
-- 			format"pl%% = %\n" i ed localPlane
-- 			format "side closed face: (%x) + (%y) + (%z) + (%)\n" localPlane[1] localPlane[2] localPlane[3] localPlane[4] 
		)
	)
	backP = planerFn polygonVerts[2] 
-- 	format "backP = %\nverts = %\n" backP polygonVerts[2]
	backPlane = parraPlane backP newPoint
	append plansArr backPlane
	newPointsArr = findIntersectionPoint plansArr
	newFaceVertsArr = #()
-- 	format "%\n" newPointsArr
	convertTo theMesh Editable_Poly
	fNum = polyop.getNumFaces theMesh
	oldFaceVertsArr = polyop.getFaceVerts theMesh 1
	format "v1 = %\n" oldFaceVertsArr
	for i in newPointsArr do
	(
		v = polyop.createVert theMesh i
		append newFaceVertsArr v
	)
	format "v2 = %\n" newFaceVertsArr
	newFaces = faceSort oldFaceVertsArr newFaceVertsArr
	format "v3= %\n" newFaces
	for i in newFaces do
	(
		polyop.createPolygon theMesh i
	)
	polyop.capHolesByVert theMesh newFaceVertsArr
-- 	newTest = for i = 1 to newFaceVertsArr.count collect newFaceVertsArr[i]
-- 		format "%\n" newTest
-- 	newP = polyop.createPolygon theMesh newTest
-- 	polyop.retriangulate theMesh #(1,2)
-- 	polyop.flipNormals theMesh #(1,2)
-- 	format"pl%% = %\n" i "b" backPlane
-- 	format "backface: (%x) + (%y) + (%z) + (%)\n" backPlane[1] backPlane[2] backPlane[3] backPlane[4]
-- 	format " - div - \n " 
	appendIfUnique meshesArr theMesh
)