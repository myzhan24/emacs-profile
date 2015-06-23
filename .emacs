;; automatically install required packages
;;; Required packages
;;; everytime emacs starts, it will automatically check if those packages are
;;; missing, it will install them automatically
;; (when (not package-archive-contents)
;;   (package-refresh-contents))
;; (defvar tmtxt/packages
;;   '(package1 package2 package3 package4 package5))
;; (dolist (p tmtxt/packages)
;;   (when (not (package-installed-p p))
;;     (package-install p)))

;; keybinds
(global-set-key (kbd "C-x v") 'clipboard-yank) ;normal paste
(global-set-key (kbd "C-x c") 'compile) ;; Ctrl+x + c
(global-set-key (kbd "C-x n") 'linum-mode) ;; enable line numbers
;(global-set-key (kbd "C-x C-;") 'comment-or-uncomment-region)
;;(global-set-key (kbd "C-x C=") 'uncomment-region)


;;
;;ECB
;;
;; https://truongtx.me/2013/03/10/ecb-emacs-code-browser/c
;;
;;Emacs Package Manager
;;; Emacs is not a package manager, and here we load its package manager!
;; (require 'package)
;; (dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
;;                   ("elpa" . "http://tromey.com/elpa/")
;;                   ;; TODO: Maybe, use this after emacs24 is released
;;                   ;; (development versions of packages)
;;                   ("melpa" . "http://melpa.milkbox.net/packages/")
;;                   ))
;;   (add-to-list 'package-archives source t))
;; (package-initialize)

;; ;; activate ecb
;; (require 'ecb)
;; (require 'ecb-autoloads)

;; ;;basic ecb configurations
;; (setq ecb-layout-name "layout-name")

;; ;; show source files in directories buffer
;; (setq ecb-show-sources-in-directories-buffer 'always)

;; ;; persistent compile window
;; (setq ecb-compile-window-height 12)

;; ;; ECB Keybinds
;; ;;; activate and deactivate ecb
;; (global-set-key (kbd "C-x C-;") 'ecb-activate)
;; (global-set-key (kbd "C-x C-'") 'ecb-deactivate)
;; ;;; show/hide ecb window
;; (global-set-key (kbd "C-;") 'ecb-show-ecb-windows)
;; (global-set-key (kbd "C-'") 'ecb-hide-ecb-windows)
;; ;;; quick navigation between ecb windows
;; (global-set-key (kbd "C-)") 'ecb-goto-window-edit1)
;; (global-set-key (kbd "C-!") 'ecb-goto-window-directories)
;; (global-set-key (kbd "C-@") 'ecb-goto-window-sources)
;; (global-set-key (kbd "C-#") 'ecb-goto-window-methods)
;; (global-set-key (kbd "C-$") 'ecb-goto-window-compilation)



;;load paths
(add-to-list 'load-path "~/.emacs.d/cygwin") 
(add-to-list 'load-path "~/.emacs.d/custom")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;;load Custom Theme
(load-theme 'monokai t)

;;installation for cygwin-mount.el
(require 'cygwin-mount)
(cygwin-mount-activate)

;;installation for setup-cygwin.el
(require 'setup-cygwin)

;;intstallation for air
;;http://www.emacswiki.org/emacs/AutoPairs
(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers

;;auto-complete.el
;;http://www.emacswiki.org/emacs/auto-complete.el
(require 'auto-complete)
(global-auto-complete-mode t)

;;Installation for auto complete extension
;;http://emacswiki.org/emacs/auto-complete-extension.el
(require 'auto-complete-extension)


;;Rainbow delimiters
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode);

;;enable C-x C-u and C-x C-l to upper and lowercase selections
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;change default compile-command to g++
(setq compile-command "g++ ")

;;automatic indentation
;;(add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))

;;code beautifying
;;http://www.emacswiki.org/emacs/CodeBeautifying
(defun dka-fix-comments ()
  "Move through the entire buffer searching for comments that begin with
    \"//\" and fill them appropriately.  That means if comments start too
    close to the end of line (20 less than the fill-column) move the
    entire comment on a line by itself."
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (while (search-forward "//")
      (lisp-indent-for-comment)
      ;; when the comment is deemed to be too close to the end of the
      ;; line, yank it and put it on the previous line before filling
      (while (< (- fill-column 20) (- (current-column) 3))
	(search-backward "//")
	(kill-line)
	(beginning-of-line)
	(yank)
	(insert "\n"))
      ;; now fill the lines that are too long
      (if (and (not (end-of-line))
	       (< fill-column (current-column)))
	  (c-fill-paragraph)))))

;;custom compile command
;;emacswiki.org/emacs/CompileCommand
(require 'compile)
 (add-hook 'c-mode-hook
           (lambda ()
	     (unless (file-exists-p "Makefile")
	       (set (make-local-variable 'compile-command)
                    ;; emulate make's .c.o implicit pattern rule, but with
                    ;; different defaults for the CC, CPPFLAGS, and CFLAGS
                    ;; variables:
                    ;; $(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $<
		    (let ((file (file-name-nondirectory buffer-file-name)))
                      (format "%s -c -o %s.o %s %s %s"
                              (or (getenv "CC") "gcc")
                              (file-name-sans-extension file)
                              (or (getenv "CPPFLAGS") "-DDEBUG=9")
                              (or (getenv "CFLAGS") "-ansi
			      -pedantic -Wall -g") file))))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("27821e324592a0f6348fe64f3c8f40846cbf81625673f6eab912e07f8aebc047" "26f0aa041825d6a1e934f1274be62a02a753ecfa0d1caec0057f261c34301ff8" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
