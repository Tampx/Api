function repeatValues(values, count)
	local repeated = {}
	local valuesCount = #values
	for i = 1, count do
		table.insert(repeated, values[(i - 1) % valuesCount + 1])
	end
	return repeated
end
function editValues(addresses, values, valueType)
	local edits = {}
	for i, address in ipairs(addresses) do
		table.insert(edits, {address = address, flags = valueType, value = values[i]})
	end
	gg.setValues(edits)
end
function CheckFile(FilePath)
	Check_file = io.open(FilePath, "r")
	if not Check_file then
		return false
	else
		return true
	end
end
function Check_Visible()
	if gg.isVisible(true) then
		gg.setVisible(false)
	end
end 
function CreateFolder(path)
	local ok, err, code = os.rename(path, path)
	if ok or code == 13 then
		return true
	else
		if path:sub(-1) ~= "/" then
			path = path .. "/"
		end
		local tempFile = path .. ".adf"
		gg.saveList(tempFile)
		os.remove(tempFile)
		return true
	end
end
function CheckProcessRunning(packageName)
	for pid, processInfo in pairs(gg.getProcess()) do
		if processInfo.cmdLine == packageName then
			gg.jumpAPP(packageName)
			gg.setProcess(packageName)
			return
		end
	end
	if gg.isPackageInstalled(packageName) then
		gg.jumpAPP(packageName)
		gg.setProcess(packageName)
	else
		gg.alert("Bạn chưa tải xuống " .. packageName .. "!")
		gg.exit()
	end
	loadfile(gg.getFile())()
end
function TamPxScriptRun(addresses, a2, a3)
	local tt = {}
	for i, address in ipairs(addresses) do
		tt[i] = {}
		tt[i].address = address
		tt[i].flags = a2
		tt[i].value = a3
	end
	gg.setValues(tt)
end
function Searchvalue(a1, a2, a3, a5)
	Check_Visible()
	gg.setRanges(a1)
	gg.searchNumber(a3, a2)
	a4 = gg.getResults(gg.getResultsCount())
	if #a4 == 0 then
		gg.alert("Lỗi Search: "..a3)
	end
	if not a5 then else
		gg.clearResults()
	end
	return a4
end
function Refinenumber(ReValue)
	Check_Visible()
	gg.refineNumber(ReValue[1], ReValue[2])
	Tablet = gg.getResults(gg.getResultsCount())
	if not ReValue[3] then else
		gg.clearResults()
	end
	return Tablet
end
function getAddresses(a)
	local addresses = {}
	for i, v in ipairs(a) do
		table.insert(addresses, v.address)
	end
	return addresses
end
function EditValue(a)
	gg.loadResults(a[1])
	local results = gg.getResults(gg.getResultsCount())
	gg.editAll(a[2], results[1].flags)
	gg.clearResults()
	return results
end
function RestoreValue(revert)
	if revert ~= nil then
		gg.setValues(revert)
	else
		gg.alert("Lỗi khi khôi phục giá trị !")
	end
end
function translate(text, target_lang)
	if type(text) ~= 'string' or #text < 1 then return text end
	local function url_encode(str)
	return str:gsub("([^%w])", function(c)
	return string.format("%%%02X", string.byte(c)) end) end
	local userAgent = {['User-Agent'] = 'GoogleTranslate/6.3.0.RC06.277163268 Linux; U; Android 14; A201SO Build/64.2.E.2.140'}
	local getTrans = gg.makeRequest('https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=' .. target_lang .. '&dt=t&q=' .. url_encode(text), userAgent)
	if type(getTrans) ~= 'table' then return text end
	local result = getTrans.content:match('["](.-)["]') return result or text
end
function ARM(arm,ret)
	gg.setVisible(false)
	local addr_list = gg.getRangesList('libc.so')
	local addr
	for _, v in ipairs(addr_list) do
		if v.type:sub(2, 2) == 'w' then
			addr = {address = v.start, flags = gg.TYPE_DWORD}
			break
		end
	end
	if not addr then gg.alert("Failed","") return end
	local function update_arm()
	local addr_num = tonumber('', 16)
	local num = tonumber(arm:match('0[xX](%x+)'), 16)
end
local old = gg.getValues({addr})
addr.value = '~A ' .. arm
pcall(gg.setValues, {addr})
local Result  = gg.getValues({addr})[1].value & 0xFFFFFFFF
gg.setValues(old)
Result  = string.unpack('>I4', string.pack('<I4', Result ))
Result  = string.format('%08X', Result )
if ret == "BX LR" then Result = Result.."1EFF2FE1" end
return "h"..Result
end
function handleColorValues(addresses, flags, mode)
	if mode == "lưu" then
		local values = {}
		for i, address in ipairs(addresses) do
			values[i] = {address = address, flags = flags}
		end
		originalValues = gg.getValues(values) -- Lưu giá trị
	elseif mode == "khôi phục" then
		if #originalValues > 0 then
			gg.setValues(originalValues) -- Khôi phục
		else
			gg.alert("Không có giá trị gốc để khôi phục.")
		end
	end
end
function LoadColorValues()
	Searchvalue(1048576, 1, "h 00 00 00 00 1F 85 6B 3E 00 00 00 00", nil)
	ColorAddress = getAddresses(Refinenumber({"h 1F", 1, true}))
	AddressBlue = {}
	AddressGreen = {}
	AddressRed = {}
	AddressBackRed = {}
	for i, address in ipairs(ColorAddress) do
		AddressBlue[i] = address - 136
		AddressGreen[i] = address - 140
		AddressRed[i] = address - 152
		AddressBackRed[i] = address - 180
	end
	local allAddresses = {}
	for i, address in ipairs(ColorAddress) do
		table.insert(allAddresses, address)
	end
	for i, address in ipairs(AddressBlue) do
		table.insert(allAddresses, address)
	end
	for i, address in ipairs(AddressGreen) do
		table.insert(allAddresses, address)
	end
	for i, address in ipairs(AddressRed) do
		table.insert(allAddresses, address)
	end
	for i, address in ipairs(AddressBackRed) do
		table.insert(allAddresses, address)
	end
	handleColorValues(allAddresses, 16, "lưu")
	setLoadColor = true
end
function CheckStateChange(oldState, newState, Number)
	for i = Number[1], Number[2] do
		if oldState[i] ~= newState[i] then
			return true
		end
	end
	return false
end
