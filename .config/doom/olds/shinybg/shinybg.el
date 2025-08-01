;;; coman.el --- Comments Management Mode

;; Copyright (C) 2024  Manuel Teodoro Tenango

;; Author: Manuel Teodoro <teotenn@proton.me>
;; URL: https://codeberg.org/teoten/shinybg
;; Version: 0.2.0
;; Package-Requires: ((emacs "29.1"))
;; Created: 2024-03-28

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Run R shiny apps asynchronously during development with a shiny
;; background for Emacs.

;; Package under active development

;;; Code:
(require 'dash)
(require 'project)

(defcustom shinybg-r-commands '()
  "R commands to be executed to run the shiny app. There is a limit by
R of 10,000 bytes on the total length of expressions used in this
method. Expressions containing spaces or shell metacharacters will
need to be quoted."
  :type 'list
  :group 'shinybg)

(defcustom shinybg-buffer-name "*shinybg:R*"
  "Name of the shinybg buffer"
  :type 'string
  :group 'shinybg)

(defcustom shinybg-r-program
  (if (executable-find "R") "R" nil)
  "Executable R program."
  :type 'string
  :group 'shinybg)

(defcustom shinybg-Rscript-program
  (if (executable-find "Rscript") "Rscript" nil)
  "Executable R program."
  :type 'string
  :group 'shinybg)

(defgroup shinybg nil
  "Shinybg group"
  :group 'text)


;; -------------------------------------------------------------------
(defvar shinybg-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map "p" 'shinybg-start-proc-project)
    (define-key map "s" 'shinybg-start-proc-Rscript)
    (define-key map "r" 'shinybg-restart-proc)
    (define-key map "q" 'shinybg-pause-proc)
    (define-key map "k" 'shinybg-kill-proc)
    map)
  "Key map for shinybg.")

;;; Registry mapping logic
(defvar shinybg-proc-db '() "Processes storage.")

(defun shinybg--create-map-record (method wd command)
  "Creates a map (hash table) containing the details necessary for the
process, including the METHOD used to start the process and whether
the process is ACTIVE?."
  (let ((hmap (make-hash-table :test 'equal))
	(uid (shinybg--generate-db-uid 1)))
    (puthash :uid uid hmap)
    (puthash :wd wd hmap)
    (puthash :status nil hmap)
    (puthash :name (format "shinybg-R[%d]" uid) hmap)
    (puthash :buffer (format "%s[%d]" shinybg-buffer-name uid) hmap)
    (puthash :command command hmap)
    (puthash :method (if (member method '("script" "command" "buffer")) method nil) hmap)
    hmap))

(defun shinybg--get-map-record (local-db key val)
  "Get a map record from LOCAL-DB by its UID. LOCAL-DB must be a list
  cotaining the maps, preferably `shinybg-proc-db'."
  (let ((compare-f (if (stringp val) #'string-equal #'=)))
    (when local-db
      (if (eval (list compare-f val (gethash key (car local-db))))
	  (car local-db)
	(shinybg--get-map-record (cdr local-db) key val)))))

(defun shinybg--remove-map-db (uid)
  "Remove a record from `shinybg-proc-db' based on its UID."
  (setq shinybg-proc-db
	(remove (shinybg--get-map-record shinybg-proc-db :uid uid) shinybg-proc-db)))

(defun shinybg--generate-db-uid (start)
  "Generates a unique id based on current uid saved in
  `shinybg-proc-db'. It iterates in increasing numbers starting at
  START.

  This is a supported function intended to be used at the creation of a
  process record."
  (if (not (shinybg--get-map-record shinybg-proc-db :uid start))
      start
    (shinybg--generate-db-uid (+ 1 start))))


;; Process
(defun shinybg-call-process (method execute-this proc-name buf-name)
  "Calls the async R process in the background, passing the R comands
  listed in COMMANDS-LIST.

  See `shinybg--prepare-proc-command' for the METHOD options and EXECUTE-THIS
  details."
  (let ((command-list (shinybg--prepare-proc-command method execute-this)))
    (make-process
     :name proc-name
     :buffer buf-name
     :command command-list
     :connection-type 'pty)))

(defun shinybg--prepare-proc-command (method execute-this)
  "Prepares the list to be passed to the `:command' parameter of
  `make-process' to be executed by calling the corresponding R prcess
  depending on the METHOD and passing to it EXECUTE-THIS.

  For a METHOD 'command' EXECUTE-THIS is a list of R commands to be executed,
  where each command is an element in the list as string.

  For a METHOD script EXECUTE-THIS it the absolute path of the R
  script (note that R and Emacs might have a different path for ~ or
  home directory and thus, absolute path is preferred)."
  (cond ((string-equal method "command") (list shinybg-r-program "-e" (string-join execute-this ";")))
	;; Not yet implemented
	;; ((string-equal method "region") (list shinybg-r-program "-e" execute-this))
	((string-equal method "script") (list shinybg-Rscript-program execute-this))
	(t nil)))

(defun shinybg--start-process (current-map)
  (let ((buf-name (gethash :buffer current-map)))
    (condition-case e
	(when
	    (shinybg-call-process
	     (gethash :method current-map)
	     (gethash :command current-map)
	     (gethash :name current-map)
	     buf-name)
	  (progn
	    (when (shinybg--get-map-record shinybg-proc-db :buffer buf-name)
	      (shinybg--remove-map-db (gethash :uid current-map)))
	    (push current-map shinybg-proc-db)
	    (message "Created buffer %s with status %s." buf-name
		     (sinybg--proc-status-handler buf-name))))
      (error (when (get-buffer buf-name) (kill-buffer buf-name))
	     (error e)))))


;; Status handler
(defun sinybg--proc-status-handler (buf-name)
  "Returns the status of the shinybg process associated to
  BUF-NAME. The process status is inherited from `process-status'
  except for paused, which is included for a shinybg buffer with no
  current process associated.

As a side effect, the status is also updated in the `shinybg-proc-db'."
  (let ((proc-map (shinybg--get-map-record shinybg-proc-db :buffer buf-name))
	(proc-status (condition-case nil
			 (process-status (get-buffer buf-name))
		       (error nil)))
	(bufp (buffer-match-p t buf-name)))
    (cond
     ;; All matches, then X
     ((and proc-map proc-status bufp
	   (string-equal buf-name (gethash :buffer proc-map)))
      (progn (shinybg--update-process-status proc-map proc-status)
	     proc-status))
     ;; Buf and registry but no process X
     ((and proc-map bufp (not proc-status))
      (progn (shinybg--update-process-status proc-map "paused")
	     "paused"))
     ;; Buf and proc, no registry (error)
     ((and bufp proc-status (not proc-map))
      (error "The buffer's process is not registered by shinybg. Visit the buffer or run list-processes to gain control."))
     ;; Only buf, no reg no proc (error) X
     ((and buf-name (not proc-status) (not proc-map))
      (error "There is no shinybg associated to this buffer."))
     ;; Else
     (t nil))))

(defun shinybg--update-process-status (current-map new-status)
  "Updates a process status in the CURRENT-MAP from the
`shinybg-proc-db' to the NEW-STATUS."
  (puthash :status new-status current-map)
  (when-let (uid (gethash :uid current-map))
    (shinybg--remove-map-db uid))
  (push current-map shinybg-proc-db))


;; Utils
(defun shinybg--choose-from-active-buffers ()
  "Choose a buffer from `shinybg-proc-db'. If more than 1 are listed,
use ido to select."
  (if (= 1 (length shinybg-proc-db))
      (gethash :buffer (car shinybg-proc-db))
    (->> shinybg-proc-db
	 (mapcar (lambda (x) (gethash :buffer x)))
	 (ido-completing-read "Select buffer: "))))


;; Autoloads

;;;###autoload
(defun shinybg-start-proc-project (&optional user-dir)
  "Starts a shinybg process at the root directory of the project,
executing the commands in `shinybg-r-commands'. Output is in a new
buffer named by `shinybg-buffer-name'.

Optionally, it can take a USER-DIR path to specify the project directory."
  (interactive)
  (let* ((default-directory (if user-dir user-dir (project-root (project-current t))))
	 (current-map (shinybg--create-map-record
		       "command"
		       default-directory
		       shinybg-r-commands)))
    (shinybg--start-process current-map)))

;;;###autoload
(defun shinybg-start-proc-Rscript (file-path)
  "Starts a shinybg process executing the R script in
FILE-PATH. Output is in a new buffer named by `shinybg-buffer-name'."
  (interactive "f")
  (let* ((default-directory (file-name-directory file-path))
	 (current-map (shinybg--create-map-record
		       "script"
		       default-directory
		       file-path)))
    (shinybg--start-process current-map)))

;; Other Interactive
(defun shinybg-pause-proc (&optional buf)
  "Pause the process in the shinybg buffer. If no BUF is provided, it
uses ido to select an associated process."
  (interactive)
  (let* ((proc-buf (if buf buf (shinybg--choose-from-active-buffers)))
	 (proc-map (shinybg--get-map-record shinybg-proc-db :buffer proc-buf))
	 (proc-status (sinybg--proc-status-handler proc-buf))
	 (proc-name (gethash :name proc-map)))
    (when (not (string-equal "paused" proc-status))
      (progn
	(delete-process proc-name)
	(sinybg--proc-status-handler proc-buf)))
    (message "Process associated to buffer %s is paused." proc-buf)))

(defun shinybg-restart-proc ()
  "Restarts a shinybg process if it exists."
  (interactive)
  (let* ((proc-buf (shinybg--choose-from-active-buffers))
	 (proc-map (shinybg--get-map-record shinybg-proc-db :buffer proc-buf))
	 (default-directory (gethash :wd proc-map)))
    (shinybg-pause-proc proc-buf)
    (shinybg--start-process proc-map)))

(defun shinybg-kill-proc (&optional buf)
  "Kill the buffer BUF and its associated process. If no BUF is
provided, it uses ido to select an associated process."
  (interactive)
  (let* ((proc-buf (if buf buf (shinybg--choose-from-active-buffers)))
	 (proc-map (shinybg--get-map-record shinybg-proc-db :buffer proc-buf))
	 (uid (gethash :uid proc-map)))
    (kill-buffer proc-buf)
    (shinybg--remove-map-db uid)
    (message "Killed buffer %s and its associated process." proc-buf)))


;; shinybg.el ends here
(provide 'shinybg)
