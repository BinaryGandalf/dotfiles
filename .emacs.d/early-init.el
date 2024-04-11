(when (boundp 'native-comp-eln-load-path)
  (startup-redirect-eln-cache (locate-user-emacs-file "var/eln-cache/")))

(with-eval-after-load 'package
  (setq package-user-dir (locate-user-emacs-file "var/elpa/")
    package-gnupghome-dir (locate-user-emacs-file "var/elpa/gnupg/"))
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents t)))

(with-eval-after-load 'use-package-core
  (require 'use-package)
  (setq use-package-always-ensure t))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(fringe-mode 0)
(tooltip-mode 0)

(let ((font "Iosevka-11.5"))
  (set-face-attribute 'default nil :font font)
  (add-to-list 'default-frame-alist `(font . ,font)))

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(setq display-line-numbers-type 'relative
  display-line-numbers-width-start t)

(load-theme 'zenburn t)
