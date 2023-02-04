# NeoZettel
A simple zettelkasten journal plugin for Neovim

A WIP plugin until otherwise stated.

## Motivation
- I'd like to practice a bit more Lua programming
- I want to learn more about testing frameworks in other languages
- I want to learn more abotu neovim plugin structure in general

## Journal structure
Generally I structure my notes in the following manner:
```
../journal/
├── daily
│   ├── ...
│   └── 2023-02-04.md
├── weekly
│   ├── ...
│   └── 2023_W06.md
├── monthy
│   ├── ...
│   └── 2023-02.md
├── templates
│   ├── daily.md
│   ├── monthy.md
│   ├── new_note.md
│   └── weekly.md
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
    * No subdirectories, zettelkasten method
        * Too lazy to maintain an `index.md`
        * I like the idea of linking files directly to each other

I used to keep my notes in a Dropbox folder, but I've recently switched to placing it on a private
git repo (mainly because I was too lazy to set up Dropbox after setting up my latest computer).
Using Git instead of Dropbox seems to be less prone to random sync issues, I prefer using a manual
syncing method for this reason alone (also I realised that automatic syncing isn't actually
essential to my workflow).

Keeping my notes structured this way keeps it platform independent, and also works on my phone Using
an app such as [GitJournal](https://gitjournal.io/) or [Zettel Notes](https://znotes.thedoc.eu.org/)

## Planned features
- Dynamic creation/opening of notes based on git branch or directory name
- Goto/create daily, weekly, monthy
- Link autocompletion in `[[..]]` syntax

### Other developments
- Backtracking links?

## Other recommended plugins
- [renerocksai/telekasten.nvim](https://github.com/renerocksai/telekasten.nvim)
- [ostralyan/scribe.nvim](https://github.com/ostralyan/scribe.nvim)
- [jakewvincent/mkdnflow.nvim](https://github.com/jakewvincent/mkdnflow.nvim)

## Useful resources for development

- https://alpha2phi.medium.com/writing-neovim-plugins-a-beginner-guide-part-i-e169d5fd1a58

