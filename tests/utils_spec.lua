describe(
    "slugify",
    function()
        local slugify = require("field_notes.utils").slugify

        it(
            "should lowercase words",
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
