-- Batch Export to DWG with offset 2 mm, and scale to mm.
fn fileName _name =
(
	rArr = filterString _name "_"
	result = rArr[1] + "-" + rArr[rArr.count]
)

fn offsetSpline _spline = 
(
	_name = fileName _spline.name
	_spline = copy _spline
	_spline.name = _name
	_strtCount = numSplines _spline
	applyOffset _spline -0.2
	_newCount = numSplines _spline
	deleteSpline _spline 1
	_spline.wirecolor = red
	_spline
)
selArr = selection as array
deselect selection
fn exportToDwg _spl = 
(
	oldPos = _spl.pos
	newPos = [0,0,0]
	oldScale = _spl.scale
	newScale = oldScale * 10
	fileName = "C-3-" + _spl.name + ".dwg"
	filePath = "Z:\\export\\Sushigami\\Orlando\\C-3\\DWG\\"
	fullName = filePath +fileName
	_spl.pos = newPos
	_spl.scale = newScale
	exportFile fullName selectedOnly:true using:DWG_ExportExporterPlugin
	_spl.pos = oldPos
	_spl.scale = oldScale
)
for i in selArr do
(
	select i
	exportToDwg $
)
select selArr
-- fileName $.name
-- newShape = offsetSpline $
-- for i in selection do offsetSpline i
-- select newShape