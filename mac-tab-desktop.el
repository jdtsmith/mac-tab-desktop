;;; mac-tab-desktop.el --- restore mac tab layout with desktop -*- lexical-binding: t; -*-
;; Copyright (C) 2023  J.D. Smith

;; Author: J.D. Smith
;; Homepage: https://github.com/jdtsmith/mac-tab-desktop
;; Package-Requires: ((emacs "27.1") (compat "29.1.4.1"))
;; Version: 0.0.1
;; Keywords: convenience
;; Prefix: mac-tab-desktop
;; Separator: -

;; mac-tab-desktop is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; mac-tab-desktop is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; mac-tab-desktop configures desktop.el to save and restore the Mac
;; native tab layout for framesets saved by desktop.el.  Note that
;; only the emacs-mac port enables native Mac tabs.  This provides
;; similar tab-layout recovery functionality as builtin for
;; tab-bar-mode.  Enable mac-tab-desktop prior to explicit or
;; automatic `desktop-read'.


;;; Code:
;;;; Requires
(require 'seq)
(eval-when-compile
  (require 'cl-lib))
(require 'desktop)

(defun mac-tab-desktop-set-frame-parameters ()
  "Set mac tab parameters on all frames.
Parameters save information on the head frame and position of
other frames in the tab group, as well as which frame is
selected.  Operates only if `mac-frame-tabbing' is non-nil."
  (when mac-frame-tabbing
    (let ((frame-group 0)
          (head-frames '()) selected)
      (dolist (frame (frame-list))
	(when-let ((tab-frames (mac-frame-tab-group-property frame :frames))
		   (head-frame (car tab-frames)))
	  (if (= (length tab-frames) 1) ; no tabs, just this frame
	      (setf (frame-parameter head-frame 'mac-tab) nil)
	    (unless (seq-contains-p head-frames head-frame)
	      (push head-frame head-frames)
	      (setq selected (mac-frame-tab-group-property head-frame
							   :selected-frame))

	      (setf (frame-parameter head-frame 'mac-tab) (cl-incf frame-group))
	      (setf (frame-parameter head-frame 'mac-tab-selected)
		    (eq selected head-frame))
	      (cl-loop for other in (cdr tab-frames)
		       for pos upfrom 1
		       do
		       (setf (frame-parameter other 'mac-tab)
			     (cons frame-group pos))
		       (setf (frame-parameter other 'mac-tab-selected)
			     (eq selected other))))))))))

(defun mac-tab-desktop--process-frame-group (frame-group)
  "Process a FRAME-GROUP.
FRAME-GROUP is an ordered list of frames in a single tab group,
starting with the head frame."
  (let* ((group (nreverse frame-group))
	 (head (car group)))
    (mac-set-frame-tab-group-property head :frames group)
    (mac-set-frame-tab-group-property head :selected-frame
				      (seq-find (lambda (f)
						  (frame-parameter f 'mac-tab-selected))
						group))))

(defun mac-tab-desktop-apply-frame-parameters ()
  "Apply mac tab parameters, organizing all frames into tab groups."
  (let ((frame-group '()))
    (dolist (frame (sort (frame-list)
			 (lambda (a b)
			   (let* ((mta (frame-parameter a 'mac-tab))
				  (ahead (not (consp mta)))
				  (mtb (frame-parameter b 'mac-tab))
				  (bhead (not (consp mtb))))
			     (cond
			      ((null mta) t) ; singles first
			      ((null mtb) nil)
			      ((and ahead bhead) ; both heads, lower wins
			       (< mta mtb))
			      ((and ahead (not bhead))
			       (<= mta (car mtb)))
			      ((and (not ahead) bhead)
			       (< (car mta) mtb))
			      (t ;; both are non-head tab members
			       (or (< (car mta) (car mtb)) ; earlier group
				   (and (= (car mta) (car mtb)) ; same group
					(< (cdr mta) (cdr mtb)))))))))) 
      (when-let ((mac-tab (frame-parameter frame 'mac-tab)))
	(if (consp mac-tab) (push frame frame-group)
	  (when frame-group (mac-tab-desktop--process-frame-group frame-group))
	  (setq frame-group (list frame)))))
    (when frame-group (mac-tab-desktop--process-frame-group frame-group))))

;;;###autoload
(define-minor-mode mac-tab-desktop-mode
  "Save and restore native tab layout with desktop."
  :global t
  :group 'mac-tab-desktop
  (if mac-tab-desktop-mode
      (progn
	(add-hook 'desktop-save-hook #'mac-tab-desktop-set-frame-parameters)
	(add-hook 'desktop-after-read-hook #'mac-tab-desktop-apply-frame-parameters))
    (remove-hook 'desktop-save-hook #'mac-tab-desktop-set-frame-parameters)
    (remove-hook 'desktop-after-read-hook #'mac-tab-desktop-apply-frame-parameters)))

(provide 'mac-tab-desktop)

;;; mac-tab-desktop.el ends here
