if test (uname -s) = Linux
    # linuxbrew
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
    set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar"
    set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew"
    set -q PATH; or set PATH ''
    set -gx PATH "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin" $PATH
    set -q MANPATH; or set MANPATH ''
    set -gx MANPATH "/home/linuxbrew/.linuxbrew/share/man" $MANPATH
    set -q INFOPATH; or set INFOPATH ''
    set -gx INFOPATH "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH
end

if test (uname -s) = Darwin
    eval (/opt/homebrew/bin/brew shellenv)

    # multi account homebrew setup
    if test -d ~/.homebrew
        eval "$(~/.homebrew/bin/brew shellenv)"
    end

    # add gcloud stuff to path
    if test -f "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
        source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
    end
end
