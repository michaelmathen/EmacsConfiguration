;;Make sure that everything is up to date
(when (>= emacs-major-version 24)
  (require 'package)
  ;;(require 'melpa)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("elpy" . "http://jorgenschaefer.github.io/packages/"))
  (add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (defvar packages '(let-alist
		     flycheck cuda-mode jedi ggtags helm-gtags jdee
		     company-c-headers haskell-mode 
		     company helm-flycheck helm-ghc auctex 
		     company-auctex latex-preview-pane elpy
		     nlinum))

  
  ;; list the repositories containing them
  ;;
  
  (setq check-signature nil)
  ;; activate all the packages (in particular autoloads)
  (package-initialize)
  
  ;; fetch the list of packages available 
  (unless package-archive-contents
    (package-refresh-contents))

  ;;;; install the missing packages
  (dolist (package packages)
    (unless (package-installed-p package)
    (package-install package)))
  )



;;;;;;;;;;;;;;;
;;Emacs Theme;;
;;;;;;;;;;;;;;;
(defun gTheme ()
  (unwind-protect
      (set-cursor-color "white")
    ;;(load-theme 'base16-monokai-dark 1)
    )
  )

;;(if (display-graphic-p (selected-frame))
;;    (gTheme)
;; )


(tool-bar-mode -1)
(menu-bar-mode -1) 
;;Stupid fringe and scroll bar
(scroll-bar-mode -1)
(set-fringe-mode 0)
;;We don't wrap lines
(setq-default truncate-lines t)

;;;;;;;;;;;;;;
;;Some modes;;
;;;;;;;;;;;;;;

;; (require 'helm-config)
 (global-flycheck-mode)
 (global-company-mode 1)
;; (helm-mode)
;; (helm-autoresize-mode 1)
;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
;; (define-key flycheck-mode-map (kbd "C-;") 'helm-flycheck)

;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
;; (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

;; (when (executable-find "curl")
;;   (setq helm-google-suggest-use-curl-p t))

;; (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
;;       helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
;;       helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
;;       helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
;;       helm-ff-file-name-history-use-recentf t)

;;;;;;;;;;;;;;;;;;;;;;
;;Emacs Python Stuff;;
;;;;;;;;;;;;;;;;;;;;;;
(defun jedi_config ()
  
  (require 'jedi)
  (jedi:setup)
  (setq jedi:setup-keys t)
  (setq jedi:complete-on-dot t)
  (setq jedi:get-in-function-call-delay 200)
  (company-mode 0)
  )

(add-hook 'python-mode-hook 'jedi_config)

(package-initialize)
(elpy-enable)
(elpy-use-ipython)

;;;;;;;;;;;;;;;;;;;
;;Emacs c++ stuff;;
;;;;;;;;;;;;;;;;;;;
(require 'cc-mode)
;;(require 'cuda-mode)
(require 'company)
(require 'cl)

(add-hook 'after-init-hook 'global-company-mode)

(setq all-includes (list (expand-file-name "~/Dropbox/Fun/Vecky/src")
                         "/usr/local/cuda/include"))

(add-hook 'prog-mode-hook 'nlinum-mode)

(defun my-c++-config ()
  (setq flycheck-clang-include-path all-includes)
  (setq flycheck-clang-language-standard "c++11")
  (setq company-clang-arguments "-std=c++11")
  (define-key company-mode-map (kbd "C-:") 'helm-company)
  (define-key company-active-map (kbd "C-:") 'helm-company)
  (setq company-backends (delete 'company-semantic company-backends))
  (add-to-list 'company-backends 'company-c-headers)

  (ggtags-mode)
  (helm-gtags-mode)
  
  ;;Need to modify these to fit your system
  (add-to-list 'company-c-headers-path-system "/usr/local/include/c\+\+/4.9.2/")
  
  (define-key c-mode-map  (kbd "C-.") 'company-complete)
  (define-key c++-mode-map  (kbd "C-.") 'company-complete)
  )

(add-hook 'c-mode-hook 'my-c++-config)
(add-hook 'c++-mode-hook 'my-c++-config)


;;;;;;;;;;;;;;;;;;;;;;;
;;Emacs Haskell stuff;;
;;;;;;;;;;;;;;;;;;;;;;;

(require 'haskell-mode)


(add-hook 'haskell-mode-hook 'turn-on-haskell-unicode-input-method)

;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)

;;;;;;;;;;;;;;
;;Java stuff;;
;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;
;; Tramp stuff;;
;;;;;;;;;;;;;;;;

;; I compulsively backup so this is probably ok...
(setq auto-save-default nil)
(setq make-backup-files nil)
(auto-compression-mode 1)
(setq tramp-default-method "ssh")
;;(setq temporary-file-directory "/Users/mmath/.emacs.d/backups")
;;(setq backup-directory-alist
;;      `((".*" . ,temporary-file-directory)))
;;(setq auto-save-file-name-transforms
;;      `((".*" ,temporary-file-directory t)))

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Tramp shouldn't be doing anything with version control
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))


;; Do local backups with tramp
(setq tramp-backup-directory-alist temporary-file-directory)

;; Use control master with tramp
(setq tramp-ssh-controlmaster-options
               (concat
                 "-o ControlPath=/tmp/address@hidden:%%p "
                 "-o ControlMaster=auto -o ControlPersist=yes"))


(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(setq TeX-PDF-mode t)

(defun flymake-get-tex-args (file-name)
(list "pdflatex"
(list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))

(add-hook 'LaTeX-mode-hook 'flymake-mode)

(setq ispell-program-name "aspell") ; could be ispell as well, depending on your preferences
(setq ispell-dictionary "english") ; this can obviously be set to any language your spell-checking program supports

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)

(defun turn-on-outline-minor-mode ()
(outline-minor-mode 1))

(add-hook 'LaTeX-mode-hook 'turn-on-outline-minor-mode)
(add-hook 'latex-mode-hook 'turn-on-outline-minor-mode)
(setq outline-minor-mode-prefix "\C-c \C-o") ; Or something else

(latex-preview-pane-enable)

(require 'tex-site)
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make citation" nil)
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase Mode" t)
(add-hook 'latex-mode-hook 'turn-on-reftex) ; with Emacs latex mode
;; (add-hook 'reftex-load-hook 'imenu-add-menubar-index)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)

(setq LaTeX-eqnarray-label "eq"
      LaTeX-equation-label "eq"
      LaTeX-figure-label "fig"
      LaTeX-table-label "tab"
      LaTeX-myChapter-label "chap"
      TeX-auto-save t
      TeX-newline-function 'reindent-then-newline-and-indent
      TeX-parse-self t
      TeX-style-path
      '("style/" "auto/"
	"/usr/share/emacs21/site-lisp/auctex/style/"
	"/var/lib/auctex/emacs21/"
	"/usr/local/share/emacs/site-lisp/auctex/style/")
      LaTeX-section-hook
      '(LaTeX-section-heading
	LaTeX-section-title
	LaTeX-section-toc
	LaTeX-section-section
	LaTeX-section-label))
