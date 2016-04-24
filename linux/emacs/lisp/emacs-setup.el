;; initialize the package management subsystem
(require 'package)
(package-initialize)

;; add extra package archives besides gnu
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))

;; update package list from internet
(package-refresh-contents)

;; this function will install a package only if its not installed
(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-install package)))

(setq to-install
      '(elpy
        rw-ispell
        rw-hunspell
        xcscope
        magit
        markdown-mode
        yaml-mode))
(mapc 'install-if-needed to-install)
(elpy-enable)

;; ;; install packages
;; (setq to-install
;;       '(php-mode
;;         rw-ispell
;;         rw-hunspell
;;         xcscope
;;         markdown-mode
;;         yaml-mode
;;         magit
;;         yasnippet
;;         jedi
;;         auto-complete
;;         autopair
;;         find-file-in-repository
;;         flycheck))
;; (mapc 'install-if-needed to-install)
