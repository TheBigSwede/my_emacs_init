(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(toggle-frame-fullscreen)






;;; Package config -- see https://melpa.org/#/getting-started
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t))

(use-package helm
  :ensure t
  :init
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (helm-mode 1))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package magit
	     :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package smartparens
  :ensure t
  :init
  (smartparens-global-mode))

(use-package doom-themes
  :ensure t
  :init (load-theme 'doom-one t))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package general
  :ensure t)

(use-package hydra
  :ensure t)

(use-package avy
  :ensure t)

(use-package ace-window
  :ensure t)

(use-package org
  :ensure t
  :config
  ;; Improve org mode looks
  (setq org-startup-indented t
        org-hide-emphasis-markers t
        org-startup-with-inline-images t
        org-image-actual-width '(300)
	org-confirm-babel-evaluate nil
	org-preview-latex-default-process 'dvipng)
  
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  (let* ((variable-tuple
          (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
                ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
                ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
                ((x-list-fonts "Verdana")         '(:font "Verdana"))
                ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
         (base-font-color     (face-foreground 'default nil 'default))
         (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline ,@variable-tuple))))
     `(org-level-7 ((t (,@headline ,@variable-tuple))))
     `(org-level-6 ((t (,@headline ,@variable-tuple))))
     `(org-level-5 ((t (,@headline ,@variable-tuple))))
     `(org-level-4 ((t (,@headline ,@variable-tuple))))
     `(org-level-3 ((t (,@headline ,@variable-tuple))))
     `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.1))))
     `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.2))))
     `(org-document-title ((t (,@headline ,@variable-tuple :height 1.3 :underline nil))))))

  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (add-hook 'org-mode-hook 'visual-line-mode)

  (custom-theme-set-faces
   'user
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))))

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package jupyter
  :ensure t)

(use-package conda
  :ensure t
  :config
  (setq conda-anaconda-home (expand-file-name "~/miniconda3/"))
  (setq conda-env-home-directory (expand-file-name "~/miniconda3/"))
  (setq conda-env-subdirectory "envs")
  (conda-env-initialize-eshell))

(unless (getenv "CONDA_DEFAULT_ENV")
  (conda-env-activate "base"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (jupyter . t)))




;;LaTeX Config
(use-package tex
  :ensure auctex)

(use-package gptai
  :ensure t
  :config
  (setq gptai-model "davinci") 
  (setq gptai-username "Big Swede")
  (setq gptai-api-key "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"))





;;window splitter functions
;;author: jmercouris
(defun hydra-move-splitter-left (arg)
  "Move window splitter left."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (shrink-window-horizontally arg)
    (enlarge-window-horizontally arg)))

(defun hydra-move-splitter-right (arg)
  "Move window splitter right."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (enlarge-window-horizontally arg)
    (shrink-window-horizontally arg)))

(defun hydra-move-splitter-up (arg)
  "Move window splitter up."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-down (arg)
  "Move window splitter down."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (shrink-window arg)
    (enlarge-window arg)))



;;keybindings
(defhydra goto (:color blue :hint nil)
  "
Goto:
>search
^^^^^^^^---------------------------------------------------------------------------
_f_: char
_l_: avy-goto-line
_i_: search forward
_u_: search backward
>windows
-----------------------------------------------------------------------------------
_a_: helm-buffers
_w_: ace-window
"
  ("f" avy-goto-char-2)
  ("l" avy-goto-line)
  ("w" ace-window)

  ("i" isearch-forward)
  ("u" isearch-backward)

  ("a" helm-buffers-list)
  ("q" nil "quit" :color blue))

(defhydra hydra-navigate (:color red
                          :hint nil)
  "
_g_: set-mark-command   _M-g_: mark-sexp          _C-g_: exchange-point-and-mark
_l_: forward-char       _M-l_: forward-word       
_h_: backward-char      _M-h_: backward-word      
--------------------------------------------------------------------------------
_k_: previous-line      _j_: next-line          
_;_: beginning-of-line  _M-;_: end-of-line      
--------------------------------------------------------------------------------
_e_: eval-defun         
_M-DEL_: kill-whole-line    _u_: undo
--------------------------------------------------------------------------------
_C-h_: previous buffer   _C-l_: Next buffer
_M-j_: scroll-up         _M-k_: scroll-down

"
  ("u" undo)
  ("M-DEL" kill-whole-line)
  ("e" eval-defun)
  ("C-g" exchange-point-and-mark)
  ("M-g" mark-sexp)
  ("g" set-mark-command)
  ("l" forward-char)
  ("h" backward-char)
  ("M-l" forward-word)
  ("M-h" backward-word)
  ("j" next-line)
  ("k" previous-line)
  ("C-l" next-buffer)
  ("C-h" previous-buffer)
  ("M-j" (next-line 5))
  ("M-k" (previous-line 5))
  (";" end-of-line)
  ("M-;" beginning-of-line)
  ("q" nil "quit" :color blue))

(defhydra hydra-window (:hint nil)
  "
    Movement^   ^Split^         ^Switch^       ^^^Resize^      
    ------------------------------------------------------------------------------------------------------
    _h_ ←        _M-l_ vertical  ^_M-f_split find_C-h_  X←     
    _j_ ↓        _M-j_ horizontal^_f_ind files   _C-j_  X↓     
    _k_ ↑        _u_ undo        ^_a_ce window   _C-k_  X↑     
    _l_ →        _r_ redo        ^_s_ave         _C-l_  X→     
    ^^^^^^^                                      _D_ Maximize
    ^^^^^^^                                      _d_elete
    _q_ quit
    "
  ("h" windmove-left)
  ("j" windmove-down)

  ("k" windmove-up)
  ("l" windmove-right)
  ("M-l" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right)))
  ("M-j" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down)))
  ("u" (progn
         (winner-undo)
         (setq this-command 'winner-undo)))
  ("r" winner-redo)
  ("M-f" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right)
	 (helm-find-files (read-file-name "Find file: "))))
  ("f" helm-find-files)
  ("a" (lambda ()
         (interactive)
         (ace-window 1)
         (add-hook 'ace-window-end-once-hook
                   'hydra-window/body)))
  ("s" save-buffer)
  ("C-h" hydra-move-splitter-left)
  ("C-j" Hydra-move-splitter-down)
  ("C-k" hydra-move-splitter-up)
  ("C-l" hydra-move-splitter-right)
  ("D" delete-other-windows)
  ("d" delete-window)

  ("q" nil)
  )

(define-minor-mode my-override-mode
  "Minor mode that overrides all other keybindings with custom keybindings."
  :init-value nil
  :lighter " my-override"
  :keymap (make-sparse-keymap)
  (if my-override-mode
      (progn
        ;; Define your keybindings here
    (define-key my-override-mode-map (kbd "M-f") 'goto/body)
    (define-key my-override-mode-map (kbd "M-d") 'hydra-navigate/body)
    (define-key my-override-mode-map (kbd "M-s") 'hydra-window/body)
    ;; If my-override-mode is turned off, reset the keymap
    (set-keymap-parent my-override-mode-map nil))))

(define-globalized-minor-mode my-override-global-mode my-override-mode
  (lambda ()
    (if (not (minibufferp (current-buffer)))
	(my-override-mode 1))))

(add-to-list 'emulation-mode-map-alists '(my-override-global-mode my-override-mode))

(my-override-global-mode 1)







(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(jupyter auctex olivetti org-mode general hydra rainbow-delimiters doom-themes smartparens which-key magit helm-projectile helm company use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-title ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif" :height 1.3 :underline nil))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-level-1 ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif" :height 1.2))))
 '(org-level-2 ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif" :height 1.1))))
 '(org-level-3 ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif"))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif"))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif"))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "#bbc2cf" :family "Sans Serif"))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))
