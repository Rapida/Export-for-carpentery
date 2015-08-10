macroScript STL_DWG_Export
category:"Rapida Scripts" 
buttonText:"STL_DWG"
toolTip:"Export part as .stl and .dwg"
(
	filePath = maxFilePath	--find the name of component
	pathArr = filterString filePath "\\"
	partNum = pathArr[pathArr.count]	-- find the name of part
	projectExportDir = GetDir #export + "\\" + pathArr[3] + "\\" + pathArr[4]
	exportFilePath = projectExportDir + "\\" + partNum	-- export path
	stlPath = exportFilePath + "\\" + "STL"	-- create path for export stl
	format "stlPath = %\n" stlPath
	dwgPath = exportFilePath + "\\" + "DWG"-- create path for export dwg
	format "dwgPath = %\n" dwgPath
	fn exportPart _part _thicknes:1.7= 
	(
		_partName = _part.name
		_nameArr = filterString _partName "-"
		_fileName = _nameArr[1] + "-" + _nameArr[2]
		_oldTransform = _part.transform
		_newTransform = (matrix3 [-1,0,0] [0,1,0] [0,0,-1] [0,0,_thicknes])
		_stlName = stlPath + "\\" + _fileName + ".stl"
		_dwgName = dwgPath + "\\" + _fileName
		format "STL Export = %\n" _stlName
		format "dwg Export = %\n" _dwgName
		_part.transform = _newTransform
		select _part
		theClasses =exporterPlugin.classes
		exportFile _stlName using:STL_Export
	)
	selArr = selection as array
	for i in selArr do
	(
		exportPart i
	)
)