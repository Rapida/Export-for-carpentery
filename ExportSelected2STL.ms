(
global STL_Object_Name = ""

fn SetSTLExportOptions = 
	(
	local BM_GETSTATE = 0xF2
	local BM_CLICK = 0xF5
	local BM_SETCHECK = 0xF1
	local BST_CHECKED = 0x1
		
	WindowHandle = DialogMonitorOPS.GetWindowHandle()
	if ((UIAccessor.GetWindowText WindowHandle) == "Export STL File") then
		(
		children = UIAccessor.GetChildWindows WindowHandle
		for i = 1 to children.count do
			(
			child = children[i]
			childTitle = (UIAccessor.GetWindowText child)
			if (childTitle == "Object01") then
				UIAccessor.SetWindowText child STL_Object_Name
			if (childTitle == "ASCII") then
				(
				rbState = windows.sendMessage child BM_GETSTATE 0 0
				rbChecked = bit.get rbState BST_CHECKED
				if (rbChecked == false) then
					(
					windows.sendMessage child BM_CLICK 0 0
					windows.sendMessage child BM_SETCHECK 1 0						
					)
				)
			if (childTitle == "Selected only") then
				(
				cbState = windows.sendMessage child BM_GETSTATE 0 0
				checked = bit.get cbState BST_CHECKED
				if (checked == false) then
					(
					windows.sendMessage child BM_CLICK 0 0
					windows.sendMessage child BM_SETCHECK 1 0						
					)
				)
			)
		uiAccessor.sendMessageID WindowHandle #IDOK	
		)
	true
	)

DialogMonitorOPS.unRegisterNotification id:#Set_STL_Export_Options
DialogMonitorOPS.RegisterNotification SetSTLExportOptions id:#Set_STL_Export_Options
DialogMonitorOPS.Enabled = true
	
selected = for obj in selection collect obj
for obj in selected do
	(
	STL_Object_Name = obj.name
	select obj
	exportFile ((getDir #export) + "/" + STL_Object_Name + ".stl")
	)
	
DialogMonitorOPS.Enabled = false
DialogMonitorOPS.unRegisterNotification id:#Set_STL_Export_Options
)
