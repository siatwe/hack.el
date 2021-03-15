;;; hack.el --- A simple hack and slash game for emacs: Just for me to learn some (e)lisp
;;; -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Simon Attila Weis
;;
;; Author: Simon Attila Weis <https://github.com/siatwe>
;; Maintainer: Simon Attila Weis <me@siatwe.dev>
;; Created: March 15, 2021
;; Modified: March 15, 2021
;; Version: 0.0.1
;; Keywords: games hack
;; Homepage: https://github.com/siatwe/hack
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Just for me to learn some lisp!
;;
;;; TODO:
;;  - Save pointer position in vector before marking
;;  - Return so saved pointer position after marking
;;  - Simplify get- and set-square functions
;;  - Place @ to area
;;  - Let it move with hjkl keys or, if not possible, width arrow keys
;;  - Define impassable terrain
;;  - Remove tictactoe player functions
;;  - Do I need a game/tick loop?
;;  - Add colors (http://ergoemacs.org/emacs/elisp_define_face.html)
;;; Code:

;; Constants
(defconst *hack-area-height* 16
  "The height of the area.")

(defconst *hack-area-width* 32
  "The width of the area.")

;; Global variables
(defvar *hack-area* nil
  "The board itself.")

(defvar *hack-current-player* nil
  "The character representing the player.")

(setq hack-highlights
      '((".\\|:\\|+" . font-lock-function-name-face)
        ("X|O" . font-lock-constant-face)))

;; Mode
(define-derived-mode hack-mode special-mode
  "hack-mode"
  (define-key hack-mode-map (kbd "SPC") 'hack-mark)
  (define-key hack-mode-map (kbd "q")
    (lambda ()
      (interactive)
      (if (y-or-n-p "Exit Game?")
      (kill-buffer "hack"))))
  (setq font-lock-defaults '(hack-highlights)))

;; Functions
(defun hack ()
  "Start playing Hack."
  (interactive)
  (switch-to-buffer "hack")
  (hack-mode)
  (turn-off-evil-mode)
  (hack-init))

(defun hack-init()
  "Start a new game of Hack."
  (setq *hack-area* (make-vector (* *hack-area-width* *hack-area-height*) "." ))
  (hack-print-board)
  (setq *hack-current-player* ?\X))

(defun hack-print-board ()
  (let ((inhibit-read-only t))
    (erase-buffer)
    (dotimes (row *hack-area-height*)
      (dotimes (column *hack-area-width*)
        (insert (hack-get-square row column)))
      (insert "\n"))))

;; v current-column
;; 0 1 2 < line-number-at-pos -1
;; 3 4 5
;; 6 7 8
(defun hack-get-square (row column)
  "Get the value in the (row, column) square."
  (elt *hack-area* (+ (* (1- (line-number-at-pos)) *hack-area-width*) (current-column))))

(defun hack-set-square (row column value)
  "Set the value in the (row, column) square to value."
  (aset *hack-area* (+ (* (1- (line-number-at-pos)) *hack-area-width*) (current-column)) value))

(defun hack-mark ()
  "Mark the current square."
  (interactive)
  (let ((row (1- (line-number-at-pos)))
        (column (current-column)))
    (hack-set-square row column *hack-current-player*))
  (hack-print-board)
  (hack-swap-players))


(defun hack-swap-players()
  (setq *hack-current-player*
        (if (char-equal *hack-current-player* ?\X)
            ?\O
          ?\X)))

(provide 'hack)
;;; hack.el ends here
