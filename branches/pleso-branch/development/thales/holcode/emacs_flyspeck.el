;
; C-x C-e to evaluate


(hol-light-run-process-if-needed)

(setq hol-light-interactive-buffer-name "*hol-light-toplevel*")
(setq hol-light-interactive-buffer-name "*j12*")
(setq hol-light-interactive-buffer-name "*f15*")

; thackmac
(setq hol-light-interactive-buffer-name "*j25*")
(setq hol-light-interactive-buffer-name "*206A*")

(print hol-light-interactive-buffer-name)


(hol-light-interactive-get-old-input)


; process control 
(signal-process 6592 9)

; (* custom *)
(hol-light-display-buffer-on-eval)

(defun insert-date()
  "insert the current date into current buffer"
  (interactive)
  (shell-command "date" t))

; insert date no time
(insert (format-time-string "%D %T %a" (current-time)))

; was 1024.
; .emacs suggestions:
;(setq comint-buffer-maximum-size 5000)
; keep shell buffer to  5000
;
(custom-set-variables
 '(comint-buffer-maximum-size 8000) ; limit buffer size.
)

;; run a few shells.
(shell "*search*")

; C-5, to switch to shells
(global-set-key [(control 5)]
  (lambda () (interactive) (switch-to-buffer "*search*")))


;(remove-hook 'comint-output-filter-functions
;          'comint-truncate-buffer)

(global-set-key "\C-cy" '(lambda ()
   (interactive)
   (popup-menu 'yank-menu)))

; (setq xxxx yank-menu) 

