(require 'use-package)
(require 'package)
(setq use-package-always-ensure t
  package-user-dir (locate-user-emacs-file "var/elpa/")
  package-gnupghome-dir (locate-user-emacs-file "var/elpa/gnupg/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents t))

(use-package no-littering
  :init
  (setq no-littering-etc-directory user-emacs-directory))

(use-package diminish)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode 0)
(fringe-mode 0)

(setq use-dialog-box nil
  overflow-newline-into-fringe nil
  use-short-answers t
  inhibit-startup-message t
  initial-scratch-message nil
  echo-keystrokes 0
  mode-line-percent-position '(6 "%q"))

(setq-default resize-mini-windows t
  cursor-in-non-selected-windows nil)

(let ((rc-font "Iosevka-11.5"))
  (set-face-attribute 'default nil :font rc-font)
  (add-to-list 'default-frame-alist `(font . ,rc-font)))

(defun rc-after-init ()
  (if (daemonp)
    (setq initial-buffer-choice default-directory))
    (unless (buffer-file-name)
      (find-file default-directory))
  (load-theme 'zenburn t))

(add-hook 'after-init-hook 'rc-after-init)

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(setq display-line-numbers-type 'relative
  display-line-numbers-width-start t)

(savehist-mode 1)
(recentf-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)

(setq enable-recursive-minibuffers t
  isearch-repeat-on-direction-change t
  global-auto-revert-non-file-buffers t
  auto-revert-remote-files t)

(setq make-backup-files nil
  create-lockfiles nil
  custom-file (locate-user-emacs-file "var/void.el"))

(setq completion-ignore-case t
  read-file-name-completion-ignore-case t
  read-buffer-completion-ignore-case t)

(use-package orderless
  :config
  (add-to-list 'completion-styles 'orderless))

(use-package marginalia
  :diminish
  :config
  (marginalia-mode 1))

(use-package vertico
  :config
  (vertico-mode 1))

(with-eval-after-load 'dired
  (setq dired-listing-switches "-lah"
    dired-free-space 'separate
    dired-recursive-deletes 'always
    dired-kill-when-opening-new-dired-buffer t
    dired-auto-revert-buffer t
    auth-source-save-behavior nil))

(setq compile-command ""
  compilation-ask-about-save nil
  compilation-scroll-output 'first-error
  find-ls-option '("-exec ls -ldh {} +" . "-ldh"))

(global-set-key (kbd "C-c b c") 'compile)
(global-set-key (kbd "C-c k c") 'kill-compilation)

(defun rc--read-command (prompt history &optional directory)
  (let ((default-directory (if directory directory default-directory)))
    (save-some-buffers t)
    (read-shell-command prompt (car (symbol-value history)) `(,history . 1))))

(defun rc--project-root ()
  (require 'project)
  (project-root (project-current t)))

(defun rc-find-buffer-close ()
  (interactive)
  (if (one-window-p) (quit-window) (delete-window)))

(defun rc--find (directory find-expr)
  (split-window-right)
  (other-window 1)
  (find-dired-with-command directory (concat find-expr " " (car find-ls-option)))
  (with-current-buffer "*Find*"
    (use-local-map (copy-keymap dired-mode-map))
    (local-set-key [remap quit-window] 'rc-find-buffer-close)
    (local-set-key [remap dired-find-file] 'dired-find-file-other-window)))

(defun rc-find (find-expr)
  (interactive
    (list (rc--read-command "Find command: " 'find-command-history)))
  (rc--find default-directory find-expr))

(global-set-key (kbd "C-x p C-c") 'rc-project-find)
(global-set-key (kbd "C-c b f") 'rc-find)
(global-set-key (kbd "C-c k f") 'kill-find)

(defun rc-project-find ()
  (interactive)
  (let* ((directory (rc--project-root))
          (find-expr (rc--read-command "Find command: " 'find-command-history directory)))
    (rc--find directory find-expr)))

(defun rc-grep (grep-expr)
  (interactive
    (list (rc--read-command "Grep command: " 'grep-history)))
  (grep grep-expr))

(defun rc-project-grep ()
  (interactive)
  (let* ((directory (rc--project-root))
         (grep-expr (rc--read-command "Grep command: " 'grep-history directory)))
    (let ((default-directory directory))
      (grep grep-expr))))

(global-set-key (kbd "C-c b g") 'rc-grep)
(global-set-key (kbd "C-x p C") 'rc-project-grep)
(global-set-key (kbd "C-c k g") 'kill-grep)

(use-package wgrep
  :config
  (setq wgrep-auto-save-buffer t))

(use-package magit)

(global-set-key (kbd "C-x C-S-f") 'recentf)
(global-set-key (kbd "C-S-y") 'yank-from-kill-ring)
(global-set-key (kbd "C-c M-s") 'tramp-revert-buffer-with-sudo)
(global-set-key (kbd "C-h M") 'man)

(use-package corfu
  :config
  (setq corfu-cycle t)
  (global-corfu-mode 1))

(setq xref-auto-jump-to-first-xref t
  xref-auto-jump-to-first-definition t)

(global-set-key (kbd "C-c l s") 'eglot)
(with-eval-after-load 'eglot
  (setq eglot-ignored-server-capabilities '(:documentHighlightProvider
                                         :inlayHintProvider))
  (define-key eglot-mode-map (kbd "C-c l S") 'eglot-shutdown)
  (define-key eglot-mode-map (kbd "C-c l d") 'eglot-find-declaration)
  (define-key eglot-mode-map (kbd "C-c l t") 'eglot-find-typeDefinition)
  (define-key eglot-mode-map (kbd "C-c l i") 'eglot-find-implementation)
  (define-key eglot-mode-map (kbd "C-c l r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c l f") 'eglot-format)
  (define-key eglot-mode-map (kbd "C-c l a") 'eglot-code-actions))

(use-package editorconfig
  :diminish
  :config
  (editorconfig-mode 1))
