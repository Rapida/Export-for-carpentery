fn hideFront _theObj _id:1 =
(
	_fNum = polyop.getNumFaces _theObj
	facesToHideBitArr = #{}
	for f = 1 to _fNum do
	(
		if (_theObj.GetFaceMaterial f) != _id then append facesToHideBitArr f
	)
-- 	vertsBitArr = polyop.getVertsUsingFace _theObj 1
-- 	facesToHideBitArr = polyop.getFacesUsingVert _theObj vertsBitArr
	polyop.setHiddenFaces _theObj facesToHideBitArr
)

for i in selection do
(
	backId = 3
	theObj = i
	hideFront theObj _id:backId
)