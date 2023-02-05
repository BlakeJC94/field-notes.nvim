local function reload_neozettel()
    for k in pairs(package.loaded) do
        if k:match("^neozettel") then
            package.loaded[k] = nil
        end
    end
    require("neozettel").setup()
end

vim.api.nvim_create_user_command(
    "ReloadNeoZettel",
    reload_neozettel,
    {force=true}
)

local function test_neozettel()
    print("TESTING")
end

vim.api.nvim_create_user_command(
    "Test",
    test_neozettel,
    {force=true}
)

