describe(
    "slugify",
    function()
        local slugify = require("field_notes.utils").slugify

        it(
            "should lowercase words by default",
            function()
                assert.equals("foo", slugify("Foo"))
                assert.equals("bar", slugify("bAr"))
                assert.equals("baz", slugify("BAZ"))
            end
        )
        it(
            "should not lowercase words if specified",
            function()
                assert.equals("Foo", slugify("Foo", true))
                assert.equals("bAr", slugify("bAr", true))
                assert.equals("BAZ", slugify("BAZ", true))
            end
        )
        it(
            "leaves underscores unmodified",
            function()
                assert.equals("foo_bar_baz", slugify("foo_bar_baz"))
            end
        )
        it(
            "replaces spaces with underscores",
            function()
                assert.equals("foo_bar_baz", slugify("foo bar baz"))
            end
        )
        it(
            "separates words with at most one underscore",
            function()
                assert.equals("foo_bar", slugify("foo    bar"))
            end
        )
        it(
            "trims leading and trailing underscores",
            function()
                assert.equals("foo_bar", slugify(" foo bar   "))
                assert.equals("foo_bar", slugify("___foo bar_"))
            end
        )
        it(
            "replaces brackets with underscores",
            function()
                assert.equals("foo_bar_baz", slugify("foo (bar) baz"))
                assert.equals("foo_bar_baz", slugify("foo [bar] baz"))
                assert.equals("foo_bar_baz", slugify("foo {bar} baz"))
                assert.equals("foo_bar_baz", slugify("foo <bar> baz"))
                assert.equals("foo_bar_baz", slugify("foo 'bar' baz"))
                assert.equals("foo_bar_baz", slugify('foo "bar" baz'))
            end
        )
        it(
            "replaces punctuation with underscores",
            function()
                assert.equals("foo_bar", slugify("foo:bar"))
                assert.equals("foo_bar", slugify("foo;bar"))
                assert.equals("foo_bar", slugify("foo-bar"))
                assert.equals("foo_bar", slugify("foo=bar"))
                assert.equals("foo_bar", slugify("foo.bar"))
                assert.equals("foo_bar", slugify("foo,bar"))
            end
        )
        it(
            "replaces quotes with underscores",
            function()
                assert.equals("foo_bar_baz", slugify("foo `bar` baz"))
                assert.equals("foo_bar_baz", slugify('foo "bar" baz'))
                assert.equals("foo_bar_baz", slugify("foo 'bar' baz"))
            end
        )
    end
)

describe(
    "get_datetbl_from_str",
    function()
        local get_datetbl_from_str = require("field_notes.utils").get_datetbl_from_str
        local function assert_datetbl_dates_are_equal(tbl1, tbl2)
            for _, val in ipairs({"day", "month", "year"}) do
                assert.equals(tbl1[val], tbl2[val])
            end
        end

        it(
            "should read timestamps",
            function()
                local date_format = "file_%s"
                local input_str = "file_1234567891"
                assert_datetbl_dates_are_equal(
                    {day=14, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )
    end
)

-- describe(
--     "create_dir",
--     function()
--         local create_dir = require("neozettel.utils").create_dir
--         -- TODO create a mock filesystem
--         -- TODO mock vim api calls and returns

--         -- it(
--         --     "should lowercase words",
--         --     function()
--         --         assert.equals("foo", slugify("Foo"))
--         --         assert.equals("bar", slugify("bAr"))
--         --         assert.equals("baz", slugify("BAZ"))
--         --     end
--         -- )
--     end
-- )
