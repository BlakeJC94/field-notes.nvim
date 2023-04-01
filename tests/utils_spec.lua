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
                assert.equals(tbl1[val], tbl2[val], val)
            end
        end

        it(
            "should read timestamps (%s)",
            function()
                local date_format = "file_%s"
                local input_str = "file_1234567891"
                assert_datetbl_dates_are_equal(
                    {day=14, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read dates (%x)",
            function()
                local date_format = "file %x"
                local input_str = "file 14/02/09"
                assert_datetbl_dates_are_equal(
                    {day=14, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read dates in custom arrangement (%d, %m, %Y)",
            function()
                local date_format = "file-%Y-%m-%d"
                local input_str = "file-2009-02-14"
                assert_datetbl_dates_are_equal(
                    {day=14, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read short year values < 70 as 2000s (%y)",
            function()
                local date_format = "file-%y"
                local input_str = "file-09"
                assert_datetbl_dates_are_equal(
                    {day=1, month=1, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read short year values >= 70 as 1900s (%y)",
            function()
                local date_format = "file-%y"
                local input_str = "file-70"
                assert_datetbl_dates_are_equal(
                    {day=1, month=1, year=1970},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read dates from yday (%Y, %j)",
            function()
                local date_format = "file %Y, %j"
                local input_str = "file 2009, 45"
                assert_datetbl_dates_are_equal(
                    {day=14, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read dates from mon weeknum (%Y, %W)",
            function()
                local date_format = "file %Y (%W)"
                local input_str = "file 2009 (06)"
                assert_datetbl_dates_are_equal(
                    {day=15, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read dates from sun weeknum (%Y, %U)",
            function()
                local date_format = "file %Y [%W]"
                local input_str = "file 2009 [05]"
                assert_datetbl_dates_are_equal(
                    {day=8, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read dates from mon weeknum and wday (%Y, %W, %w)",
            function()
                local date_format = "file %Y: %W %w"
                local input_str = "file 2009: 06 0"
                assert_datetbl_dates_are_equal(
                    {day=15, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should read dates from sun weeknum and wday (%Y, %U, %w)",
            function()
                local date_format = "file %Y: %U %w"
                local input_str = "file 2009: 07 0"
                assert_datetbl_dates_are_equal(
                    {day=15, month=2, year=2009},
                    get_datetbl_from_str(date_format, input_str)
                )
            end
        )

        it(
            "should fail if year can't be determined",
            function()
                local date_format = "file-%m-%d"
                local input_str = "file-02-14"
                local status_ok, err_msg = pcall(get_datetbl_from_str, date_format, input_str)
                assert(not status_ok)
                assert(string.match(string.lower(tostring(err_msg)), "year cannot be determined"))
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
