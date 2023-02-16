# field-notes.nvim 0.1.0
A simple zettelkasten journal plugin for Neovim

## Setup

To install and configure (default shown) with `packer`:
```lua
{
    "BlakeJC94/field-notes.nvim",
    config = function()
        require("field_notes").setup({
            -- Root directory of all the notes and journal entries
            field_notes_path = vim.fn.expand('~/field-notes'),
            -- Names of rot subdirectories where notes and journal are located
            notes_dir = 'notes',
            journal_dir = 'journal',
            -- Names of journal subdirectories
            journal_subdirs = {
                day = 'daily',
                week = 'weekly',
                month = 'monthly',
            },
            -- Format that's passed into the `date` command (see `$ man date` for details)
            journal_date_title_formats = {
                day = "%Y-%m-%d: %a",
                week = "%Y-W%W",
                month =  "%Y-M%m: %b",
            },
            -- File extension for all files
            file_extension = 'md',
        })
    end,
}
```

After calling `setup()`, the `:Note` and `:Journal` commands are added to Neovim.
- Opens a new buffer in the current window for the note
    - Filename is automatically slugified from title (lowercased and underscored)
    - Changes buffer Neovim directory to `field_notes_path`

`:Note [title of note]` usage:
- Opens a new buffer in the current window for the note
    - Filename is automatically slugified from title (lowercased and underscored)
    - Opened in `field_notes_path/notes_dir`
    - Changes buffer Neovim directory to `field_notes_path`
- If `[title of note]` not given,
    - Title of the note are inferred from current Neovim directory
        - If currently opened in a git project, title will be `# <repo name>: <branch name>`
        - Otherwise inferred title will be `# <parent dir>: <current dir>`
- Otherwise, title will be `# <user input to :Note command>`

`:Journal <timescale> [step]` usage:
- `<timescale>` is one of `day`, `week`, `month`
- Title of note is created from `journal_date_title_formats`
- An integer `step` can be passed to step forward to future notes or back into past notes

NOTE: This plugin is primarily developed on Linux, and relies heavily on the `date` command. This is
not assumed to work for Windows, and there may be some unusual quirks on Mac OS. If there are any
issues, feel free to open an issue or a PR.

## Features
- [X] Configurable field-notes root location and directory names
- [X] Configurable date formats for filenames
- [X] Simple command `Note` to create new notes and jump to existing notes
- [X] Simple command `Journal` to create new journal entries and traverse existing entries

### Planned features
- [ ] Optional mappings to traverse up/down timescales, and left/right through past and future
- [ ] Create and jump pages with `[[wiki_style]]` links
- [ ] User-configurable templates
- [ ] Shortcut commands
- [ ] Autocomplete for commands
- (Feel free to add suggestions via Github issues or a PR)


## Motivation
There are many many plugins for note taking in Neovim. Why am I writing another one?

- I'd like to practice a bit more Lua programming
- I want to learn more about testing frameworks in other languages
- I want to learn more about Neovim plugin structure in general
- I want to automate and sync my handwritten note-taking methods within my editor
    - Less context switching when coding

This is a admittedly a very opinionated structure, and probably wont be for everyone. However, if
you find it useful, leaving a star is always appreciated.

### Journal structure
Generally I structure my notes in the following manner:
```
~/field-notes
├── journal
│   ├── daily
│   │   ├── 2023_01_31_tue.md
│   │   ├── 2023_02_01_wed.md
│   │   ├── 2023_02_02_thu.md
│   │   ...
│   ├── monthly
│   │   ├── 2023_m02_feb.md
│   │   ├── 2023_m03_mar.md
│   │   ...
│   └── weekly
│       ├── 2023_w05.md
│       ├── 2023_w06.md
│       ...
└── notes
    ├── random_idea_i_had.md
    ├── another_random_idea_i_had.md
    ├── project_name_git_branch_1.md
    ...
    └── topic_of_interest.md
```

* Daily notes:
    * Start as blank files, usually just a To-Do list I revisit throughout the day
    * This is most useful for stand-up notes
    * I can order and prioritise things in this format, which helps me ramble less
* Weekly notes:
    * Location for mind dumps, random thoughts and ideas go here throughout the week
    * Priority items to look at during the week will go here
* Monthly notes:
    * Usually plans for the month ahead (and beyond) at a glance
* Everything else:
    * No subdirectories within the `notes` directory
        * Zettelkasten method
        * Too lazy to maintain a central `index.md`
        * I like the idea of linking files directly to each other

I used to keep my notes in a Dropbox folder, but I've recently switched to placing it on a private
git repo (mainly because I was too lazy to set up Dropbox after setting up my latest computer).
Using Git instead of Dropbox seems to be less prone to random sync issues, I prefer using a manual
syncing method for this reason alone (also I realised that automatic syncing isn't actually
essential to my workflow).

Keeping my notes structured this way keeps it platform independent, and also works on my phone Using
an app such as [GitJournal](https://gitjournal.io/) or [Zettel Notes](https://znotes.thedoc.eu.org/)

### Other recommended plugins
- [renerocksai/telekasten.nvim](https://github.com/renerocksai/telekasten.nvim)
- [ostralyan/scribe.nvim](https://github.com/ostralyan/scribe.nvim)
- [jakewvincent/mkdnflow.nvim](https://github.com/jakewvincent/mkdnflow.nvim)
- [nvim-neorg/neorg](https://github.com/nvim-neorg/neorg)

### Useful resources for development
- https://alpha2phi.medium.com/writing-neovim-plugins-a-beginner-guide-part-i-e169d5fd1a58

