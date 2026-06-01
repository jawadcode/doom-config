;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Iosevka Term SS07" :size 18)
      doom-variable-pitch-font (font-spec :family "IBM Plex Serif" :size 20))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-molokai)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map!
 "C-+" #'text-scale-increase
 "C--" #'text-scale-increase

 "C-c W h" #'windmove-left
 "C-c W j" #'windmove-down
 "C-c W k" #'windmove-up
 "C-c W l" #'windmove-right) ; Stupid 'doom/load-session' takes 'C-c w l' already so we have to use 'C-c W' insead


(after! centaur-tabs
  (map! :map centaur-tabs-mode-map
        "C-<tab>" #'centaur-tabs-forward
        "C-<iso-lefttab>" #'centaur-tabs-backward
        "C-S-<tab>" #'centaur-tabs-backward))

;; Better off being explicit
(defun qak/set-indent () (doom/set-indent-width 4))
(add-hook! '(js-ts-mode-hook typescript-ts-mode c-ts-mode-hook c++-ts-mode-hook) #'qak/set-indent)

(after! vertico
  (map! :map vertico-map
        "M-j" #'vertico-next
        "M-k" #'vertico-previous))

(after! corfu
  (map! :map corfu-map
        "M-j"   #'corfu-next
        "M-k"   #'corfu-previous
        "<tab>" #'corfu-complete))

(after! c-ts-mode
  ;; Credit to: https://www.reddit.com/r/emacs/comments/1bgdw0y/comment/kv6q2vl
  (defun qak/c-ts-indent-style()
    `(;; do not indent preprocessor statements
      ((node-is "preproc") column-0 0)
      ;; do not indent namespace children
      ((n-p-gp nil nil "namespace_definition") grand-parent 0)
      ;; append to linux style
      ,@(alist-get 'linux (c-ts-mode--indent-styles 'cpp))))
  (setopt c-ts-mode-indent-style #'qak/c-ts-indent-style))

(add-to-list 'auto-mode-alist '("\\.astro\\'" . web-mode))

(after! lsp-ui
  (setopt lsp-keymap-prefix "C-c l")
  (setopt lsp-ui-doc-show-with-mouse t)
  (setopt lsp-ui-doc-delay 0.075))

(after! lsp-mode
  (setopt lsp-nix-nil-formatter ["alejandra"])
  (setopt lsp-inlay-hint-enable t))

(setq-hook! 'tuareg-mode-hook
  tuareg-use-opam nil)
