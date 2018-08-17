;;; emacs.el --- My emacs initialization script.

;;; Commentary:
;;
;; This is my emacs customization script, intendeted to replace ~/.emacs.
;; The script has customization for the following languages:
;;   * C/C++
;;   * Python
;;   * HTML

;;; Installation:
;;
;; On Windows, set HOME environment variable to %USERPROFILE%\Dropbox.
;; There should be a .emacs and .emacs.d/ in that location.
;;
;; On Linux, point .emacs to emacs.el: (load "~/Dropbox/notes/emacs/emacs.el")

;;; Code:

;; add directory where private emacs scripts are stored
(add-to-list 'load-path "~/.emacs.d/lisp")

;; my custom fonts and colors
;; Note: default-frame-alist allows settings to be applied to new frames created
;;       with make-frame' (C-x 5 2)
(set-background-color "black")
(add-to-list 'default-frame-alist '(background-color . "black"))
(setq default-frame-alist
      (append default-frame-alist
              '(
                (foreground-color . "green")
                (background-color . "black")
                (cursor-color . "magenta")

                ;; my favorite programming font so far
                ;; more monospace fonts under notes/emacs/fonts
                ;; change frame font with set-frame-font'
                ;; list all font by eval-expression' (C-x C-e) the following
                ;;   (print (font-family-list))
                (font . "Ubuntu Mono-12"))))

;; my custom window behavoir
(scroll-bar-mode -1) ;; remove scroll bar
;;(horizontal-scroll-bar-mode -1) ;; remove scroll bar
(menu-bar-mode -1) ;; remove menu bar
(tool-bar-mode -1) ;; remove tool bar
(show-paren-mode t) ;; highlight matching parens
(global-font-lock-mode t) ;; always show font highlight
(setq-default line-number-mode t) ;; show line number in status bar
(setq-default column-number-mode t) ;; show column number in status bar
(setq-default transient-mark-mode t) ;; visual feedback on selections
(set-fringe-mode '(10 . 0)) ;; have narrow fringe on the left side of each window
(setq visible-bell nil) ;; turn beep off

;; my custom emacs behavior
(setq-default buffer-file-coding-system 'utf-8-unix) ;; always produce new files in unix format
(setq require-final-newline t) ;; always end a file with a newline
(setq-default indent-tabs-mode nil) ;; tabs are bad in generall
(setq next-line-add-newlines nil) ;; stop at the end of the file, not just add lines
(setq-default standard-indent 4) ;; standard indentation is 4 characters
(cond (window-system (mwheel-install))) ;; enable wheelmouse support by default
(set-language-environment "latin-1") ;; set input environment to English
(setq default-input-method "latin-1-prefix") ;; can toggle-input-method' (C-\)
(setq-default fill-column 99) ;; I have really wide screens :-)

;; initialize emacs package manager, which is available in emacs v2.4 and later
(require 'package)
(package-initialize)
(elpy-enable)

;; split frame into 9 windows
(defun split-window-9x100 ()
  "Split the frame into 9 side-by-side sub-windows of ~100 columns."
  (interactive)
  (defun split-window-9x100-helper (w)
    "Helper function to split a given window into 9 sub-windows."
    (split-window (split-window (split-window (split-window (split-window (split-window (split-window (split-window (split-window w 106 t) 107 t) 107 t) 106 t) 107 t) 107 t) 106 t) 107 t) 107 t))
  (split-window-9x100-helper nil))

;; split frame into 6 windows
(defun split-window-6x100 ()
  "Split the frame into 6 side-by-side sub-windows of ~100 columns."
  (interactive)
  (defun split-window-6x100-helper (w)
    "Helper function to split a given window into 6 sub-windows."
    (split-window (split-window (split-window (split-window (split-window (split-window w 120 t) 120 t) 120 t) 120 t) 120 t) 120 t))
  (split-window-6x100-helper nil))

;; split frame into 3 windows of ~100 columns
(defun split-window-3x100 ()
  (interactive)
  (defun split-window-3x100-helper (w)
    (split-window (split-window w 107 t) 107 t))
  (split-window-3x100-helper nil))

;; split frame into 3 windows of ~88 columns
(defun split-window-3x88 ()
  (interactive)
  (defun split-window-3x88-helper (w)
    (split-window (split-window w 91 t) 91 t))
  (split-window-3x88-helper nil))

;; move window back to the previous buffer
(defun back() (interactive)
       (let ((buff (car (buffer-list))))
         (message "Previous buffer: %s" buff)
         (switch-to-buffer (other-buffer buff))))

;; https://www.gnu.org/software/emacs/manual/html_node/ccmode/Sample-Init-File.html
;; my coding style
(load "cc-mode" t t)
(defconst my-c-style
  '((c-basic-offset . 4)
    (comment-column . 40)
    (comment-start . "///< ")
    (comment-end . "")
    (fill-column . 99)
    (c-hungry-delete-key . t)
    (c-comment-only-line-offset . (0 . 0))
    (c-hanging-comment-ender-p . nil)
    (c-indent-comments-syntactically-p . nil)
    (c-cleanup-list . (brace-else-brace
                       brace-elseif-brace
                       brace-catch-brace
                       empty-defun-braces
                       defun-close-semi
                       list-close-comma
                       comment-close-slash
                       scope-operator))
    (c-offsets-alist . ((statement-block-intro . +)
                        (knr-argdecl-intro . 4)
                        (substatement-open . +)
                        (label . 0)
                        (statement-case-open . +)
                        (statement-cont . 4)
                        (arglist-intro . c-lineup-arglist-intro-after-paren)
                        (arglist-close . c-lineup-arglist)))
    )
  "My Coding Style")
(c-add-style "PERSONAL" my-c-style)

;; Customizations for all modes in CC Mode.
(defun my-c-mode-common-hook ()
  (c-set-style "PERSONAL") ;; set my personal style for the current buffer
  ;; other customizations
  (setq tab-width 8
        indent-tabs-mode nil ;; this will make sure spaces are used instead of tabs
        show-trailing-whitespace t ;; mark end of line useless white spaces
        indicate-empty-lines t) ;; mark empty lines at end of file
  (add-hook 'before-save-hook 'delete-trailing-whitespace nil t))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; turn on subword mode to skip CamelCaseWords
(add-hook 'c-initialization-hook (lambda() (subword-mode 1)))
;;(add-hook 'c-mode-common-hook (lambda() (subword-mode 1)))
(add-hook 'clojure-mode-hook (lambda() (subword-mode 1)))
(add-hook 'clojure-mode-hook (lambda () (set-fill-column 99)))

;; auto-indent <RET>
(add-hook 'c-initialization-hook
          (lambda() (define-key c-mode-base-map "\C-m" 'c-context-line-break)))

;; add Windows specific initialization
(if (eq system-type 'windows-nt) (load "~/Dropbox/notes/emacs/windows.el"))

;; enable spell checking
;; (require 'rw-ispell)
;; (require 'rw-hunspell)
;; (setq rw-hunspell-use-rw-ispell t)
;; (setq ispell-program-name "hunspell")
(require 'flyspell)
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(autoload 'flyspell-delay-command "flyspell" "Delay on command." t)
(autoload 'tex-mode-flyspell-verify "flyspell" "" t)
(add-hook 'text-mode-hook (lambda() (flyspell-mode 1)))
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; my life is organized by emacs
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-startup-indented t) ;; use clean indentation for org files
(setq org-startup-truncated nil) ;; wrap long lines
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s!)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
(setq org-todo-keyword-faces
      '(("TODO" . "red")
        ("STARTED" . "yellow")
        ("WAITING" . "dark red")
        ("DONE" . "blue")
        ("CANCELED" . "purple")))
(require 'ob-lisp) ;; allow execution of emacs lisp code
(require 'ob-org) ;; allow execution of org code
(require 'ob-sh) ;; allow execution of shell scripts

 ;; cscope is currently only available on linux
(require 'xcscope)

;; auto generate paired paren, quotes, etc across all buffers
(electric-pair-mode 1)

;; support yml files
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
        (lambda ()
            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;;(require 'magit) ;; git integration
;;(require 'yasnippet)
;;(require 'flycheck)
;;(global-flycheck-mode t)

;; code auto completion
;; (require 'auto-complete)
;; (setq
;;  ac-auto-start 2
;;  ac-override-local-map nil
;;  ac-use-menu-map t
;;  ac-candidate-limit 20)

;; Python mode settings
;; (require 'python-mode)
;; (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
;; (setq py-electric-colon-active t)
;; (add-hook 'python-mode-hook 'autopair-mode)
;; (add-hook 'python-mode-hook 'yas-minor-mode)
;; (add-hook 'python-mode-hook 'auto-complete-mode)
;; (add-hook 'python-mode-hook 'flyspell-prog-mode)
;; (require 'jedi)
;; (add-hook 'python-mode-hook
;; 	  (lambda ()
;; 	    (jedi:setup)
;; 	    (jedi:ac-setup)
;;             (local-set-key "\C-cd" 'jedi:show-doc)
;;             (local-set-key (kbd "M-SPC") 'jedi:complete)
;;             (local-set-key (kbd "M-.") 'jedi:goto-definition)
;;             (modify-syntax-entry ?_ "_")
;;             (setq py-docstring-fill-column 90
;;                   py-comment-fill-column 90)
;;             (subword-mode 1)
;;             (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)))

;; turn on color in compile mode
(require 'ansi-color)
(add-hook 'compilation-filter-hook
          (lambda()
            (toggle-read-only)
            (ansi-color-apply-on-region (point-min) (point-max))
            (toggle-read-only)))

;; Open html/xml files in nxml mode
(add-to-list 'auto-mode-alist
             (cons (concat "\\." (regexp-opt '("xml" "xsd" "sch" "rng" "xslt" "svg" "rss") t) "\\'")
                   'nxml-mode))
(unify-8859-on-decoding-mode)
(setq magic-mode-alist
      (cons '("<\\?xml " . nxml-mode)
            magic-mode-alist))
(fset 'xml-mode 'nxml-mode)
(fset 'html-mode 'nxml-mode)

;; nXML mode formatting rules
(add-hook 'nxml-mode-hook
          '(lambda() (setq indent-tabs-mode nil
                           tab-width 80)))

(ido-mode t)

;; org mode auto encryption
(require 'epa-file)
(epa-file-enable)

;; Dockerfile mode
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;; my shortcuts
(global-set-key "\C-cl" 'org-store-link) ;; 
(global-set-key "\C-ca" 'org-agenda) ;; 
(global-set-key "\C-cf" 'toggle-frame-fullscreen) ;; toggle full-screen mode
(global-set-key [delete] 'delete-char) ;; delete key deletes to the right
(global-set-key [kp-delete] 'delete-char) ;; delete key deletes to the right
(global-set-key "\C-x9" 'split-window-9x100) ;; split frame into 9 windows
(global-set-key "\C-x7" 'split-window-6x100) ;; split frame into 6 windows
(global-set-key "\C-c7" 'split-window-3x100) ;; split frame into 3 windows
(global-set-key "\C-c8" 'split-window-3x88) ;; split frame into 3 windows or 88 columns
(global-set-key [C-tab] 'back) ;; toggle window buffer
(global-set-key "\C-cg" 'goto-line) ;; go to specific line
(global-set-key "\C-cc" 'compile) ;; run compile command
(global-set-key "\C-cu" ;; remove ^M characters from file
                (lambda()(interactive) (set-buffer-file-coding-system 'utf-8-unix)))
(global-set-key "\C-c1" ;; font size 1
                (lambda()(interactive) (set-frame-font "Ubuntu Mono-10")))
(global-set-key "\C-c2" ;; font size 2
                (lambda()(interactive) (set-frame-font "Ubuntu Mono-11")))
(global-set-key "\C-c3" ;; font size 3
                (lambda()(interactive) (set-frame-font "Ubuntu Mono-12")))
(global-set-key "\C-c4" ;; font size 4
                (lambda()(interactive) (set-frame-font "Ubuntu Mono-16")))
(global-set-key "\M-\\" 'next-multiframe-window) ;; switch to next window
(global-set-key "\M-]" 'previous-multiframe-window) ;; switch to previous window


(setq auto-mode-alist (nconc '(
			       ("\\.conf$" . conf-mode)
			       ("\\.c$" . c-mode)
			       ("\\.cc$" . c++-mode)
			       ("\\.h$" . c++-mode)
			       ("\\.cpp$" . c++-mode)
			       ("\\.idl$" . c++-mode)
			       ("\\.y$" . yacc-mode)
			      ) auto-mode-alist))

(provide 'emacs)
;;; emacs.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((docker-image-name . "appcious/mysql:base")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
