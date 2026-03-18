local function parse_lines(output)
    local lines = {}
    for line in (output or ""):gmatch("([^\n]+)") do
        local cleaned = tostring(line):gsub("^%s+", ""):gsub("%s+$", "")
        if cleaned ~= "" then
            table.insert(lines, cleaned)
        end
    end
    return lines
end

local function run_command(command)
    local file = io.popen(command)
    if not file then
        return ""
    end

    local output = file:read("*a") or ""
    file:close()
    return output
end

local function get_workspaces()
    return parse_lines(run_command("aerospace list-workspaces --all"))
end

local function get_current_workspace()
    return parse_lines(run_command("aerospace list-workspaces --focused"))[1]
end

return {
    get_workspaces = get_workspaces,
    get_current_workspace = get_current_workspace,
}
