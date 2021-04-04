;;; Early Init
;;;; Speed
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
	  gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
  (lambda ()
	(setq gc-cons-threshold 16777216 ; 16mb
		  gc-cons-percentage 0.1)))

(defun doom-defer-garbage-collection-h ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun doom-restore-garbage-collection-h ()
  ;; Defer it so that commands launched immediately after will enjoy the
  ;; benefits.
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold 16777216))))

(add-hook 'minibuffer-setup-hook #'doom-defer-garbage-collection-h)
(add-hook 'minibuffer-exit-hook #'doom-restore-garbage-collection-h)

(use-package gcmh
  :init
  (setq gcmh-idle-delay 5
		gcmh-high-cons-threshold (* 16 1024 1024) ))

(setq package-enable-at-startup nil ; don't auto-initialize!
	  ;; don't add that `custom-set-variables' block to my init.el!
	  package--init-file-ensured t)

(setq frame-inhibit-implied-resize t)
(setq initial-major-mode 'fundamental-mode)

;;;; Packages and Elisp
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'package)
(setq package-archives '(("ELPA" . "https://tromey.com/elpa/")
						 ("gnu" . "https://elpa.gnu.org/packages/")
						 ("melpa" . "https://melpa.org/packages/")))
(defvar bootstrap-version)
(let ((bootstrap-file
	   (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
	  (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
	(with-current-buffer
		(url-retrieve-synchronously
		 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
		 'silent 'inhibit-cookies)
	  (goto-char (point-max))
	  (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq url-http-attempt-keepalives nil)
(setq package-check-signature nil)
(setq use-package-always-ensure t)
(setq use-package-always-defer t)

;;;; native-comp
(setq package-native-compile t)
(setq comp-deferred-compilation t)
;; (native-compile-async "~/.emacs.d/elpa" 'recursively)

;;;; EXWM
(require 'exwm)
(require 'exwm-config)
(exwm-config-example)
(require 'exwm-randr)
(setq exwm-randr-workspace-output-plist '(0 "DP-5" 1 "HDMI-0"))
(add-hook 'exwm-randr-screen-change-hook
	  (lambda ()
		(start-process-shell-command
		 "xrandr" nil "xrandr --output DP-5 --o~utput HDMI-0 --auto")))
(exwm-randr-enable)

;;;; General
(use-package general)



;;; Themeage
;;;; Magic Icon Fix
(defun magic-icon-fix ()
  (let ((fontset (face-attribute 'default :fontset)))
	(set-fontset-font fontset '(?\xf000 . ?\xf2ff) "FontAwesome" nil 'append)))

(add-hook 'org-mode-hook 'magic-icon-fix)
;;;; Doom
(use-package doom-themes
	:init
	;; Global settings (defaults)
	(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
		  doom-themes-enable-italic t) ; if nil, italics is universally disabled
	(load-theme 'ewal-doom-one t)

	;; Enable flashing mode-line on errors
	(doom-themes-visual-bell-config)

	;; Enable custom neotree theme (all-the-icons must be installed!)
	(doom-themes-neotree-config)
	;; or for treemacs users
	;(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
	;(doom-themes-treemacs-config)

	;; Corrects (and improves) org-mode's native fontification.
	(doom-themes-org-config))

; (use-package treemacs)

(use-package doom-modeline
  :init
  (setq doom-modeline-height 40)
  (doom-modeline-mode))

(use-package solaire-mode
  :init
  (solaire-global-mode))

(use-package centaur-tabs
  :init
  (setq centaur-tabs-height 16)
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-set-bar 'left)
  (setq x-underline-at-descent-line t)
  (centaur-tabs-mode))

;;;; Dashboard
(use-package dashboard
  :init
  (setq dashboard-center-content t)
  (setq dashboard-disable-shortcuts nil)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-footer-messages '("The One True Editor!"
					"Protocol 3: Protect the Pilot"
					"All systems nominal."
					"Democracy... is non negotiable."
					"It's my way or... hell, it's my way!"
					"Death is a preferable alternative to communism."
					"Make life rue the day it though it could give Richard Stallman lemons!"
					"Vi-Vi-Vi, the editor of the beast."
					"Happy hacking!"
					"While any text editor can save your files, only Emacs can save you soul."
					"There's an Emacs package for that."
					"M-x butterfly"
					""))
  (setq dashboard-items '((recents  . 3)
						(projects . 3)
						(agenda . 5)))
  (setq dashboard-startup-banner 'official)
  (setq dashboard-page-separator "\n\n")
  (dashboard-setup-startup-hook))

;;;; Exit
(setq exit-messages '(
	"Please don't leave, there's more demons to toast!"
	"Let's beat it -- This is turning into a bloodbath!"
	"I wouldn't leave if I were you. Vim is much worse."
	"Don't leave yet -- There's a demon around that corner!"
	"Ya know, next time you come in here I'm gonna toast ya."
	"Go ahead and leave. See if I care."
	"Are you sure you want to quit this great editor?"
	"Emacs will remember that."
	"Emacs, Emacs never changes."
	"Okay, look. We've both said a lot of things you're going to regret..."
	"You are *not* prepared!"
	"Look, bud. You leave now and you forfeit your body count!"
	"Get outta here and go back to your boring editors."
	"You're lucky I don't smack you for thinking about leaving."
	"Don't go now, there's a dimensional shambler waiting at the prompt!"
	"Just leave. When you come back I'll be waiting with a bat."
	"Are you a bad enough dude to stay?"
	"It was worth the risk... I assure you."
	"I'm willing to take full responsibility for the horrible events of the last 24 hours."
	))

(defun random-choice (items)
  (let* ((size (length items))
	 (index (random size)))
	(nth index items)))

(defun save-buffers-kill-emacs-with-confirm ()
  (interactive)
  (if (null current-prefix-arg)
	  (if (y-or-n-p (format "%s Quit? " (random-choice exit-messages)))
	(save-buffers-kill-emacs))
	(save-buffers-kill-emacs)))

(global-set-key "\C-x\C-c" 'save-buffers-kill-emacs-with-confirm)


;;; General Interface
;;;; Completing-Read
  (use-package ivy
	:diminish
	:init
	(use-package amx :defer t)
	(use-package counsel :diminish :config (counsel-mode 1))
	(use-package swiper :defer t)
	(ivy-mode 1)
	:bind
	(("C-s"     . swiper-isearch)
	 ("M-x"     . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("<f1> f"  . counsel-describe-function)
	 ("<f1> v"  . counsel-describe-variable)
	 ("<f1> o"  . counsel-describe-symbol)
	 ("<f1> l"  . counsel-find-library)
	 ("<f2> i"  . counsel-info-lookup-symbol)
	 ("<f2> u"  . counsel-unicode-char)
	 ("C-c g"   . counsel-git)
	 ("C-c o"   . ivy-omni-org)
	 ("C-c j"   . counsel-git-grep)
	 (:map ivy-minibuffer-map
		   ("C-r" . ivy-previous-line-or-history)
		   ("M-RET" . ivy-immediate-done)))
	 ;; (:map counsel-find-file-map
	 ;;       ("C-~" . counsel-goto-local-home)))
	:custom
	(ivy-use-virtual-buffers t)
	(ivy-height 10)
	(ivy-on-del-error-function nil)
	(ivy-magic-slash-non-match-action 'ivy-magic-slash-non-match-create)
	(ivy-count-format "[%d/%d] ")
	(ivy-wrap t)
	:config
	(defun counsel-goto-local-home ()
		"Go to the $HOME of the local machine."
		(interactive)
		(ivy--cd "~/")))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode))

(use-package all-the-icons-ivy-rich
  :after ivy-rich
  :init (all-the-icons-ivy-rich-mode))

(use-package ivy-prescient
  :after ivy
  :init (ivy-prescient-mode))

;;;; Introspection
(use-package helpful
  :config
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)
  (global-set-key (kbd "C-h F") #'helpful-function)
  (global-set-key (kbd "C-h C") #'helpful-command)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable))

;;; General Improvements

(use-package crux
  :bind
  (("C-a" . crux-move-beginning-of-line) ;; Move to beginning of text, not line.
   ("C-x 4 t" . crux-transpose-windows)
   ("C-x K" . crux-kill-other-buffers)
   ("C-k" . crux-smart-kill-line))
  :config
  (crux-with-region-or-buffer indent-region)
  (crux-with-region-or-buffer untabify)
  (crux-with-region-or-point-to-eol kill-ring-save)
  (defalias 'rename-file-and-buffer #'crux-rename-file-and-buffer))

(use-package yasnippet
  :init
  (setq yas-triggers-in-field t)
  (yas-global-mode))

;;; Org
;;;; Basic Setup
(setq org-directory "~/Dropbox/org")
(setq org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "NOPE(n)")))

;;;; Archiving
(setq org-archive-location (concat org-directory "/archived.org::"))

(defun replace-in-string (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))
(setq org-archive-truelocation (replace-in-string "~" (getenv "HOME") (concat org-directory "/archived.org")))

(setq org-archive-file-header-format "")
(add-hook 'before-save-hook 'org-archive-done-tasks)

(defun org-archive-done-tasks ()
  (interactive)
  (when (and (eq major-mode 'org-mode) (not (string= buffer-file-name org-archive-truelocation)))
	(org-map-entries
	 (lambda ()
	   (org-archive-subtree)
	   (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
	 "/DONE" 'file)
	(org-map-entries
	 (lambda ()
	   (org-archive-subtree)
	   (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
	 "/NOPE" 'file)
	(find-file (concat org-directory "/archived.org"))
	(write-file org-archive-truelocation)
	(previous-buffer)))

;;;; Project Structure
(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-agenda-dim-blocked-tasks t)

(defun parallel-project ()
"This function makes sure that the current heading has
(1) the tag :project:
(2) has any TODO keyword and
(3) a leading progress indicator"
	(interactive)
	(org-toggle-tag "project" 'on)
	(org-back-to-heading t)
	(let* ((title (nth 4 (org-heading-components)))
		   (keyword (nth 2 (org-heading-components))))
	   (when (and (bound-and-true-p keyword) (string-prefix-p "[" title))
		   (message "TODO keyword and progress indicator found")
		   )
	   (when (and (not (bound-and-true-p keyword)) (not (string-prefix-p "[" title)))
		   (message "no TODO keyword and no progress indicator found")
		   (forward-whitespace 1)
		   (insert "[/] ")
		   )
	   (when (and (bound-and-true-p keyword) (not (string-prefix-p "[" title)))
		   (message "TODO keyword but no progress indicator found")
		   (forward-whitespace 2)
		   (insert "[/] ")
		   )
	   )
	)

(defun sequential-project ()
  (interactive)
  (parallel-project)
  (org-set-property "ORDERED" "t"))

;;;; Recurring TODOs
; (setq org-modules (append org-modules '(org-habit)))
;;;; Calendar

(defun open-org-yearview () (interactive)
  (call-process-shell-command "kitty -e 'agenda' &" nil 0))

(general-define-key "<f5>" 'open-org-yearview)

;;;; Capture
(setq org-capture-templates '(("t" "Todo [inbox]" entry
							   (file+headline "~/Dropbox/org/inbox.org" "Tasks")
							   "* TODO %i%?")
							  ("s" "Schedule" entry
							   (file+headline "~/Dropbox/org/schedule.org" "Schedule")
							   "* %i%? \n %U")
							  ))

(setq org-refile-targets '(("~/Dropbox/org/projects.org" :maxlevel . 3)
			   ("~/Dropbox/org/schoolwork.org" :maxlevel . 2)
						   ("~/Dropbox/org/schedule.org" :maxlevel . 2)))


(global-set-key (kbd "C-c c") 'org-capture)

;;;; Project Review
(setq org-agenda-custom-commands
	  '(("p" tags "project" nil)
		("a" "My agenda"
		 ((org-agenda-list)
		  (org-agenda-list-stuck-projects)
		  (tags "project")))))
(setq org-stuck-projects
	  '("+project/-MAYBE-DONE" ("TODO") nil "\\<IGNORE\\>"))

;;;; Aesthetics
(with-eval-after-load 'org
  (setq org-display-inline-images t)
  (setq org-redisplay-inline-images t)
  (setq org-startup-with-inline-images "inlineimages")
  (setq org-hide-emphasis-markers t)
  (setq org-confirm-elisp-link-function nil)
  (setq org-ellipsis " ")
  (setq org-link-frame-setup '((file . find-file))))

;;;;; Icons
;; (add-hook 'org-mode-hook (lambda ()
;;	 (push '("#+TITLE: " . "" ) prettify-symbols-alist)
;;	 (push '("#+STARTUP:" . "")  prettify-symbols-alist)
;;	 (push '("#+ROAM_TAGS:" . "")  prettify-symbols-alist)
;;	 (push '("#+FILETAGS:" . "")  prettify-symbols-alist)
;;	 (push '("#+RESULTS:" . "")  prettify-symbols-alist)
;;	 (push '("DONE" . "") prettify-symbols-alist)
;;	 (push '("WAIT" . "") prettify-symbols-alist)
;;	 (push '("NOPE" . "") prettify-symbols-alist)
;;	 (push '("DEADLINE:" . "") prettify-symbols-alist)
;;	 (push '("SCHEDULED:" . "") prettify-symbols-alist)
;;	 (push '("[ ]" . "") prettify-symbols-alist)
;;	 (push '("[X]" . "") prettify-symbols-alist)
;;	 (push '("[-]" . "") prettify-symbols-alist)
;;	 (push '("#+BEGIN_SRC" . "") prettify-symbols-alist)
;;	 (push '("#+END_SRC" . "—") prettify-symbols-alist)
;;	 (push '(":END:" . "—") prettify-symbols-alist)
;;	 (push '(":PROPERTIES:" . "") prettify-symbols-alist)
;;	 (push '(":Effort:" . "") prettify-symbols-alist)
;;	 (push '("#+HTML_HEAD:" . "") prettify-symbols-alist)
;;	 (push '("#+SUBTITLE:" . "") prettify-symbols-alist)
;;	 (push '("#+AUTHOR:" . "") prettify-symbols-alist)
;;	 (prettify-symbols-mode)))

(defun org-icons ()
   "Beautify Org Checkbox Symbol"
   (setq prettify-symbols-alist '(("TODO" . "")
								  ("DONE" . "")
								  ("WAIT" . "")
								  ("NOPE" . "")
								  ("[#A]" . "")
								  ("[#B]" . "")
								  ("[#C]" . "")
								  ("[ ]" . "")
								  ("[X]" . "")
								  ("[-]" . "")
								  ("#+BEGIN_SRC" . "")
								  ("#+END_SRC" . "―")
								  (":PROPERTIES:" . "")
								  (":END:" . "―")
								  ("#+STARTUP:" . "")
								  ("#+TITLE: " . "")
								  ("#+RESULTS:" . "")
								  ("#+NAME:" . "")
								  ("#+ROAM_TAGS:" . "")
								  ("#+FILETAGS:" . "")
								  ("#+HTML_HEAD:" . "")
								  ("#+AUTHOR:" . "")
								  (":Effort:" . "")
								  ("SCHEDULED:" . "")
								  ("DEADLINE:" . "")))
   (prettify-symbols-mode))

(defun header-line-spacious ()
  "Header line"
  (setq header-line-format " ")
  (set-face-attribute 'header-line nil :height 400))

(defun writing-hook ()
  ""
  (setq-local company-backends '(company-wordfreq company-ispell))
  (setq-local company-transformers nil)
  (setq-local company-frontends '(company-preview-frontend))
  (setq-local company-minimum-prefix-length 0)
  (writegood-mode))

(add-hook 'org-mode-hook 'org-icons)
(add-hook 'org-mode-hook 'header-line-spacious)

;;;;; Faces
(setq org-fontify-quote-and-verse-blocks t)
(setq org-fontify-emphasized-text t)
(setq org-fontify-done-headline t)

	(setq org-priority-faces '((?A . (:foreground "#f5381b" :weight 'bold))
							  (?B . (:foreground "#f5cb22"))
							  (?C . (:foreground "#6cad50"))))

	(setq org-todo-keyword-faces
		  '(("TODO" . (:foreground "#999999" :bold nil)) ("WAIT" . "#cfd1d1")
			("DONE" . "#6cad50") ("NOPE" . "#cfd1d1")))

	(defface org-checkbox-done-text
	  '((t (:foreground "#71696A" :strike-through t)))
	  "Face for the text part of a checked org-mode checkbox.")



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-headline-done ((((class color) (class color) (min-colors 16)) (:foreground "#cfd1d1")))))
(with-eval-after-load 'org
  (set-face-attribute 'org-hide nil
						:foreground "brightblack"
						:background nil)

	  (set-face-attribute 'org-ellipsis nil
						  :foreground "#999999"
						  :underline nil
						  :weight 'light)
	  (set-face-attribute 'org-special-keyword nil
						  :foreground "#999999"
						  :weight 'light)
	  (set-face-attribute 'org-document-title nil
						  :height 2.0
						  :weight 'bold)
	  (set-face-attribute 'org-todo nil
						  :weight 'light))
;;;;; No :PROPERTIES:
(defun org-cycle-hide-drawers (state)
  "Re-hide all drawers after a visibility state change."
  (when (and (derived-mode-p 'org-mode)
			 (not (memq state '(overview folded contents))))
	(save-excursion
	  (let* ((globalp (memq state '(contents all)))
			 (beg (if globalp
					(point-min)
					(point)))
			 (end (if globalp
					(point-max)
					(if (eq state 'children)
					  (save-excursion
						(outline-next-heading)
						(point))
					  (org-end-of-subtree t)))))
		(goto-char beg)
		(while (re-search-forward org-drawer-regexp end t)
		  (save-excursion
			(beginning-of-line 1)
			(when (looking-at org-drawer-regexp)
			  (let* ((start (1- (match-beginning 0)))
					 (limit
					   (save-excursion
						 (outline-next-heading)
						   (point)))
					 (msg (format
							(concat
							  "org-cycle-hide-drawers:  "
							  "`:END:`"
							  " line missing at position %s")
							(1+ start))))
				(if (re-search-forward "^[ \t]*:END:" limit t)
				  (outline-flag-region start (point-at-eol) t)
				  (user-error msg))))))))))
(defun hide-wrapper ()
  (interactive)
  (org-cycle-hide-drawers 'all))
(global-set-key (kbd "s-b") 'hide-wrapper)

;;;;; Writing
(use-package org-appear
  :straight (:host github :repo "awth13/org-appear"))
(use-package org-fragtog)
(use-package org-autolist)
(setq org-list-allow-alphabetical t)
(add-hook 'org-mode-hook 'turn-on-flyspell)
(use-package mixed-pitch
  :init
  (add-hook 'org-mode-hook 'mixed-pitch-mode))

;;;;; Roam

(use-package org-roam-server
  :after (org-roam server)
  :config
  (setq org-roam-server-host "127.0.0.1"
		org-roam-server-port 8078
		org-roam-server-export-inline-images t
		org-roam-server-authenticate nil
		org-roam-server-network-label-truncate t
		org-roam-server-network-label-truncate-length 60
		org-roam-server-network-label-wrap-length 20)
  (defun org-roam-server-open ()
	"Ensure the server is active, then open the roam graph."
	(interactive)
	(org-roam-server-mode 1)
	(browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port))))


;;;; Babel
;; Enable Org Babel features
(org-babel-do-load-languages ;; More languages!
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (latex . t)
   (shell . t)
   (C . t)))
(setq org-confirm-babel-evaluate nil) ;; Don't ask me if I want to execute my code or not
(setq org-src-tab-acts-natively t) ;; Indentation fix

;; Enable org link features
(org-link-set-parameters
 "run"
 :follow #'org-babel-ref-resolve) ;; Allow execution of Org Babel code from links
(add-to-list 'org-file-apps '(directory . emacs)) ;; Allow links to open directories in Dired

;;; Programming

;;;; Sanity
(setq-default tab-width 4)
;;;; LSP
(use-package lsp-mode
  :init
  (setq lsp-headerline-breadcrumb-enable nil)
  :hook ((c++-mode . lsp)
		 (c-mode . lsp)
		 (python-mode . lsp)
		 (js-mode . lsp)
		 (typescript-mode . lsp))
  :commands lsp)

(use-package lsp-ui :after lsp)

;;;; Company
(use-package company
  :init
  (setq company-idle-delay 0)
  (setq company-tooltip-maximum-width 40)
  (global-company-mode))

(use-package company-quickhelp
  :after company
  :init (company-quickhelp-mode))

(use-package company-prescient
  :after company
  :init
  (setq-default history-length 1000)
  (setq-default prescient-history-length 1000)
  :init (company-prescient-mode))

;;;; flycheck
(use-package flycheck
  :config
  (global-flycheck-mode))
;;;; Language-specific
;;;;; C/C++ config
(setq c-default-style "k&r")

(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(use-package dtrt-indent
  :config
  (dtrt-indent-mode 1))

(setq company-tooltip-maximum-width 60)

(defun code-hook ()
  (lsp)
  (lsp-ui-mode)
  (lsp-ui-sideline-toggle-symbols-info)
  (lsp-ui-doc-mode)
  (company-mode)
  (company-quickhelp-mode)
  (olivetti-mode)
  (olivetti-set-width 180)
  (lsp-focus-mode)
  (focus-mode)
  ; (treemacs)
  (setq lsp-headerline-breadcrumb-mode 0))

(add-hook 'c-mode-common-hook 'code-hook)

(defun clean-whitespace-hook ()
  (whitespace-cleanup))
(add-hook 'before-save-hook #'clean-whitespace-hook)

;;;;; Shell
(use-package emacs-shfmt
  :straight (:host github :repo "purcell/emacs-shfmt"))

;;;; Hackiness

;; (defun contextual-tabs ()
;;   (interactive)
;;   (if (not (treemacs-project-p default-directory))
;;	(centaur-tabs-local-mode)))
;; (add-hook 'after-change-major-mode-hook 'contextual-tabs)

;;;; Aesthetics
;;;;; hl-todo
(global-hl-todo-mode)
(setq hl-todo-keyword-faces
	  '(("TODO"   . "#99bb66")
		("FIXME"  . "#ff6655")
		("DEBUG"  . "#a9a1e1")
		("HACK"   . "#6c78dd")
		("NOTE"   . "#44b9b1")))
(define-key hl-todo-mode-map (kbd "C-c p") 'hl-todo-previous)
(define-key hl-todo-mode-map (kbd "C-c n") 'hl-todo-next)
(define-key hl-todo-mode-map (kbd "C-c o") 'hl-todo-occur)
(define-key hl-todo-mode-map (kbd "C-c i") 'hl-todo-insert)
;; We already have todos in Org Mode!
(add-hook 'org-mode-hook (lambda () (hl-todo-mode -1)))

;;;;; prettify-symbols

;;;;; Icons

(defun my/add-visual-replacement (from to)
  "Make `prettify-symbols-mode' replace string FROM with string TO.

Updates `prettify-symbols-alist'.  You may need to toggle
`prettify-symbols-mode' to make the changes take effect.

Each character of TO is vertically aligned using the baseline,
such that base-left of the character is aligned with base-right
of the preceding character.  Refer to `reference-point-alist'
for more information."
  (push (cons from (let ((composition nil))
					 (dolist (char (string-to-list to)
								   (nreverse (cdr composition)))
					   (push char composition)
					   (push '(Br . Bl) composition))))
		prettify-symbols-alist))

(add-hook 'c-mode-common-hook
		  (lambda ()
			(my/add-visual-replacement "uint64_t" "u64")
			(my/add-visual-replacement "uint32_t" "u32")
			(my/add-visual-replacement "uint16_t" "u16")
			(my/add-visual-replacement "int8_t" "u8")
			(my/add-visual-replacement "int64_t" "i64")
			(my/add-visual-replacement "int32_t" "i32")
			(my/add-visual-replacement "int16_t" "i16")
			(my/add-visual-replacement "int8_t" "i8")
			(my/add-visual-replacement "size_t" "sz_t")
			(my/add-visual-replacement "->" "→")
			(my/add-visual-replacement ">=" "≥")
			(my/add-visual-replacement "<=" "≤")
			(my/add-visual-replacement "!=" "≠")))
(add-hook 'c++-mode-hook
		  (lambda ()
			(c-set-offset 'innamespace 0)
			(my/add-visual-replacement "Eigen::MatrixXf" "mXf")
			(my/add-visual-replacement "Eigen::MatrixXd" "mXd")
			(my/add-visual-replacement "Eigen::Vector2f" "v2f")
			(my/add-visual-replacement "Eigen::Vector2d" "v2d")
			(my/add-visual-replacement "Eigen::Vector2i" "v2i")
			(my/add-visual-replacement "Eigen::Vector3f" "v3f")
			(my/add-visual-replacement "Eigen::Vector3d" "v3d")
			(my/add-visual-replacement "Eigen::Vector3i" "v3i")
			(push '("std::" . "" ) prettify-symbols-alist)))


;;;; Dash

(defun minimal-browse-url (url)
  (call-process-shell-command (concat "firefox -P default-release --new-window " url) nil 0))
(setq dash-docs-browser-func 'minimal-browse-url)
(setq dash-docs-enable-debugging nil)

;;; Writing
(setq ispell-program-name "aspell")
(define-key org-mode-map (kbd "C-c j") 'pandoc-jump-to-reference)
;;;; Distractionless
(defun make-clean-frame ()
  (interactive)
  (setq new-frame
		(make-frame
		 '((name . "editor")
		   (width . 80)
		 (height . 30)
		 (minibuffer . nil)
		 (top . 50)
		 (left . 0)
		 ))))
;;;; Hook
(defun word-processing-hook ()
  ;; Makes code buffers look nicer
  (olivetti-mode 1)
  (olivetti-set-width 100)
  (visual-line-mode 1)
  (global-set-key (kbd "C-c s-a") 'flyspell-auto-correct-word))

(add-hook 'org-mode-hook 'word-processing-hook)

;;; Gaps
;; TODO: Fix gaps
(load "exwm-outer-gaps")
