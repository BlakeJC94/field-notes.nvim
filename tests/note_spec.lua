describe(
    "slugify",
    function()
        local slugify = require("neozettel.note").slugify

        it(
            "should lowercase words",
            function()
                assert.equals("foo", slugify("Foo"))
                assert.equals("bar", slugify("bAr"))
                assert.equals("baz", slugify("BAZ"))
            end
        )
        it(
            "should leave underscores unmodified",
            function()
                assert.equals("foo_bar_baz", slugify("foo_bar_baz"))
            end
        )
        it(
            "should replace spaces with underscores",
            function()
                assert.equals("foo_bar_baz", slugify("foo bar baz"))
            end
        )
        it(
            "should separate words with at most one underscore",
            function()
                assert.equals("foo_bar", slugify("foo    bar"))
            end
        )
        it(
            "should trim leading and trailing underscores",
            function()
                assert.equals("foo_bar", slugify(" foo bar   "))
                assert.equals("foo_bar", slugify("___foo bar_"))
            end
        )
        it(
            "should replace brackets with underscores",
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
            "should replace punctuation with underscores",
            function()
                assert.equals("foo_bar", slugify("foo:bar"))
                assert.equals("foo_bar", slugify("foo;bar"))
                assert.equals("foo_bar", slugify("foo-bar"))
                assert.equals("foo_bar", slugify("foo=bar"))
                assert.equals("foo_bar", slugify("foo.bar"))
                assert.equals("foo_bar", slugify("foo,bar"))
            end
        )

    end
)
