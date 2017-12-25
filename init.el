;;; init.el --- Kickstart Emacs -*- lexical-binding: t -*-
;;; Commentary:
;;; Bootstraps the configuration by loading specified org file.

;;; Code:
(with-temp-buffer
  (insert-file-contents (expand-file-name "README.org" user-emacs-directory))
  (goto-char (point-min))
  (while (not (eobp))
    (forward-line 1)
    (cond
     ;; Skip DISABLED Subtrees
     ((looking-at "^\\(\\*+\\) \\(DISABLED\\).*$")
      (end-of-line)
      (message "%s" (match-string 0))
      (re-search-forward
       (format "^\\*\\{1,%d\\} " (length (match-string 1)))
       nil 1)
      (beginning-of-line))
     ;; Log ENABLED Subtrees
     ((looking-at "^\\*+ \\(ENABLED\\|\\).*$")
      (message "%s" (match-string 0)))
     ;; Evaluate Code Blocks
     ((looking-at "^#\\+BEGIN_SRC +emacs-lisp *$")
      (let ((l (match-end 0)))
        (search-forward "\n#+END_SRC")
        (eval-region l (match-beginning 0)))))))
;;; init.el ends here
