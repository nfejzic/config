; (require 'package)
;; Any add to list for package-archives (to add marmalade or melpa) goes here
; (add-to-list 'package-archives 
;     '("MELPA" .
;       "http://melpa.org/packages/"))
; (package-initialize)

; load package files
(setq load-prefer-newer t)
(load-file (concat user-emacs-directory "package_management.el"))

(setq custom-file (expand-file-name "opts.el" user-emacs-directory))
(add-hook 'elpaca-after-init-hook (lambda () (load custom-file 'noerror)))

(setq inhibit-splash-screen t)
(global-display-line-numbers-mode t)
(display-line-numbers-mode 'relative)

(set-frame-font "MonoLisa")
(set-face-attribute 'default nil :height 220)
(tool-bar-mode 0)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(toggle-truncate-lines 1)
					; handle backups meaningfully
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )

