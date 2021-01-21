(require 'package)

(defun package-fixer ()
  (interactive)
  (setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
                           ("gnu" . "http://elpa.gnu.org/packages/")))
  
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/") t)
  
  (package-initialize)
  (setq url-http-attempt-keepalives nil)
  (setq package-check-signature nil))   ;
(package-fixer)
