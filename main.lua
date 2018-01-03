local ok, err = pcall( function()
    if http then
        aa = aa or {}
        local a = http.get("http://api.dannysmc.com/files/apis/discover.lua")
        a = a.readAll()
        local env = {}
        a = loadstring(a)
        local env = getfenv()
        setfenv(a,env)
        local status, err = pcall(a, unpack(aa))
        if (not status) and err then
            printError("Error loading api")
            return false
        end
        local returned = err
        env = env
        _G["discover"] = env
    end
end)
if not ok then
    error("Could not install API")
end
local mainMenu = {
"Login",
"Cloud",
"Browse"
}
local function menu(tbl)
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.clear()
  local selected = 1
  while true do
    term.clear()
    local scroll = 0
    if selected > 19 then
      scroll = selected-19
    end
    for i = 1+scroll, #tbl+scroll do
      term.setCursorPos(2, i)
      term.write(tbl[i])
    end
    term.setCursorPos(1, selected-scroll)
    term.write(">")
    local act = { os.pullEvent("key") }
    if act[2] == keys.up and selected > 1 then
      selected = selected-1
    elseif act[2] == keys.down and selected < #tbl then
      selected = selected+1
    elseif act[2] == keys.enter then
      return tbl[selected]
    end
  end
end
while true do
  local action = menu(mainMenu)
  if action == "Login" then
    term.clear()
    term.setCursorPos(1, 1)
    write("Username: ")
    local username = read()
    write("Password: ")
    local password = read("*")
    local status = Discover.User:Login(username, password)
    print(tostring(status))
    sleep(1)
  elseif action == "Cloud" then
    local status, files = Discover.Cloud:List()
    local file = menu(files)
    Discove.Cloud:Install(file)
  end
end
