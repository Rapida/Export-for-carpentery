fn bissect b c a = 
(
	AB = [b.x - a.x, b.y - a.y, b.z - a.z]
	AC = [c.x - a.x, c.y - a.y, c.z - a.z]
	L = length AB / length AC
	d = [0,0,0]
	d.x = (b.x + L * c.x)/ (1 + L)
	d.y = (b.y + L * c.y)/ (1 + L)
	d.z = (b.z + L * c.z)/ (1 + L)
	d
)
fn planeBy2Points p1 p2 = 
(
	n = p1p2 = [p2.x-p1.x, p2.y-p1.y, p2.z-p1.z]
-- 	format " n = %\n" n
	a = p1
	D = -(a.x*n.x)-(a.y*n.y)-(a.z*n.z)
	pl = #(n.x, n.y, n.z, D)
)
fn pointProjectionOnPlane po pl = 
(
	plx = pl[1]; ply = pl[2]; plz = pl[3]; pld = pl[4];
	plN = [plx,ply,plz]; zn = [1,1,1];
	if plx == 0 then zn.x = 0
	if ply == 0 then zn.y = 0
	if plz == 0 then zn.z = 0
-- 	format "zn = %\n" zn
	f1x =(-po.x*plx*zn.x); f1y = (-po.y*ply)*zn.y; f1z = (-po.z*plz)*zn.z;
-- 	format "f1x = %; f1y = %; f1z = %;\n" f1x f1y f1z
	f1 = pld - f1x - f1y - f1z
	f2 = plx*plN.x + ply*plN.y +plz*plN.z
-- 	format "f1 = %\n" f1
-- 	format "f2 = %\n" f2
	t = -f1/f2
-- 	format "t = %\n" t
	x = t*plN.x-(-po.x); y = t*plN.y-(-po.y); z = t*plN.z-(-po.z);
	[x,y,z]
)
fn lookForAngle edgeCenter faceCenter1 faceCenter2 edgeEnd = 
(
	intersectPlane = planeBy2Points edgeCenter edgeEnd
	projection1 = pointProjectionOnPlane faceCenter1 intersectPlane
	projection2 = pointProjectionOnPlane faceCenter2 intersectPlane
	result = bissect projection1 projection2 edgeCenter
)
A = [0,0,0] -- Center of edge
B = [10,5,7] -- Center Point of plane
C = [10,1,0] -- Another center of plane
G1 = [0,8,10]
po = [0,8,0] --End of edge
ve = A --center point
bis = bissect B C A
newPlane = planeBy2Points ve po
proj1 = pointProjectionOnPlane C newPlane
proj2 = pointProjectionOnPlane G1 newPlane
newBis = bissect proj1 proj2 ve
d = lookForAngle A C G1 po
spArr = #(#(ve, proj1, proj2),#(ve, d))
fn DrawSpline arr = 
(
	ss = SplineShape pos:arr[1][1]
	for i = 1 to arr.count do
	(
		addNewSpline ss
		for n = 1 to arr[i].count do
		(
			addKnot ss i #corner #line arr[i][n]
		)
		if (numSegments ss i) > 1 and (isClosed ss i) == false do close ss i
	)
		updateShape ss
	ss
)
newSpline = DrawSpline spArr
format "bis = %\n" bis
format "newPlane = %\n" newPlane
format "proj1 = %\n" proj1
format "proj2 = %\n" proj2
format "newBis = %\n" newBis
