#!/usr/bin/env fish

set -l current_dir "$PWD"

set -l git_branch ""
git branch &>/dev/null; and set git_branch "$(git branch --show-current)"

set -l note_name "$(string replace -ra '[/.]' '_' $current_dir)"

if test (string length git_branch) -gt 0
    set note_name (echo "$note_name"_"$(string replace -ra '[/.]' '_' $git_branch)")
end

set note_name (echo "$note_name"".md")

nvim ~/Documents/notes/project/$note_name
