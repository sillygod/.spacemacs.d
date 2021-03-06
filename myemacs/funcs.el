;; Currently, put some misc helper functions here

(defun hey-god (question)
  "Reduce distraction when you search the answer for the question.
Powered by the howdoi"
  (interactive "sAsk the god, you'll get it: ")
  (let ((buffer-name "*God's reply*")
        (exectuable-name "howdoi"))
    (with-output-to-temp-buffer buffer-name
      (shell-command (concat exectuable-name " " question)
                     buffer-name
                     "*Messages*")
      (pop-to-buffer buffer-name))))

(defun copy-region-and-base64-decode (start end)
  (interactive "r")
  (let ((x (base64-decode-string
           (decode-coding-string
            (buffer-substring start end) 'utf-8))))
    (kill-new x)))

;; define a function to open a temp panel to show to result of base64 decode
;; (base64-decode-string "jife")
;; NOTE: You should encode the multibyte character first, then encode it to base64
;; (base64-encode-string (encode-coding-string "多字节" 'utf-8))

;; http://ergoemacs.org/emacs/elisp_command_working_on_string_or_region.html
;; there is way to make the interactive function to dynamically to accept different numbers of args
(defun region-base64-encode (content)
  (interactive)
  (base64-encode-string (encode-coding-string content 'utf-8)))


(defun region-base64-decode (content)
  (interactive)
  (base64-decode-string (decode-coding-string content 'utf-8)))

(defun copy-region-and-urlencode (start end)
  (interactive "r")
  (let ((x (url-hexify-string
            (buffer-substring start end))))
  (kill-new x)))

(defun now ()
  "Get the current time, In the future this will show a temp buffer with unix format, human readable and the weather info"
  (interactive)
  (message "now: %s \n timestamp: %s" (format-time-string "%Y-%m-%d %H:%m %z") (format-time-string "%s")))

(defun myemacs-change-tag (old new)
  (when (member old (org-get-tags))
    (org-toggle-tag new 'on)
    (org-toggle-tag old 'off)))

(defun org-rename-tag (old new)
  (interactive "sCurrent tag: \nsNew tag: ")
  (org-map-entries
   (lambda () (myemacs--change-tag old new))
   (format "+%s" old)
   nil))

(defun toggle-fold ()
  (interactive)
  (save-excursion
    (end-of-line)
    (hs-toggle-hiding)))

(require 'tramp)
;; try to make the tramp to be compatible with the gcloud ssh
(add-to-list 'tramp-methods
             '("gcssh"
               (tramp-login-program "gcloud compute ssh")
               (tramp-login-args (("%h")))
               (tramp-async-args (("-q")))
               (tramp-remote-shell "/bin/sh")
               (tramp-remote-shell-args ("-c"))
               (tramp-gw-args (("-o" "GlobalKnownHostsFile=/dev/null")
                               ("-o" "UserKnownHostsFile=/dev/null")
                               ("-o" "StrictHostKeyChecking=no")))
               (tramp-default-port 22)))
