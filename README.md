# vis-crlf

A plugin to read and write CRLF-terminated files with vis.

### Installation

Clone this repository to where you install your plugins. (If this is your first
plugin, which it probably isn't, running
`git clone --recurse-submodules https://github.com/milhnl/vis-crlf` in
`~/.config/vis/` will probably work).

Then, add `require('vis-crlf')` to your `visrc`.

### Usage

When opening a file, `vis-crlf` will look for a carriage return (CR) as the
last character on the first line. If found, the plugin will remember this and
remove all CRs at line endings from the file. When closing the file, the file
will be restored to CRLF file endings.

It'll do the same for the BOM, but won't bother if the file is LF-terminated.

In short, the file will be modified on disk to be what vis expects for the
duration of your editing sessions. This will probably change once
[352ee07](https://github.com/martanne/vis/commit/352ee0761ced17612d751bd568c888c78d279e9f)
is released to use a temporary file.

### Notes/bugs

- **I have not tested this as much as my other plugins yet. Especially because
  this runs a hook after closing, it might currently silently eat your files.**
- Changing the file on disk is not ideal.
- Editorconfig support via
  [vis-editorconfig-options](https://github.com/milhnl/vis-editorconfig-options)
  is planned.
