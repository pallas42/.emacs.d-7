;; code-aesthetic.el --- Make code look nicer

;; I'm tired of lsp-ui looking terrible
(lsp-ui-mode 1)
(set-face-attribute 'lsp-ui-sideline-code-action nil
  :foreground "#999999")
(setq lsp-ui-doc-header t)
(custom-set-faces
   '(lsp-ui-doc-background ((t :background "#fafafa")))
   '(lsp-ui-doc-header ((t :background "#f0f0f0")))
   '(lsp-ui-doc-url ((t :inherit link))))
(setq lsp-ui-doc-border "#999999")
(setq lsp-ui-doc-position 'bottom)
(setq lsp-ui-doc-delay 3)
(setq lsp-ui-sideline-delay 1)

(custom-set-faces
 '(company-tooltip-common ((t (:foreground "#00008b"))))
 '(company-tooltip ((t (:foreground "#333333" :background "#f5f5f5"))))
 '(company-scrollbar-fg ((t (:background "#999999"))))
 '(company-scrollbar-bg ((t (:background "#f5f5f5"))))
 '(company-tooltip-common-selection ((t (:foreground "green")))))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

(global-flycheck-mode)
(yas-global-mode 1)

(defun code-visuals-hook ()
  ;; Makes code buffers look nicer
  (olivetti-mode 1)
  (olivetti-set-width 100)
  (focus-mode 1)
  (visual-line-mode 1))
(defun code-features-hook ()
  ;; LSP, flycheck, and co.
  (lsp)
  (lsp-ui-mode 1))
(add-hook 'c-mode-common-hook 'code-visuals-hook)
(add-hook 'c-mode-common-hook 'code-features-hook)
(add-hook 'python-mode-hook 'code-visuals-hook)

(provide 'code-aesthetic)
