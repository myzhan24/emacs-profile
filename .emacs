
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



;; keybinds

(global-set-key (kbd "C-x v") 'clipboard-yank) ;normal paste
(global-set-key (kbd "C-x c") 'compile) ; Ctrl+x + c
(global-set-key (kbd "C-x n") 'linum-mode) ; enable line numbers

;;load paths
(add-to-list 'load-path "~/.emacs.d/cygwin") ;cygwin loads
(add-to-list 'load-path "~/.emacs.d/custom") ;custom .el files

;;installation for cygwin-mount.el
(require 'cygwin-mount)
(cygwin-mount-activate)

;;installation for setup-cygwin.el
(require 'setup-cygwin)

;;intstallation for autopair
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


;;enable C-x C-u and C-x C-l to upper and lowercase selections
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;change default compile-command to g++
(setq compile-command "g++ ")
