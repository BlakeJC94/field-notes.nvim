# field-notes.nvim 0.1.5
A simple zettelkasten journal plugin for Neovim

## Features
- [X] Configurable field-notes root location and directory names
- [X] Configurable date formats for filenames
- [X] Simple command `FieldNote` (or `F`) to create new notes and jump to existing notes
- [X] Simple command `Journal` (or `J`) to create new journal entries and traverse existing entries
- [X] Automatic note title inferred from git or directory
- [X] Autocomplete for `:Journal` commands
- [X] Optional mappings to traverse up/down timescales, and left/right through past and future
- [X] Simple command `LinkNote` (or `L`) to jump to `[[link]]` under cursor
- [X] Automatic `[[link]]` creation journal when making a new `FieldNote`

### Planned features
- [ ] Compile command to sync events across timescales
- [ ] Autocomplete for `FieldNote` commands
- [ ] User-configurable templates
- (Feel free to add suggestions via Github issues or a PR)

## Setup
To install and configure (default shown) with `packer`:
```lua
{
    "BlakeJC94/field-notes.nvim",
    config = function()
        require("field_notes").setup({
            --- Root directory of all the notes and journal entries
            field_notes_path = vim.fn.expand('~/field-notes'),
            --- Names of root subdirectories where notes and journal are located
            notes_dir = 'notes',
            journal_dir = 'journal',
            --- Names of journal subdirectories
            journal_subdirs = {
                day = 'daily',
                week = 'weekly',
                month = 'monthly',
            },
            --- Format that's passed into the `date` command (see `$ man date` for details)
            journal_date_title_formats = {
                day = "%Y-%m-%d: %a",
                week = "%Y-W%W",
                month =  "%Y-M%m: %b",
            },
            --- File extension for all files
            file_extension = 'md',
            --- Optional journal-buffer mappings for `:Journal left/down/up/right`
            -- journal_maps = {
            --     left = "<Leader><Left>",
            --     down = "<Leader><Down>",
            --     up = "<Leader><Up>",
            --     right = "<Leader><Right>",
            -- },
            --- Optional auto-linking of notes to current journal
            auto_add_links_to_journal = {
                day = false,
                week = false,
                month = false,
            },
            --- Text that matches title of link list in journals
            journal_link_anchor = "## Field notes",
        })
    end,
}
```

## Usage
After calling `setup()`, the `:FieldNote` and `:Journal` commands are added to Neovim.
- Opens a new buffer in the current window for the note
    - Filename is automatically slugified from title (lowercased and underscored)
    - Changes buffer Neovim directory to `field_notes_path`

### `:FieldNote [title] [of] [note]`
- Opens a new buffer in the current window for the note
    - Filename is automatically slugified from title (lowercased and underscored)
    - Opened in `field_notes_path/notes_dir`
    - Changes buffer Neovim directory to `field_notes_path`
- If `[title] [of] [note]` not given,
    - Title of the note are inferred from current buffer directory
        - `# <repo name>: <branch name>` if buffer is in git project
        - `# <parent dir>: <current dir>` otherwise
- Otherwise, title will be `# <user input to :Note command>`

### `:Journal <subcommand>`
- Title of note is created from `journal_date_title_formats`
- `<subcommand>` is a timescale (`day`, `week`, or `month`), or a direction (`left`, `down`, `up`,
  or `right`)
    - Timescale subcommands open the current time journal entry on the requested timescale
        - An optional integer step can be passed in `:Journal <timescale> [step]` to step forward to
          future notes or back into past notes
        - No step requested rested the step counter
    - Direction subcommands only effective in journal buffers
        - `left`/`right` to step back/forward between entries in currently viewed timescale

### `:LinkNote [note_filename]`
- Does nothing if not in a field note buffer
- Completion enabled for `note_filename`
- If called without args
    - If cursor is on top of a `[[link_note]]`, check if `link_note.md` exists in the `notes_dir` and
      jump to the note
- If called with a `note_filename`,
    - Check if the `note_filename.md` exists in `notes_dir`, insert `[[note_filename]]` at cursor
      and jump to file

NOTE: This plugin is primarily developed on Linux. This hasn't been tested on Windows or Mac OS, so
there may be some unusual quirks on Mac OS. If there are any issues, feel free to open an issue or a
PR.

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

I keep my field notes in a private git repo. Keeping my notes structured this way keeps it platform
independent, and also works on my phone Using an app such as [GitJournal](https://gitjournal.io/)
or [Zettel Notes](https://znotes.thedoc.eu.org/).

### Other recommended plugins
- [renerocksai/telekasten.nvim](https://github.com/renerocksai/telekasten.nvim)
- [JellyApple102/flote.nvim](https://github.com/JellyApple102/flote.nvim)
- [ostralyan/scribe.nvim](https://github.com/ostralyan/scribe.nvim)
- [jakewvincent/mkdnflow.nvim](https://github.com/jakewvincent/mkdnflow.nvim)
- [nvim-neorg/neorg](https://github.com/nvim-neorg/neorg)

### Useful resources for development
- https://alpha2phi.medium.com/writing-neovim-plugins-a-beginner-guide-part-i-e169d5fd1a58

