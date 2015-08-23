	filePath = maxFilePath	--find the name of component
	pathArr = filterString filePath "\\"
	partNum = pathArr[pathArr.count]	-- find the name of part
	projectExportDir = GetDir #export + "\\" + pathArr[3] + "\\" + pathArr[4]
	exportFilePath = projectExportDir + "\\" + partNum	-- export path
-- 	stlPath = exportFilePath + "\\" + "STL"	-- create path for export stl
-- 	format "stlPath = %\n" stlPath
	format "objPath = \"%\"\n" objPath
	fn exportPart _part _thicknes:1.7= 
	(
		_partName = _part.name
		_nameArr = filterString _partName "-"
		_objDir = _nameArr[1] + _nameArr[2]
		_fileName = _nameArr[1]
		objPath += ("\\" + _objDir)
		_dir = makeDir objPath
-- 		format "dir = %\n" _dir
		for i = 2 to _nameArr.count-1 do _fileName += ("-" + _nameArr[i])
-- 		format "fileName = %\n" _fileName
		_oldTransform = _part.transform
		_newTransform = (matrix3 [-1,0,0] [0,1,0] [0,0,-1] [0,0,0])
		s1 = _fileName
		s2 = "."
		s3 = "p"
		_fileName = substituteString s1 s2 s3
		_objName = objPath + "\\" + _fileName + ".obj"
		format "OBJ Export = \"%\"\n" _objName
		_part.transform = _newTransform
		print _part.pos
-- 		_part.transform = _newTransform
-- 		select _part
-- 		theClasses =exporterPlugin.classes
		exportFile _objName selectedOnly:true using:ObjExp
		_part.transform = _oldTransform
	)
	selArr = selection as array
	deselect selection
	for i = 1 to selArr.count do
	(
		select selArr[i]
		_item = $
		objPath = exportFilePath + "\\" + "OBJ"-- create path for export dwg
		exportPart _item
		print _item.name
	)
-- 	for i = 1 to selArr.count do
-- 	(
-- 		objPath = exportFilePath + "\\" + "OBJ"-- create path for export dwg
-- 		exportPart i
-- 	)
	select selArr