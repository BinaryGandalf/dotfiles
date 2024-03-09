(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-message t)

(setq scroll-step 1
  scroll-margin 15)

(require 'display-line-numbers)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(setq display-line-numbers-type 'relative
  display-line-numbers-width-start t)

(setq help-window-select t)

(let ((gandalf/font "Hack Nerd Font Mono-11"))
  (set-face-attribute 'default nil :font gandalf/font)
  (add-to-list 'default-frame-alist `(font . ,gandalf/font)))

(setq make-backup-files nil)

(setq custom-file (expand-file-name "void.el" user-emacs-directory))
(load custom-file)

(load (expand-file-name "gandalf.el" user-emacs-directory))

(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless package-archive-contents (package-refresh-contents))
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

(use-package diminish)

(use-package modus-themes
  :config
  (load-theme 'modus-vivendi-tinted :no-confirm))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (setq evil-vsplit-window-right t)
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :diminish evil-collection-unimpaired-mode
  :config
  (evil-collection-init))

(use-package which-key
  :diminish
  :init
  (setq which-key-idle-delay 1)
  :config
  (which-key-mode 1))

(use-package ivy
  :diminish
  :config
  (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  (setq ivy-initial-inputs-alist ())
  (setq enable-recursive-minibuffers t)
  (setq ivy-use-virtual-buffers t)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "C-x b") 'counsel-switch-buffer)
  (global-set-key (kbd "C-s") 'swiper)
  (ivy-mode 1))

(use-package counsel
  :after ivy
  :diminish
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-symbol] . counsel-describe-symbol)
  :config
  (counsel-mode 1))

(use-package ivy-rich
  :after counsel
  :config
  (ivy-rich-mode 1))

(use-package helpful
  :after counsel
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable))

(use-package lsp-mode
  :after which-key
  :diminish lsp-mode
  :init
  (setq lsp-keymap-prefix nil)
  :hook
  ((c-ts-mode . lsp-deferred)
    (c++-ts-mode . lsp-deferred)
    (bash-ts-mode . lsp-deferred))
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :after lsp-mode)

(use-package lsp-treemacs
  :after lsp-mode)

(use-package lsp-ivy
  :after (ivy lsp-mode))

(use-package flycheck
  :after lsp-mode
  :diminish
  :config
  (global-flycheck-mode 0))

(use-package company
  :after lsp-mode
  :diminish
  :hook (lsp-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0))

(use-package company-box
  :after company-box
  :hook (company-mode . company-box-mode))

(use-package general
  :after (evil-collection lsp-mode)
  :config
  (general-evil-setup)
  (general-nvmap
    :prefix "SPC"
    "l" lsp-command-map))

(use-package editorconfig
  :diminish
  :config
  (editorconfig-mode 1))
