-- Block of tests
describe("some basics", function()

    -- function to test
    local bello = function(boo)
        return "bello " .. boo
    end

    -- declare state
    local bounter

    -- called before each test
    before_each(function()
        bounter = 0
    end)

    -- test 1
    it("some test", function()
        bounter = 100
        assert.equals("bello Brian", bello("Brian"))
    end)

    -- test 2
    it("some other test", function()
        assert.equals(0, bounter)
    end)
end)
