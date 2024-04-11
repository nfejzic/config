# Useful Snippets specific for `macos`

## Hold key for accents

macos has the feature where it offers a accents menu when holding down a key.
This can be enabled and disabled globally, but also per app:

```fish
# set disabled for webstorm
defaults write com.jetbrains.WebStorm ApplePressAndHoldEnabled -bool false

# set enabled globally
defaults write -g ApplePressAndHoldEnabled -bool true

# or delete the global value
defaults delete -g ApplePressAndHoldEnabled
```
