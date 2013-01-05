;;; creole-mode.el --- a markup mode for creole

;; Copyright (C) 2013  Nic Ferrier

;; Author: Nic Ferrier <nferrier@ferrier.me.uk>
;; Maintainer: Nic Ferrier <nferrier@ferrier.me.uk>
;; Keywords: hypermedia, wp
;; Version: 0.0.1
;; URL: https://github.com/nicferrier/creole-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Background

;; This was prompted by this
;; https://github.com/nicferrier/elwikicreole/issues/10 which
;; referenced this:
;; http://manuelp.github.com/emacs/2009/11/03/wikicreole-mode-emacs.html
;;

;;; Commentary:

;; Assist in the creation of WikiCreole files.
;;
;; Does auto-filling properly, has some fontification for WikiCreole
;; elements.
;;
;; Should allow urls to be opened, but that's a bug right now.


;;; Code:

(require 'org)

(defvar creole-mode-map nil
  "Keymap for `creole-mode'.")

(unless creole-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-c\C-o" 'browse-url-at-point)
    (setq creole-mode-map map)))

(defun creole-mode/fill-break-p ()
  "Fill computation for Creole.

Basically just does not fill within links."
  (memq 'link (text-properties-at (point))))

(define-generic-mode 'creole-mode
  nil ; comments
  nil; keywords
  '(("^\\(= \\)\\(.*?\\)\\($\\| =$\\)" . 'info-title-1)
    ("^\\(== \\)\\(.*?\\)\\($\\| ==$\\)" . 'info-title-2)
    ("^\\(=== \\)\\(.*?\\)\\($\\| ===$\\)" . 'info-title-3)
    ("^\\(====+ \\)\\(.*?\\)\\($\\| ====+$\\)" . 'info-title-4)
    ("\\[\\[.*?\\]\\]" . 'link)
    ("\\[.*\\]" . 'link)
    ("\\[b\\].*?\\[/b\\]" . 'bold)
    ("//.*?//" . 'italic)
    ("\\*\\*.*?\\*\\*" . 'bold)
    ("_.*?_" . 'underline)
    ("\\\\\\\\[ \t]+" . font-lock-warning-face)) ; font-lock list
  '(".creole\\'"); auto-mode-alist
  '((lambda ()
      (require 'info)
      (require 'goto-addr)
      (require 'org)
      (orgtbl-mode)
      (orgstruct-mode) ; for editing lists
      (use-local-map creole-mode-map)
      (make-local-variable 'fill-nobreak-predicate)
      (setq fill-nobreak-predicate
            (list 'creole-mode/fill-break-p))
      (auto-fill-mode 1)))
  "Creole-Wiki mode.

Edit files written in WikiCreole form.

\<KEYMAP>.")

(provide 'creole-mode)

;;; creole-mode.el ends here
