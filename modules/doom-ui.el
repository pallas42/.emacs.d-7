;; TODO: Set up treemacs.

(use-package hide-mode-line)

(use-package doom-themes
  :init
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  
  (doom-themes-visual-bell-config)

  ;(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  ;(doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package ewal)
(use-package ewal-doom-themes
  :init
  (load-theme 'ewal-doom-one t))

(use-package doom-modeline
  :init
  (setq doom-modeline-height 40)
  (setq doom-modeline-buffer-encoding nil)
  (doom-modeline-mode))

;; TODO: Contextual solaire
(use-package solaire-mode
  :init
  (solaire-global-mode))

(use-package centaur-tabs
  :init
  (setq centaur-tabs-height 16)
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-icon-scale-factor 0.7)
  (setq centaur-tabs-set-bar 'left)
  (setq x-underline-at-descent-line t)
  (defun contextual-tabs ()
	(interactive)
	(if (and (centaur-tabs-mode-on-p) (eq (derived-mode-p 'prog-mode) nil))
		(centaur-tabs-local-mode)))
  (defun centaur-tabs-hide-tab (x)
	(let ((name (format "%s" x)))
	  (or
	   (window-dedicated-p (selected-window))
	   (string-match-p (regexp-quote "<") name)
	   (string-prefix-p "*lsp" name)
	   (string-prefix-p "*Compile-Log*" name)
	   (string-prefix-p "*company" name)
	   (string-prefix-p "*compilation" name)
	   (string-prefix-p "*Help" name)
	   (string-prefix-p "*straight" name)
	   (string-prefix-p "*Flycheck" name)
	   (string-prefix-p "*tramp" name)
	   (string-prefix-p "*help" name)
	   (and (string-prefix-p "magit" name)
			(not (file-name-extension name)))
	   )))
  (defun centaur-tabs-hide-tab-cached (x) (centaur-tabs-hide-tab x))
  (centaur-tabs-mode)
  :hook
  (after-change-major-mode . contextual-tabs)
  :bind
  ("H-l" . 'centaur-tabs-forward-tab)
  ("H-h" . 'centaur-tabs-backward-tab))

(use-package treemacs
  :after doom-themes
  :init
  (doom-themes-treemacs-config)
  (setq doom-themes-treemacs-theme "doom-colors")
  (setq treemacs-width 30)
  :bind
  ("C-c t" . treemacs))

(use-package treemacs-all-the-icons
  :after treemacs
  :init
  (treemacs-load-theme "all-the-icons"))

(use-package olivetti
  :hook
  (prog-mode . (lambda () (olivetti-mode) (determine-olivetti))))

