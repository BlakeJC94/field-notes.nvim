local mock = require('luassert.mock')
local stub = require('luassert.stub')

describe("note command", function()
    require("neozettel").setup()

    it("opens a file when called with args in git dir", function()
        local utils = mock(require("neozettel.utils"), true)
        utils.slugify.returns("foo_bar")

        vim.cmd("NeoZettel note foo bar")

        assert.stub(utils.edit_file).was_called(1)
    end)
end)
