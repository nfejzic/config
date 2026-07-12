#!/usr/bin/env fish

set -g temp_file (mktemp)

function _task_cleanup --on-event fish_exit --on-signal INT --on-signal TERM
    test -n "$temp_file"; and rm -f $temp_file
end

echo "# This is a file for bulk task creation. Lines starting with '#' will be ignored" >>$temp_file
echo "# Each line will be interpreted as a 'add' command" >>$temp_file
echo "# Lines starting with '@' denote a project, and following lines will" >>$temp_file
echo "# be treated as tasks that belong to that project - until next project" >>$temp_file
echo "# annotation or end of file." >>$temp_file
echo "" >>$temp_file
echo -e "# Example:\n" >>$temp_file
echo "# read book X due:sat project:general" >>$temp_file
echo "#" >>$temp_file
echo "# @docs" >>$temp_file
echo "# write the first draft due:wed" >>$temp_file
echo -e "# send the draft for review due:thu\n" >>$temp_file

set -l editor "$VISUAL"

if test -z "$editor"
    set editor "$EDITOR"
end

if test -z "$editor"
    set editor nvim
end

set -l editor_flags

# make sure we're at the bottom of the file
if string match -q "*nvim*" $editor
    set editor_flags '+$' -c 'autocmd QuitPre <buffer> setlocal nomodified' -c startinsert
end

command $editor $temp_file $editor_flags

set -l project ""
while read -l line

    if test -z "$line"
        continue
    end

    # skip comments
    if string match -q -r "^#" $line
        continue
    end

    # figure out project name
    if string match -q -r "^@" $line
        set -l match (string match -r '^@.*\w' -n $line | string split " ")
        set -l sub_start (math "$match[1] + 1")
        set -l sub_end (math "$sub_start + $match[2]")
        set project (string sub -s $sub_start -e $sub_end $line)
        set project "project:$project"
        continue
    end

    set -l to_execute task add $project $line
    command $to_execute
end <$temp_file

printf '\n✓ added\n'
sleep 0.5

tmux refresh-client -S
