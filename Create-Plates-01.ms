theObj = $'A001'
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
	in coordsys meshPos vertsPos = for i in verts collect polyop.getVert obj i
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
		in coordsys meshPos ed = for n in i collect polyop.getVert obj n
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
	a1 = xa; a2 = ya; a3 = za;
	b1 = xb-xa; b2 = yb-ya; b3 = zb-za;
	d1 = xc-xa; d2 = yc-ya; d3 = zc-za;
	ql1 = b2*d3 - b3*d2; ql2 = b1*d3 - b3*d1; ql3 = b1*d2 - b2*d1; 
	ds1 = ql1*a1; ds2 = -ql2*a2; ds3 = ql3*a3;
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
	d1 = n1*x0; d2 = n2*y0; d3 = n3*z0;
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
faceCount = polyop.getNumFaces theObj
meshesArr = #()
for i = 1 to faceCount do
(
	meshPos = iniPos theObj i
	polygonVerts = getVerts theObj i
	polyEdges = getEdges theObj i
	meshName = uniqueName (baseName +"-"+ ( i  as string ) + "-")
	meshFases = if polygonVerts[1].count == 4 then #([1,2,3],[1,3,4]) else #([1,2,3])
	theMesh = mesh vertices:polygonVerts[2] faces:meshFases name:meshName transform:meshPos vertexTicks:on wireColor:red
	newVert = addVert theMesh
	in coordsys meshPos meshop.moveVert theMesh newVert [0.0,0.0,-thicknes]
	newPoint = getVert theMesh newVert
	newMeshVertsArr = #()
	for ed = 1 to polyEdges[1].count do
	(
		if polyEdges[2][ed].count == 1 then
		(
			vArr = polyEdges[4][ed] -- this Array have two verteces of source poly
			center = edgeCenter vArr
			newVert = addVert theMesh
			in coordsys meshPos meshop.setVert theMesh newVert center
			in coordsys meshPos meshop.moveVert theMesh newVert [0.0,0.0,-thicknes]
				newCoord = getVert theMesh newVert
			append vArr newCoord
-- 			format "#(%, %, %)\n" vArr[1] vArr[2] vArr[3]
			localPlane = planerFn vArr
			format"pl%% = %\n" i ed localPlane
-- 			format "side open face: (%x) + (%y) + (%z) + (%)\n" localPlane[1] localPlane[2] localPlane[3] localPlane[4] 
		)
		else
		(
			newVert = addVert theMesh
			in coordsys meshPos meshop.setVert theMesh newVert (edgeCenter (polyEdges[4][ed]))
			vArr = for p in polyEdges[2][ed] collect (polyop.getFaceCenter theObj p)
			center = findFuckingPoint vArr[1] vArr[2] (getVert theMesh newVert)
			vArr = polyEdges[4][ed]
			meshop.setVert theMesh newVert center
				newCoord = getVert theMesh newVert
			append vArr newCoord
			localPlane = planerFn vArr
			format"pl%% = %\n" i ed localPlane
-- 			format "side closed face: (%x) + (%y) + (%z) + (%)\n" localPlane[1] localPlane[2] localPlane[3] localPlane[4] 
		)
	)
	test = planerFn polygonVerts[2]
	testPara = parraPlane test newPoint
	format"pl%% = %\n" i "b" testPara
-- 	format "backface: (%x) + (%y) + (%z) + (%)\n" testPara[1] testPara[2] testPara[3] testPara[4]
	format " - div - \n " 
	appendIfUnique meshesArr theMesh
)