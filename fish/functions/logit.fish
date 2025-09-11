function logit
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
