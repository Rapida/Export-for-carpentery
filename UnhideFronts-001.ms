fn hideFront _theObj =
(
	vertsBitArr = polyop.getVertsUsingFace _theObj 1
	facesToHideBitArr = polyop.getFacesUsingVert _theObj vertsBitArr
	polyop.setHiddenFaces _theObj facesToHideBitArr
)

for i in selection do
(
	theObj = i
	polyop.unHideAllFaces theObj
)