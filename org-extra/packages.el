;;; packages.el --- org-extra layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Orab Liang <orabfy@Orabs-Mac-mini.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `org-extra-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `org-extra/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `org-extra/pre-init-PACKAGE' and/or
;;   `org-extra/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst org-extra-packages
  '(
    (org :location built-in)
    (org-agenda :location built-in)
    (org-plus-contrib :step pre)
    org-mobile-sync
   )
  "The list of Lisp packages required by the org-extra layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun org-extra/post-init-org ()
  (setq org-startup-indented nil)

  (setq org-tag-alist
        '((:startgroup) ("@errand" . ?e) ("@office" . ?o) ("@home" . ?h) (:endgroup)
          ("%Important" . ?I) ("%Urgent" . ?U)
          ("FLAGGED" . ?f) ("WAITING" . ?W) ("HOLD" . ?H) ("CANCELLED" . ?C)
          ("WORK" . ?w) ("PERSONAL" . ?p)
          ("crypt" . ?E)))
  (setq org-global-properties
        '(("Effort_ALL" . "0:30 1:00 3:00 5:00 8:00 13:00 0:00")
          ("STYLE_ALL" . "habit")))
  (setq org-columns-default-format "%50ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM %30TAGS")

  (setq org-log-done 'time)
  ;; Save state changes in the LOGBOOK drawer
  (setq org-log-into-drawer t)
  (setq org-log-state-notes-insert-after-drawers nil)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
          (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))
  (setq org-todo-keyword-faces
        '(("TODO" :weight bold :box (:line-width 1 :color "red") :foreground "red" :background "tomato")
          ("NEXT" :weight bold :box (:line-width 1 :color "blue") :foreground "blue" :background "steel blue")
          ("DONE" :weight bold :box (:line-width 1 :color "forest green") :foreground "forest green" :background "pale green")
          ("WAITING" :weight bold :box (:line-width 1 :color "orange") :foreground "orange" :background "wheat")
          ("HOLD" :weight bold :box (:line-width 1 :color "magenta") :foreground "magenta" :background "orchid")))
  (setq org-todo-state-tags-triggers
        '(("CANCELLED" ("CANCELLED" . t))
          ("WAITING" ("WAITING" . t))
          ("HOLD" ("WAITING") ("HOLD" . t))
          (done ("WAITING") ("HOLD"))
          ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
          ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
          ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))

  (when (file-exists-p "~/Dropbox/org")
    (setq org-directory "~/Dropbox/org")
    (require 'find-lisp)
    (setq org-agenda-files (cons "~/Dropbox/org/refile.org"
                                 (find-lisp-find-files "~/Dropbox/org/GTD" ".*\.org$")))
    (setq org-publish-files (find-lisp-find-files "~/Dropbox/org/publish" ".*\.org$"))
    (setq org-refile-targets '((nil :maxlevel . 8)
                               (org-agenda-files :maxlevel . 8)
                               (org-publish-files :maxlevel . 8)))
    (setq org-capture-templates
          '(("t" "todo" entry (file "~/Dropbox/org/refile.org")
            "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
           ("j" "Journal" entry (file+datetree "~/Dropbox/org/diary.org")
            "* %?\n%U\n" :clock-in t :clock-resume t)
           ("b" "Break" entry (file+datetree "~/Dropbox/org/break.org")
            "* %?\n%U\n" :clock-in t :clock-resume t)
           ("h" "Habit" entry (file "~/Dropbox/org/refile.org")
            "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")))
    ;; MobileOrg config
    (setq org-mobile-directory "~/Dropbox/org/MobileOrg")
    (setq org-mobile-agendas 'default)
    (setq org-mobile-inbox-for-pull "~/Dropbox/org/refile.org"))

  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  (setq org-clock-in-resume t)
  ;; Save clock data and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
 ;; Removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)

  ;; Show clock sums as hours and minutes, not "n days" etc.
  (setq org-time-clocksum-format
        '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))
 )

(defun org-extra/post-init-org-agenda ()
  (require 'org-checklist)
  (require 'org-habit)

  (setq org-agenda-custom-commands
        (quote (("N" "Notes" tags "NOTE"
                 ((org-agenda-overriding-header "Notes")
                  (org-tags-match-list-sublevels t)))
                ("h" "Habits" tags-todo "STYLE=\"habit\""
                 ((org-agenda-overriding-header "Habits")
                  (org-agenda-sorting-strategy
                   '(todo-state-down effort-up category-keep))))
                (" " "Agenda"
                 ((agenda "" nil)
                  (tags "REFILE"
                        ((org-agenda-overriding-header "Tasks to Refile")
                         (org-tags-match-list-sublevels nil)))
                  (tags-todo "-CANCELLED/!"
                             ((org-agenda-overriding-header "Stuck Projects")
                              (org-agenda-skip-function 'orabfy/skip-non-stuck-projects)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-HOLD-CANCELLED/!"
                             ((org-agenda-overriding-header "Projects")
                              (org-agenda-skip-function 'orabfy/skip-non-projects)
                              (org-tags-match-list-sublevels 'indented)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-CANCELLED/!NEXT"
                             ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                    (if orabfy/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'orabfy/skip-projects-and-habits-and-single-tasks)
                              (org-tags-match-list-sublevels t)
                              (org-agenda-todo-ignore-scheduled orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(todo-state-down effort-up category-keep))))
                  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                             ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                    (if orabfy/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'orabfy/skip-non-project-tasks)
                              (org-agenda-todo-ignore-scheduled orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                             ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                    (if orabfy/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'orabfy/skip-project-tasks)
                              (org-agenda-todo-ignore-scheduled orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-CANCELLED+WAITING|HOLD/!"
                             ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                    (if orabfy/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'orabfy/skip-non-tasks)
                              (org-tags-match-list-sublevels nil)
                              (org-agenda-todo-ignore-scheduled orabfy/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines orabfy/hide-scheduled-and-waiting-next-tasks)))
                  (tags "-REFILE/"
                        ((org-agenda-overriding-header "Tasks to Archive")
                         (org-agenda-skip-function 'orabfy/skip-non-archivable-tasks)
                         (org-tags-match-list-sublevels nil))))
                 nil))))

  (setq org-agenda-cmp-user-defined 'orabfy/agenda-sort)

  (setq org-archive-mark-done nil)
  (setq org-archive-location "%s_archive::* Archive")
  ;; Include agenda archive files when searching for things
  (setq org-agenda-text-search-extra-files (quote (agenda-archives)))
 )

(defun org-extra/init-org-mobile-sync ()
  (use-package org-mobile-sync
    :defer t
    :config
    (org-mobile-sync-mode 1))
  )

;;; Assistant function definition
(defun orabfy/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun orabfy/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun orabfy/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                              (point))))
    (save-excursion
      (orabfy/find-project-task)
      (if (equal (point) task)
          nil
        t))))

(defun orabfy/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun orabfy/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun orabfy/list-sublevels-for-projects-indented ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels 'indented)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun orabfy/list-sublevels-for-projects ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels t)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defvar orabfy/hide-scheduled-and-waiting-next-tasks t)

(defun orabfy/toggle-next-task-display ()
  (interactive)
  (setq orabfy/hide-scheduled-and-waiting-next-tasks (not orabfy/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if orabfy/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

(defun orabfy/skip-stuck-projects ()
  "Skip trees that are stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (orabfy/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                nil
              next-headline)) ; a stuck project, has subtasks but no next task
        nil))))

(defun orabfy/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  ;; (orabfy/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (orabfy/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                next-headline
              nil)) ; a stuck project, has subtasks but no next task
        next-headline))))

(defun orabfy/skip-non-projects ()
  "Skip trees that are not projects"
  ;; (orabfy/list-sublevels-for-projects-indented)
  (if (save-excursion (orabfy/skip-non-stuck-projects))
      (save-restriction
        (widen)
        (let ((subtree-end (save-excursion (org-end-of-subtree t))))
          (cond
           ((orabfy/is-project-p)
            nil)
           ((and (orabfy/is-project-subtree-p) (not (orabfy/is-task-p)))
            nil)
           (t
            subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun orabfy/skip-non-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((orabfy/is-task-p)
        nil)
       (t
        next-headline)))))

(defun orabfy/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((orabfy/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun orabfy/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits, single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
        next-headline)
       ((and orabfy/hide-scheduled-and-waiting-next-tasks
             (member "WAITING" (org-get-tags-at)))
        next-headline)
       ((orabfy/is-project-p)
        next-headline)
       ((and (orabfy/is-task-p) (not (orabfy/is-project-subtree-p)))
        next-headline)
       (t
        nil)))))

(defun orabfy/skip-project-tasks-maybe ()
  "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading) (point-max))))
           (limit-to-project (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((orabfy/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (not limit-to-project)
             (orabfy/is-project-subtree-p))
        subtree-end)
       ((and limit-to-project
             (orabfy/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       (t
        nil)))))

(defun orabfy/skip-project-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((orabfy/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       ((orabfy/is-project-subtree-p)
        subtree-end)
       (t
        nil)))))

(defun orabfy/skip-non-project-tasks ()
  "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((orabfy/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (orabfy/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       ((not (orabfy/is-project-subtree-p))
        subtree-end)
       (t
        nil)))))

(defun orabfy/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((orabfy/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun orabfy/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (orabfy/is-subproject-p)
        nil
      next-headline)))
(defun orabfy/narrow-to-org-subtree ()
  (widen)
  (org-narrow-to-subtree)
  (save-restriction
    (org-agenda-set-restriction-lock)))

(defun orabfy/narrow-to-subtree ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-with-point-at (org-get-at-bol 'org-hd-marker)
          (orabfy/narrow-to-org-subtree))
        (when org-agenda-sticky
          (org-agenda-redo)))
    (orabfy/narrow-to-org-subtree)))

(defun orabfy/narrow-up-one-org-level ()
  (widen)
  (save-excursion
    (outline-up-heading 1 'invisible-ok)
    (orabfy/narrow-to-org-subtree)))

(defun orabfy/get-pom-from-agenda-restriction-or-point ()
  (or (and (marker-position org-agenda-restrict-begin) org-agenda-restrict-begin)
      (org-get-at-bol 'org-hd-marker)
      (and (equal major-mode 'org-mode) (point))
      org-clock-marker))

(defun orabfy/narrow-up-one-level ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-with-point-at (orabfy/get-pom-from-agenda-restriction-or-point)
          (orabfy/narrow-up-one-org-level))
        (org-agenda-redo))
    (orabfy/narrow-up-one-org-level)))

(defun orabfy/narrow-to-org-project ()
  (widen)
  (save-excursion
    (orabfy/find-project-task)
    (orabfy/narrow-to-org-subtree)))

(defun orabfy/narrow-to-project ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-with-point-at (orabfy/get-pom-from-agenda-restriction-or-point)
          (orabfy/narrow-to-org-project)
          (save-excursion
            (orabfy/find-project-task)
            (org-agenda-set-restriction-lock)))
        (org-agenda-redo)
        (beginning-of-buffer))
    (orabfy/narrow-to-org-project)
    (save-restriction
      (org-agenda-set-restriction-lock))))

(defvar orabfy/project-list nil)

(defun orabfy/view-next-project ()

  (interactive)
  (let (num-project-left current-project)
    (unless (marker-position org-agenda-restrict-begin)
      (goto-char (point-min))
      ;; Clear all of the existing markers on the list
      (while orabfy/project-list
        (set-marker (pop orabfy/project-list) nil))
      (re-search-forward "Tasks to Refile")
      (forward-visible-line 1))

    ;; Build a new project marker list
    (unless orabfy/project-list
      (while (< (point) (point-max))
        (while (and (< (point) (point-max))
                    (or (not (org-get-at-bol 'org-hd-marker))
                        (org-with-point-at (org-get-at-bol 'org-hd-marker)
                          (or (not (orabfy/is-project-p))
                              (orabfy/is-project-subtree-p)))))
          (forward-visible-line 1))
        (when (< (point) (point-max))
          (add-to-list 'orabfy/project-list (copy-marker (org-get-at-bol 'org-hd-marker)) 'append))
        (forward-visible-line 1)))

    ;; Pop off the first marker on the list and display
    (setq current-project (pop orabfy/project-list))
    (when current-project
      (org-with-point-at current-project
        (setq orabfy/hide-scheduled-and-waiting-next-tasks nil)
        (orabfy/narrow-to-project))
      ;; Remove the marker
      (setq current-project nil)
      (org-agenda-redo)
      (beginning-of-buffer)
      (setq num-projects-left (length orabfy/project-list))
      (if (> num-projects-left 0)
          (message "%s projects left to view" num-projects-left)
        (beginning-of-buffer)
        (setq orabfy/hide-scheduled-and-waiting-next-tasks t)
        (error "All projects viewed.")))))

(defun orabfy/set-agenda-restriction-lock (arg)
  "Set restriction lock to current task subtree or file if prefix is specified"
  (interactive "p")
  (let* ((pom (orabfy/get-pom-from-agenda-restriction-or-point))
         (tags (org-with-point-at pom (org-get-tags-at))))
    (let ((restriction-type (if (equal arg 4) 'file 'subtree)))
      (save-restriction
        (cond
         ((and (equal major-mode 'org-agenda-mode) pom)
          (org-with-point-at pom
            (org-agenda-set-restriction-lock restriction-type))
          (org-agenda-redo))
         ((and (equal major-mode 'org-mode) (org-before-first-heading-p))
          (org-agenda-set-restriction-lock 'file))
         (pom
          (org-with-point-at pom
            (org-agenda-set-restriction-lock restriction-type))))))))

(defun orabfy/agenda-sort (a b)
  "Sorting strategy for agenda items.
Late deadlines first, then scheduled, then non-late deadlines"
  (let (result num-a num-b)
    (cond
     ;; time specific items are already sorted first by org-agenda-sorting-strategy
     ;; non-deadline and non-scheduled items next
     ((orabfy/agenda-sort-test 'orabfy/is-not-scheduled-or-deadline a b))
     ;; deadlines for today next
     ((orabfy/agenda-sort-test 'orabfy/is-due-deadline a b))
     ;; late deadlines next
     ((orabfy/agenda-sort-test-num 'orabfy/is-late-deadline '> a b))
     ;; scheduled items for today next
     ((orabfy/agenda-sort-test 'orabfy/is-scheduled-today a b))
     ;; late scheduled items next
     ((orabfy/agenda-sort-test-num 'orabfy/is-scheduled-late '> a b))
     ;; pending deadlines last
     ((orabfy/agenda-sort-test-num 'orabfy/is-pending-deadline '< a b))
     ;; finally default to unsorted
     (t (setq result nil)))
    result))

(defmacro orabfy/agenda-sort-test (fn a b)
  "Test for agenda sort"
  `(cond
    ;; if both match leave them unsorted
    ((and (apply ,fn (list ,a))
          (apply ,fn (list ,b)))
     (setq result nil))
    ;; if a matches put a first
    ((apply ,fn (list ,a))
     (setq result -1))
    ;; otherwise if b matches put b first
    ((apply ,fn (list ,b))
     (setq result 1))
    ;; if none match leave them unsorted
    (t nil)))

(defmacro orabfy/agenda-sort-test-num (fn compfn a b)
  `(cond
    ((apply ,fn (list ,a))
     (setq num-a (string-to-number (match-string 1 ,a)))
     (if (apply ,fn (list ,b))
         (progn
           (setq num-b (string-to-number (match-string 1 ,b)))
           (setq result (if (apply ,compfn (list num-a num-b))
                            -1
                          1)))
       (setq result -1)))
    ((apply ,fn (list ,b))
     (setq result 1))
    (t nil)))

(defun orabfy/is-not-scheduled-or-deadline (date-str)
  (and (not (orabfy/is-deadline date-str))
       (not (orabfy/is-scheduled date-str))))

(defun orabfy/is-due-deadline (date-str)
  (string-match "Deadline:" date-str))

(defun orabfy/is-late-deadline (date-str)
  (string-match "\\([0-9]*\\) d\. ago:" date-str))

(defun orabfy/is-pending-deadline (date-str)
  (string-match "In \\([^-]*\\)d\.:" date-str))

(defun orabfy/is-deadline (date-str)
  (or (orabfy/is-due-deadline date-str)
      (orabfy/is-late-deadline date-str)
      (orabfy/is-pending-deadline date-str)))

(defun orabfy/is-scheduled (date-str)
  (or (orabfy/is-scheduled-today date-str)
      (orabfy/is-scheduled-late date-str)))

(defun orabfy/is-scheduled-today (date-str)
  (string-match "Scheduled:" date-str))

(defun orabfy/is-scheduled-late (date-str)
  (string-match "Sched\.\\(.*\\)x:" date-str))

(defun orabfy/skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (save-restriction
    (widen)
    ;; Consider only tasks with done todo headings as archivable candidates
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
          (subtree-end (save-excursion (org-end-of-subtree t))))
      (if (member (org-get-todo-state) org-todo-keywords-1)
          (if (member (org-get-todo-state) org-done-keywords)
              (let* ((daynr (string-to-number (format-time-string "%d" (current-time))))
                     (a-month-ago (* 60 60 24 (+ daynr 1)))
                     (last-month (format-time-string
                                  "%Y-%m-"
                                  (time-subtract (current-time) (seconds-to-time a-month-ago))))
                     (this-month (format-time-string "%Y-%m-" (current-time)))
                     (subtree-is-current
                      (save-excursion
                        (forward-line 1)
                        (and (< (point) subtree-end)
                             (re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
                (if subtree-is-current
                    subtree-end ; Has a date in this month or last month, skip it
                  nil))  ; available to archive
            (or subtree-end (point-max)))
        next-headline))))

;;; packages.el ends here
