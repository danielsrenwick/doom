;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Daniel Renwick"
      user-mail-address "daniel@renwick.xyz")

;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
(setq doom-font (font-spec :family "Iosevka SS08" :size 22 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Iosevka SS08" :size 22)
      doom-serif-font (font-spec :family "Iosevka Aile" :size 22))

;; (setq doom-theme 'catppuccin)
(setq doom-theme 'kanagawa)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/notes")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
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
 (set-frame-parameter (selected-frame) 'alpha '(100 . 100))
 (add-to-list 'default-frame-alist '(alpha . (100 . 100)))

;; native compile external packages
(setq package-native-compile t)
(setq native-comp-always-compile t)

;; remove home from projects list
(after! projectile (setq projectile-project-root-files-bottom-up (remove ".git"
          projectile-project-root-files-bottom-up)))

;; c++
(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("-j=3"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))

;; latex
(setq reftex-default-bibliography "~/Documents/bibliography.bib")
(setq +latex-viewers '(zathura))

;; magit
;; see avatars
(after! magit
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))
;; enable granular diff-highlights
(after! magit
  (setq magit-diff-refine-hunk 'all))

;; flyspell
 (set-flyspell-predicate! '(markdown-mode gfm-mode)
  #'+markdown-flyspell-word-p)

(defun +markdown-flyspell-word-p ()
  "Return t if point is on a word that should be spell checked.

Return nil if on a link url, markup, html, or references."
  (let ((faces (ensure-list (get-text-property (point) 'face))))
    (or (and (memq 'font-lock-comment-face faces)
             (memq 'markdown-code-face faces))
        (not (cl-loop with unsafe-faces = '(markdown-reference-face
                                            markdown-url-face
                                            markdown-markup-face
                                            markdown-comment-face
                                            markdown-html-attr-name-face
                                            markdown-html-attr-value-face
                                            markdown-html-tag-name-face
                                            markdown-code-face)
                      for face in faces
                      if (memq face unsafe-faces)
                      return t)))))

;; company-mode
(setq company-dabbrev-downcase 0)
(setq company-idle-delay 0)
