# Function used to printing messages with indentation and optionally to stderr.
function __print
    argparse --name=__print h/help 'i/indent=?!_validate_int --min 0 --max 4' e/error -- $argv
    or return

    set lvl 0
    set str $argv[1]

    if set -ql _flag_help
        echo "Usage: __print [-i|--indent <indent>] [-e|--error] <message>"
        echo "Prints a message with indentation."
        echo ""
        echo "Options:"
        echo "  -i, --indent <indent>  The indentation level (0-4)."
        echo "  -e, --error            Print to stderr."
        echo "  -h, --help             Show this help message."
        echo ""
        echo "Arguments:"
        echo "  <message>              The message to print."
        echo ""
        echo "Examples:"
        echo "  __print 'Hello, world!'"
        echo "  __print -i 1 'Hello, world!'"
        echo "  __print -e 'Hello, world!'"
        echo "  __print -i 2 -e 'Hello, world!'"
        echo ""
        echo "Author: Nadir Fejzic <nadirfejzo@gmail.com>"
        return
    end

    if set -ql _flag_indent
        set indent $argv[1]
        set str $argv[2]
        set lvl (math "4 * $indent")
    end

    set indent (string repeat -n $lvl " ")

    if set -ql _flag_error
        echo -e "$(echo $indent)$str" >&2
    else
        echo -e "$(echo $indent)$str"
    end
end

function log
    argparse "l/level=" -- $argv
    or return

    set -l color yellow
    set -l lvl INFO

    if set -ql _flag_level
        set -l arg_lvl (echo $_flag_level | tr '[:upper:]' '[:lower:]')

        switch "$arg_lvl"
            case info
                set color cyan
                set lvl INFO
            case warn
                set color yellow
                set lvl WARN
            case error
                set color red
                set lvl ERROR
            case debug
                set color blue
                set lvl DEBUG
            case "*"
                log --level=error -- "Log level can be one of 'info|debug|warn|error'."
        end
    end

    if test "$lvl" = error
        set_color $color
        echo -n $lvl >&2
        set_color normal
        echo ": $argv" >&2
    else
        set_color $color
        echo -n $lvl
        set_color normal
        echo ": $argv"
    end
end

# This function is used interactively
# @fish-lsp-disable-next-line 4004
function remove_from_path
    set -l value $argv[1]
    echo "Trying to remove $value from PATH, fish_user_path"

    if set -l index (contains -i $value $PATH)
        echo "Removing \$PATH[$index] = $value"
        set -e PATH[$index]
    end

    if set -l index (contains -i $value $fish_user_paths)
        echo "Removing \$fish_user_paths[$index] = $value"
        set -e fish_user_paths[$index]
    end
end

if type -q tmux
    # This function is used by tmux to set the title of the pane
    # @fish-lsp-disable-next-line 4004
    function tmux_pane_title -a current_command -a current_dir
        set max_width 11
        set dir (basename $current_dir)

        # we assume both current_command and current_dir are always available!
        # we have command + () + dir, must fit in max_width
        set occupied_len (math "$(string length $current_command) + 2")
        set space_for_dir (math "$max_width - $occupied_len")

        set dir (string shorten -c . -m $space_for_dir $dir)

        echo "$current_command($dir)"
    end
end
