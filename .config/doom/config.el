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
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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
;; Adiciona navegação entre os buffers, com as teclas Alt+Seytas
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(defun +my/python-shell-auto-scroll ()
  "Mantém o scroll do buffer Python no final automaticamente."
  (when-let ((python-buffer (python-shell-get-buffer)))
    (with-current-buffer python-buffer
      (goto-char (point-max)))))

(defun +my/send-python-smart ()
  "Send complete Python statement and move to next one."
  (interactive)
  (if (use-region-p)
      (progn
        (python-shell-send-region (region-beginning) (region-end))
        (goto-char (region-end))
        (forward-line 1))
    (let ((start (save-excursion (python-nav-beginning-of-statement) (point)))
          (end (save-excursion (python-nav-end-of-statement) (point))))
      (python-shell-send-region start end)
      (python-nav-forward-statement)
      (beginning-of-line)))

  ;; Scroll automático
  (+my/python-shell-auto-scroll))

(after! python
  (map! :map python-mode-map
        "C-<return>" #'+my/send-python-smart))


(defun +my/python-show-dataframes ()
  "Show only DataFrame variables."
  (interactive)
  (when-let ((proc (python-shell-get-process)))
    (let ((output-buffer (get-buffer-create "*Python DataFrames*")))
      (with-current-buffer output-buffer
        (special-mode)
        (erase-buffer))

      (python-shell-send-string
       (concat
        "import pandas as pd\n"
        "print('=== DATAFRAMES ===')\n"
        "print()\n"
        "for name, value in locals().items():\n"
        "    if isinstance(value, pd.DataFrame):\n"
        "        print(f'📊 {name}:')\n"
        "        print(f'   Shape: {value.shape}')\n"
        "        print(f'   Columns: {list(value.columns)}')\n"
        "        print(f'   Info:')\n"
        "        value.info()\n"
        "        print(f'   Head:')\n"
        "        print(value.head())\n"
        "        print('─' * 50)")
       output-buffer)

      (pop-to-buffer output-buffer))))

(after! python
  (map! :map python-mode-map
        "C-c C-d" #'+my/python-show-dataframes))


;; pdf
(defun +my/pdf-scroll-up ()
  "Scroll up in PDF view."
  (interactive)
  (if (derived-mode-p 'pdf-view-mode)
      (pdf-view-next-line-or-next-page 5)
    (scroll-up-command)))

(defun +my/pdf-scroll-down ()
  "Scroll down in PDF view."
  (interactive)
  (if (derived-mode-p 'pdf-view-mode)
      (pdf-view-previous-line-or-previous-page 5)
    (scroll-down-command)))

(defun +my/pdf-next-page ()
  "Go to next page in PDF."
  (interactive)
  (if (derived-mode-p 'pdf-view-mode)
      (pdf-view-next-page)
    (next-line)))

(defun +my/pdf-previous-page ()
  "Go to previous page in PDF."
  (interactive)
  (if (derived-mode-p 'pdf-view-mode)
      (pdf-view-previous-page)
    (previous-line)))

(defun +my/pdf-goto-page ()
  "Go to specific page in PDF."
  (interactive)
  (if (derived-mode-p 'pdf-view-mode)
      (pdf-view-goto-page (read-number "Go to page: "))
    (goto-char (point-min))))

(defun +my/pdf-fit-width ()
  "Fit PDF to width."
  (interactive)
  (when (derived-mode-p 'pdf-view-mode)
    (pdf-view-fit-width-to-window)))

(defun +my/pdf-fit-page ()
  "Fit PDF to page."
  (interactive)
  (when (derived-mode-p 'pdf-view-mode)
    (pdf-view-fit-page-to-window)))

(defun +my/pdf-zoom-in ()
  "Zoom in PDF."
  (interactive)
  (when (derived-mode-p 'pdf-view-mode)
    (pdf-view-enlarge 1.2)))

(defun +my/pdf-zoom-out ()
  "Zoom out PDF."
  (interactive)
  (when (derived-mode-p 'pdf-view-mode)
    (pdf-view-shrink 1.2)))

(map! :map pdf-view-mode-map
      ;; Navegação básica
      "<down>"      #'+my/pdf-scroll-down
      "<up>"        #'+my/pdf-scroll-up
      "<next>"      #'+my/pdf-next-page
      "<prior>"     #'+my/pdf-previous-page
      "C-n"         #'+my/pdf-next-page
      "C-p"         #'+my/pdf-previous-page

      ;; Navegação avançada
      "C-<down>"    #'pdf-view-next-line-or-next-page
      "C-<up>"      #'pdf-view-previous-line-or-previous-page
      "M-<right>"   #'pdf-view-next-page
      "M-<left>"    #'pdf-view-previous-page

      ;; Zoom e ajuste
      "C-+"         #'+my/pdf-zoom-in
      "C--"         #'+my/pdf-zoom-out
      "C-0"         #'+my/pdf-fit-page
      "C-9"         #'+my/pdf-fit-width

      ;; Navegação por páginas
      "M-g M-g"     #'+my/pdf-goto-page
      "g"           #'pdf-view-first-page
      "G"           #'pdf-view-last-page

      ;; Rolar suavemente (como scroll do mouse)
      "SPC"         #'pdf-view-scroll-up-or-next-page
      "S-SPC"       #'pdf-view-scroll-down-or-previous-page
      "C-v"         #'pdf-view-scroll-up-or-next-page
      "M-v"         #'pdf-view-scroll-down-or-previous-page

      ;; Outline/Navegação por tópicos
      "TAB"         #'pdf-outline
      "C-c C-t"     #'pdf-outline

      ;; Pesquisa
      "C-s"         #'pdf-occur
      "C-r"         #'isearch-backward

      ;; Marcadores/Anotações
      "C-c C-a"     #'pdf-annot-add-highlight-markup-annotation
      "C-c C-n"     #'pdf-annot-add-text-annotation
      )
