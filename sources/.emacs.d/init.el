;;; init.el --- GNU Emacs' setings. -*- lexical-binding: t -*-

;;;; これは何か
;; GNU Emacs バージョン29以降用の設定。
;; とは言いつつ、設定本体はorgファイルに分離してある。
;; org-babelを使って設定本体を読み込むのがこのファイルの役割だけど、
;; org-babelが失敗しても最低限適用したい設定も書いておく。

;;;; emacsの文字コード
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8-emacs-unix)

;;;; 表示フォント
;; 本格的にフォントをいじくる時は、
;; https://extra-vision.blogspot.com/2016/07/emacs.html
;; を読む。
(face-spec-set 'default '((t :font "HackGen Console NF"
                             :height 100)))
(face-spec-set 'fixed-pitch '((t :inherit default)))

;;;; テーマ
(setopt custom-enabled-themes '(adwaita))

;;;; メニューバーとツールバー
(setopt menu-bar-mode t)
(setopt tool-bar-mode nil)

;;;; スクロールバーの位置
(setopt scroll-bar-mode 'right)

;;;; 背景透過
;; (add-to-list 'default-frame-alist '(alpha . 90))

;;;; スタートアップ画面
(setopt inhibit-startup-message t)

;;;; モードラインのカーソル位置
(setopt line-number-mode t)
(setopt column-number-mode t)

;;;; タブ文字
(setopt indent-tabs-mode nil)

;;;; C-h
(define-key global-map (kbd "C-h") #'delete-backward-char)

;;;; 長い行の折り返しのトグル
(define-key global-map (kbd "C-c t t") #'toggle-truncate-lines)

;;;; 画面外へのスクロール
(setopt scroll-conservatively 100)

;;;; yes/noの答え方
(advice-add #'yes-or-no-p :override #'toggle-truncate-lines)

;;;; 色々なファイルを放り込むためのディレクトリの作成
(defconst tmp-dir
  (expand-file-name "tmp/" user-emacs-directory)
  "バックアップファイルとかいろいろ放り込むためのディレクトリ.")
(unless (file-exists-p tmp-dir)
  (make-directory tmp-dir t))

;;;; custom変数の保存先
(setopt custom-file (expand-file-name "custom.el" tmp-dir))

;;;; バックアップファイル
;; (setopt make-backup-files nil) ;バックアップファイルを作らない
(setopt backup-directory-alist `((".*" . ,tmp-dir)))
(setopt version-control t)
(setopt delete-old-versions t)
(setopt kept-new-versions 5)

;;;; ロックファイル
;; (setopt create-lockfiles nil) ;ロックファイルを作らない

;;;; 自動保存ファイル
;; (setopt auto-save-default nil) ;自動保存ファイルを作らない
(setopt auto-save-file-name-transforms `((".*" ,tmp-dir t)))
(setopt auto-save-timeout 10)
(setopt auto-save-interval 100)

;;;; 自動保存リストファイル
;; (setopt auto-save-list-file-prefix nil) ;自動保存リストファイルを作らない
(setopt auto-save-list-file-prefix (expand-file-name "saves-" tmp-dir))

;;;; 操作履歴の記録
(setopt savehist-file (expand-file-name "history" tmp-dir))
(setopt savehist-mode t)

;;;; 音量制御

;; 設定本体のorgファイルの読み込み。
;; .emacs.d直下をごちゃごちゃさせたくないので、ごちゃごちゃやってる。
(let* ((source-file (expand-file-name "emacs.org" user-emacs-directory))
       (generate-file (expand-file-name
                       (file-name-nondirectory
                        (file-name-with-extension source-file ".el"))
                       tmp-dir)))
  (when (file-exists-p source-file)
    (require 'ob-tangle)
    (org-babel-tangle-file source-file generate-file)
    (when (file-exists-p generate-file)
      (load-file generate-file))))
