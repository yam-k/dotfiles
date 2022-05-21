;;; init.el --- my emacs settings. -*- eval: (outline-hide-body) -*-

;;; Commentary:
;; emacsの設定ファイル

;;; Code:
(package-initialize) ;パッージシステムの起動

;; package-archivesにmelpaを追加
(setq package-archives
      (cons '("melpa" . "https://melpa.org/packages/")
            package-archives))

;; use-packageがインストールされていなければ多分初回起動なので、必須パッ
;; ケージとorgの最新版をインストール。
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'blackout)
  (package-install (cadr (assq 'org package-archive-contents))))


;;; Settings:
(use-package appearance :no-require
  :custom-face
  (default ((t (:family "HackGen" :height 100))))
  (fixed-pitch ((t (:inherit default))))

  ;; Myrica Mを使っていた時のフォント設定。
  ;; set-fontset-fontは、日本語フォントのサイズが微妙に揃わないのを補正
  ;; している。
  ;;
  ;; :config
  ;; (custom-set-faces
  ;;  '(default ((t (:family "Myrica M" :height 100))) t)
  ;;  '(fixed-pitch ((t (:inherit default))) t))
  ;; (set-fontset-font t
  ;;                   '(#x80 . #x10ffff)
  ;;                   (font-spec :family "Myrica M" :size 10.5)))

  :custom
  (custom-enabled-themes '(leuven)) ;テーマ

  (menu-bar-mode t) ;メニューバーを表示する
  (tool-bar-mode nil) ;ツールバーを表示しない
  (scroll-bar-mode 'right) ;スクロールバーは右側
  )


(use-package behavior :no-require
  :bind
  (("C-h" . delete-backward-char))

  :custom
  (inhibit-startup-screen t) ;スタートアップスクリーンを表示しない

  (indent-tabs-mode nil) ;インデントにタブ文字を使わない
  (tab-width 2) ;既に入力されているタブ文字は2文字分で表示

  (kill-whole-line t) ;行頭でのC-kは改行文字も含める

  (scroll-conservatively 101) ;スムーズスクロール

  :config
  ;; yes RETかno RETを入力する場面で、yかnで済むようにする。
  (advice-add #'yes-or-no-p :override #'y-or-n-p)
  )

(defvar init:tmp-dir
  (expand-file-name "tmp/" user-emacs-directory)
  "一時ファイルの保存先ディレクトリ.")
(use-package tmporary-files :no-require
  :custom
  ;; バックアップファイル
  ;; (init.el~とか)
  (backup-directory-alist ;~/.emacs.d/tmp/に作成
   `((".*" . ,init:tmp-dir)))
  (version-control t) ;バックアップの世代管理をする
  (kept-new-versions 5) ;最新5世代分は確保する
  (kept-old-versions 1) ;オリジナルは残す
  (delete-old-versions t) ;それ以外は削除する
  ;; (make-backup-files nil) ;バックアップファイルを作らない

  ;; 自動保存ファイル
  ;; (#init.el#とか)
  (auto-save-file-name-transforms ;~/.emacs.d/tmp/に作成
   `((".*" ,init:tmp-dir t)))
  (auto-save-timeout 10) ;保存の間隔(秒)
  (auto-save-interval 100) ;保存の間隔(打鍵)
  ;; (auto-save-default nil) ;自動保存ファイルを作らない

  ;; 自動保存リストファイル
  ;; (~/.emacs.d/auto-save-list/.saves-****)
  (auto-save-list-file-prefix ;~/.emacs.d/tmp/に作成
   (concat init:tmp-dir "saves-"))
  ;; (auto-save-list-file-prefix nil) ;自動保存リストファイルを作らない

  ;; ロックファイル
  ;; (.#init.elとか)
  ;; (create-lockfiles nil) ;ロックファイルを作らない

  ;; custom変数をinit.elに記録しないようにする
  (custom-file (concat init:tmp-dir "custom.el"))

  :config
  ;; 退避ディレクトリが無ければ作る。
  (unless (file-exists-p init:tmp-dir)
    (make-directory init:tmp-dir))
  )


(use-package position-display :no-require
  :bind
  (("C-c t l" . display-line-numbers-mode))

  :custom
  ;; モードライン
  (line-number-mode t) ;カーソル位置の行番号を表示
  (column-number-mode t) ;カーソル位置の行頭からの文字数を表示

  ;; 編集領域の左側
  (display-line-numbers t) ;行番号を表示
  (display-line-numbers-width 4) ;行番号表示用に4桁分を確保
  )


(use-package fill-column :no-require
  :bind
  (("C-c t i" . display-fill-column-indicator-mode)
   ("C-c t t" . toggle-truncate-lines))

  :custom
  (fill-column 72) ;1行を72文字に

  ;; fill-columnの目安位置に"|"を表示
  (global-display-fill-column-indicator-mode t)
  (display-fill-column-indicator-character ?|)
  )


(use-package paren
  :custom
  (show-paren-mode t) ;カーソル位置の括弧の範囲を見易くする
  (show-paren-style 'parenthesis) ;表示方法は、対応する括弧を強調
  )


(use-package whitespace
  :blackout t
  :blackout global-whitespace-mode
  :bind
  (("C-c t w" . global-whitespace-mode)
   ("C-c t M-w" . whitespace-mode))

  :custom
  (global-whitespace-mode t) ;非表示文字を見易くする

  ;; 見易くする非表示文字の種類
  (whitespace-style '(face
                      trailing
                      tabs
                      spaces
                      newline
                      empty
                      newline-mark
                      space-mark
                      tab-mark))

  ;; 非表示文字に別のグリフを割り当てる
  (whitespace-display-mappings
   '((newline-mark ?\n [?| ?\n])
     ;; (space-mark ?　 [?＿])
     ;; (space-mark ?  [?.])
     ;; (space-mark ?  [?_])
     (tab-mark ?\t [?» ?\t])))
  )


(use-package eldoc
  :blackout t
  )


;;; Operation Support:
(use-package which-key
  :ensure t
  :blackout t
  :custom
  (which-key-mode t)
  (which-key-replacement-alist
   (append '((("\\`C-c d\\'" . nil) . (nil . "develop"))
             (("\\`C-c f\\'" . nil) . (nil . "flycheck"))
             (("\\`C-c m\\'" . nil) . (nil . "magit"))
             (("\\`C-c o\\'" . nil) . (nil . "org"))
             (("\\`C-c C-o\\'" . nil) . (nil . "outline"))
             (("\\`C-c t\\'" . nil) . (nil . "toggle"))
             (("\\`C-c y\\'" . nil) . (nil . "yasnippet")))
           which-key-replacement-alist))
  )
(use-package vertico
  :ensure t
  :custom
  (vertico-mode t)
  (vertico-cycle t)
  )


(use-package orderless
  :ensure t
  :custom
  (completion-styles (append completion-styles '(orderless)))
  (completion-category-overrides '((file (styles partial-completion))))
  )


(use-package marginalia
  :ensure t
  :custom
  (marginalia-mode t)
  )


(use-package consult
  :ensure t
  )


(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim))

  :config
  (add-to-list
   'display-buffer-alist
   '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
     nil
     (window-parameters (mode-line-format . none))))
  )
(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)
  )


(use-package popper
  :ensure t
  :bind
  (("C-`" . popper-toggle-latest)
   ("M-`" . popper-cycle)
   ("C-M-`" . popper-toggle-type)
   ("C-@" . popper-toggle-latest)
   ("M-@" . popper-cycle)
   ("C-M-@" . popper-toggle-type))

  :custom
  (popper-reference-buffers '("\\*Messages\\*"
                              "Output\\*$"
                              help-mode
                              compilation-mode
                              inferior-emacs-lisp-mode
                              slime-repl-mode
                              "\\*inferior-lisp\\*"
                              "\\*slime-events\\*"
                              geiser-repl-mode
                              "\\*geiser messages\\*"))
  (popper-mode t)
  (popper-echo-mode t)
  )


;;; Editing Support:
(setq skk-user-directory
      (expand-file-name "skk" user-emacs-directory)
      skk-get-jisyo-directory
      (expand-file-name "skk-jisyo" skk-user-directory))
(use-package skk
  :ensure ddskk
  :blackout t
  :config
  (unless (file-exists-p skk-get-jisyo-directory)
      (skk-get skk-get-jisyo-directory))

  :hook
  (isearch-mode . skk-isearch-mode-setup)
  (isearch-mode-end . skk-isearch-mode-cleanup)

  :custom
  (default-input-method "japanese-skk")
  (skk-use-jisx0201-input-method t)
  (skk-search-katakana 'jisx0201-kana)

  (skk-large-jisyo (expand-file-name "SKK-JISYO.L"
                                     skk-get-jisyo-directory))
  (skk-itaiji-jisyo (expand-file-name "SKK-JISYO.itaiji"
                                      skk-get-jisyo-directory))

  (skk-show-annotation t)
  (skk-show-annotation-delay 0)

  (skk-show-mode-show t)
  (skk-show-mode-style 'inline)

  (skk-latin-mode-string "[_A]")
  (skk-hiragana-mode-string "[あ]")
  (skk-katakana-mode-string "[ア]")
  (skk-jisx0208-latin-mode-string "[Ａ]")
  (skk-jisx0201-mode-string "[_ｱ]")
  (skk-abbrev-mode-string "[aA]")

  (skk-isearch-mode-enable 'always)
  (skk-isearch-start-mode 'latin)

  (skk-henkan-show-candidates-keys '(?a ?s ?d ?f ?g ?h ?j))
  (skk-delete-okuri-when-quit t)
  )
(use-package ddskk-posframe
  :ensure t
  :blackout t
  :custom
  (ddskk-posframe-mode t)
  )


(use-package company
  :ensure t
  :blackout t
  :bind
  (:map company-mode-map
        ("C-M-i" . company-complete)

        :map company-active-map
        ("C-h" . nil)
        ("M-p" . nil)
        ("M-n" . nil)
        ("C-p" . company-select-previous)
        ("C-n" . company-select-next)
        ("TAB" . company-complete-selection)
        ("C-s" . company-filter-candidates)

        :map company-search-map
        ("C-p" . company-select-previous)
        ("C-n" . company-select-next))

  :custom
  (global-company-mode t)
  (company-selection-wrap-around t)
  (company-idle-delay 0.5)
  )


(use-package flycheck
  :ensure t
  :blackout t
  :custom
  (flycheck-keymap-prefix (kbd "C-c f"))
  (global-flycheck-mode t)
  )


(use-package yasnippet
  :ensure t
  :blackout
  :bind
  (("C-c y n" . yas-new-snippet)
   ;; ("C-c y i" . yas-insert-snippet)
   ;; ("C-c y v" . yas-visit-snippet-file)

   :map yas-minor-mode-map
   ("C-c" . nil))
  )
(use-package yasnippet-snippets
  :ensure t
  )
(use-package consult-yasnippet
  :ensure t
  :bind
  (("C-c y i" . consult-yasnippet)
   ("C-c y v" . consult-yasnippet-visit-snippet-file))
  )


;;; Editing Mode:
(use-package outline
  :demand outline-magic
  :blackout outline-minor-mode
  :bind
  (("C-c t C-o" . outline-minor-mode)

   ;; outline-magic由来の機能の割り当て
   :map outline-minor-mode-map
   ("<tab>" . outline-cycle)
   ("C-c C-o TAB" . outline-cycle))

  :hook
  (emacs-lisp-mode . outline-minor-mode)

  :custom
  (outline-minor-mode-prefix (kbd "C-c C-o"))
  )
(use-package outline-magic
  :ensure t
  )


(use-package org
  :ensure t
  :pin gnu
  :defer t
  :mode
  ("\\.org\\'" . org-mode)
  ("\\.txt\\'" . org-mode)

  :bind
  (("C-c o l" . org-store-link)
   ("C-c o a" . org-agenda)
   ("C-c o c" . org-capture))

;  :custom-face
;  (org-document-title ((t (:height 1.0))))
;  (org-meta-line ((t (:inherit font-lock-comment-face))))

  :custom
  (org-directory (expand-file-name "~/org/"))
  (org-todo-keywords '((sequence "TODO(t!)"
                                 "WAIT(w@)"
                                 "|"
                                 "DONE(d!)"
                                 "CANCEL(c@)"
                                 "MEMO(m)")))
  (org-agenda-files (list (concat org-directory "capture.org")))
  (org-structure-template-alist '(("c" . "center")
                                  ("cl" . "src common-lisp")
                                  ("C" . "comment")
                                  ("e" . "example")
                                  ("el" . "src emacs-lisp")
                                  ("en" . "src emacs-lisp :tangle no")
                                  ("E" . "export")
                                  ("Ea" . "export ascii")
                                  ("Eh" . "export html")
                                  ("El" . "export latex")
                                  ("q" . "quote")
                                  ("s" . "src")
                                  ("v" . "verse")))
  (org-export-backends '(ascii
                         html
                         icalendar
                         latex
                         odt
                         texinfo))
  (org-export-default-language "ja")
  (which-key-replacement-alist
   (cons '(("\\`C-c o\\'" . nil) . (nil . "org"))
         which-key-replacement-alist))
  )
(use-package org-capture
  :defer t
  :custom
  (org-capture-templates '(("m" "メモ" entry
                            (file "capture.org")
                            "* MEMO %? %T\n%i"
                            :empty-lines 1)
                           ("s" "スケジュール" entry
                            (file "capture.org")
                            "* %?\n日時: %^t\n%i"
                            :empty-lines 1)
                           ("t" "やること" entry
                            (file "capture.org")
                            "* TODO %?\n%i"
                            :empty-lines 1)
                           ("T" "やること(期限付き)" entry
                            (file "capture.org")
                            "* TODO %?\ndeadline: %^t\n%i"
                            :empty-lines 1)))
  )
(use-package ox-latex
  :defer t
  :after ox
  :custom
  (org-latex-compiler "lualatex")
  (org-latex-classes
   `(("article"
      ,(concat
        "\\documentclass[paper=a4,\n"
        "               ]{jlreq}\n"
        "[no-default-packages]\n"
        "[packages]\n"
        "[extra]\n")
      ;; ("\\part{%s}" . "\\part*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("book"
      ,(concat
        "\\documentclass[paper=a4,\n"
        "               tate,\n"
        "               book,\n"
        "               twocolumn,\n"
        "               ]{jlreq}\n"
        "[default-packages]\n"
        "[no-packages]\n"
        "[extra]\n"
        "\\renewcommand{\\thesection}{}\n")
      ;; ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
  (org-latex-default-class "article")

  (org-latex-hyperref-template nil)
  (org-latex-default-packages-alist
   '(("AUTO" "inputenc" t ("pdflatex" "lualatex"))
     ("T1" "fontenc" t ("pdflatex" "lualatex"))
     (#1="" "graphicx" t)
     (#1# "longtable" nil)
     (#1# "wrapfig" nil)
     (#1# "rotating" nil)
     ("normalem" "ulem" t)
     (#1# "amsmath" t)
     (#1# "amssymb" t)
     (#1# "capt-of" nil)
     (#1# "pxrubrica" t)))
  (org-latex-packages-alist
   (append
    org-latex-default-packages-alist
    (list
     (concat
      "\\usepackage[colorlinks=true,\n"
      "            setpagesize=false,\n"
      "           ]{hyperref}\n")
     (concat "\\hypersetup{pdfcreator={"
             org-export-creator-string "},\n"
             "            pdflang={utf-8},\n"
             "           }\n"))))
  )


(use-package ssh-config-mode
  :ensure t
  :defer t
  :mode "~/.ssh/config\\'"
  )


;; (use-package rust-mode
;;   :ensure t
;;   :defer t

;;   :custom
;;   (rust-format-on-save t)
;;   )
;; (use-package rustic
;;   :ensure t
;;   :defer t
;;   :custom
;;   (rustic-lsp-client nil)
;;   (rustic-display-spinner 'moon)
;;   )
;; (use-package toml-mode
;;   :ensure t
;;   :defer t
;;   :mode
;;   ("\\.toml\\'" . toml-mode)
;;   )


;;; Development Environment:
(use-package ielm
  :defer t
  :bind
  (("C-c d i" . ielm))
  )


(use-package slime
  :ensure t
  :defer t
  :bind
  (("C-c d s" . slime))

  :custom
  (slime-kill-without-query-p t)
  (common-lisp-style-default 'sbcl)

  :config
  (setq slime-lisp-implementations '((ros ("ros" "-Q" "run"))))
  )


(use-package geiser
  :ensure t
  :defer t
  :bind
  (("C-c d g" . geiser))

  :custom
  (geiser-guile-init-file (expand-file-name "geiser-guile"
                                            user-emacs-directory))
  )
(use-package geiser-guile
  :ensure t
  :defer t
  )


;; (use-package lsp-mode
;;   :ensure t
;;   :defer t
;;   :bind
;;   (("C-c d l" . lsp))

;;   :custom
;;   (lsp-keymap-prefix "C-c l")
;;   (lsp-eldoc-render-all t)
;;   (lsp-idle-delay 0.6)
;;   (lsp-rust-analyzer-cargo-watch-command "clippy")

;;   (lsp-rust-analyzer-server-display-inlay-hints t)
;;   (lsp-rust-analyzer-display-chaining-hints t)
;;   (lsp-rust-analyzer-display-lifetime-elision-hints-enable
;;    "skip_trivial")
;;   (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names
;;    nil)
;;   (lsp-rust-analyzer-display-closure-return-type-hints t)
;;   (lsp-rust-analyzer-display-parameter-hints nil)
;;   (lsp-rust-analyzer-display-reborrow-hints nil)

;;   :hook
;;   (lsp-mode . lsp-ui-mode)
;;   )
;; (use-package lsp-ui
;;   :ensure t
;;   :defer t
;;   :custom
;;   (lsp-ui-peek-always-show t)
;;   (lsp-ui-sideline-show-hover t)
;;   (lsp-ui-doc-enable nil)
;;   )
;; (use-package lsp-treemacs
;;   :ensure t
;;   :defer t
;;   )
;; (use-package dap-mode
;;   :ensure t
;;   :defer t
;;   )
;; (use-package consult-lsp
;;   :ensure t
;;   :defer t
;;   )


;;; Tools:
(use-package auto-package-update
  :ensure t
  :custom
  (auto-package-update-hide-results t)
  (auto-package-update-delete-old-version t)
  (auto-package-update-last-update-day-filename
   (concat init:tmp-dir "last-package-update-day"))

  :config
  (auto-package-update-maybe)
  )


(use-package dired
  :defer t
  :custom
  (dired-dwim-target t) ;操作対象を別のdiredで表示中のディレクトリにする
  )


(use-package magit
  :ensure t
  :defer t
  :bind
  (("C-c M-g" . nil)
   ("C-c m d" . magit-file-dispatch)
   ("C-c m i" . magit-init)
   ("C-c m s" . magit-status))
  )


;;; Exwm:
(use-package exwm
  :ensure t
  :defer t
  :hook
  (exwm-update-class . (lambda ()
                         (exwm-workspace-rename-buffer
                          exwm-class-name)))
  (exwm-manage-finish
   .
   (lambda ()
     (when (and exwm-class-name (string= exwm-class-name "Firefox"))
       (exwm-input-set-local-simulation-keys nil))))

  :custom
  (exwm-workspace-number 1)
  (exwm-input-simulation-keys '(([?\C-b] . [left])
                                ([?\C-f] . [right])
                                ([?\C-p] . [up])
                                ([?\C-n] . [down])
                                ([?\C-a] . [home])
                                ([?\C-e] . [end])
                                ([?\M-v] . [prior])
                                ([?\C-v] . [next])
                                ([?\C-d] . [delete])
                                ([?\C-h] . [backspace])
                                ([?\C-k] . [S-end delete])))
  (exwm-floating-border-width 3)
  (exwm-floating-border-color "white")
  (exwm-input-global-keys '(([?\s-r] . exwm-reset)
                            ([?\s-w] . exwm-workspace-switch)))

  :config
  (setq menu-bar-mode nil
        tool-bar-mode nil
        scroll-bar-mode nil
        use-dialog-box nil)

  (require 'exwm-systemtray)
  (exwm-systemtray-enable)
  )
(use-package exwm-x
  :ensure t
  :defer t
  :bind
  ((:map exwm-mode-map
         ([?\C-q] . exwm-input-send-next-key)
         ("C-c C-t C-f" . exwmx-floating-toggle-floating)))

  :hook
  (exwm-update-class . exwmx-grocery--rename-exwm-buffer)
  (exwm-update-title . exwmx-grocery--rename-exwm-buffer)
  (exwm-manage-finish . exwmx-grocery--manage-finish-function)

  :config
  (exwmx-floating-smart-hide)
  (exwmx-button-enable)
  (setq exwm-input-prefix-keys
        (append '(?\C-t
                  ?\C-q)
                exwm-input-prefix-keys))
  (define-key global-map (kbd "C-t") nil)
  (exwmx-input-set-key (kbd "C-t ;") #'exwmx-dmenu)
  (exwmx-input-set-key (kbd "C-t :") #'exwmx-appmenu-simple)
  (exwmx-input-set-key (kbd "C-t C-e") #'exwmx-sendstring)
  (exwmx-input-set-key (kbd "C-t C-r") #'exwmx-appconfig)
  (exwmx-input-set-key (kbd "C-c y") #'exwmx-sendstring-from-kill-ring)
  (exwmx-input-set-key (kbd "C-t C-t") #'exwmx-button-toggle-keyboard)
  (with-eval-after-load 'switch-window
    (setq switch-window-input-style 'minibuffer)
    (define-key exwm-mode-map (kbd "C-x o") #'switch-window)
    (define-key exwm-mode-map
      (kbd "C-x 1") #'switch-window-then-maximize)
    (define-key exwm-mode-map
      (kbd "C-x 2") #'switch-window-then-split-below)
    (define-key exwm-mode-map
      (kbd "C-x 3") #'switch-window-then-split-right)
    (define-key exwm-mode-map
      (kbd "C-x 0") #'switch-window-then-delete))
  (exwmx-input-set-key (kbd "C-t z") #'exwmx-floating-hide-all)
  (exwmx-input-set-key (kbd "C-t b") #'exwmx-switch-application)
  (exwmx-input-set-key (kbd "C-t C-f") #'exwmx-floating-toggle-floating)
  (exwm-enable)
  )

;;; init.el ends here
