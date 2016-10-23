;; -*- lexical-binding: t -*-
(require 'buttercup-init)

(describe "switch-to-buffer"
  :var (config-snapshot)
  (before-all
    (purpose-mode)
    (setq config-snapshot (get-purpose-config-2))
    (load-purpose-config-2
     '((:origin test :priority 70 :purpose p0 :regexp "^xxx-p0-")
       (:origin test :priority 70 :purpose p1 :regexp "^xxx-p1-"))))
  (after-all
    (load-purpose-config-2 config-snapshot)
    (purpose-mode -1))
  (before-each
    (create-buffers "xxx-p0-0" "xxx-p0-1" "xxx-p1-0"))

  (it "with 1 window, switching to same purpose reuses window"
    (build-one-window '(:name "xxx-p0-0"))
    (switch-to-buffer "xxx-p0-1")
    (expect '(:name "xxx-p0-1") :to-match-window-tree))

  (it "with 2 windows, switching to other purpose reuses other window"
    (message "DEBUG: configuration state: %S" (purpose-get-configuration-state))
    (build-two-windows '((:name "xxx-p1-0" :selected t) (:name "xxx-p0-0")))
    (switch-to-buffer "xxx-p0-1")
    (expect '(split (:name "xxx-p1-0")
                    (:name "xxx-p0-1" :selected t))
            :to-match-window-tree))

  (it "with 1 window, switching to other purpose reuses window"
    (build-one-window '(:name "xxx-p0-0"))
    (switch-to-buffer "xxx-p1-0")
    (expect '(:name "xxx-p1-0") :to-match-window-tree))

  (it "with 1 purpose-dedicated window, switching to same purpose reuses window"
    (build-one-window '(:name "xxx-p0-0" :p-ded t))
    (switch-to-buffer "xxx-p0-1")
    (expect '(:name "xxx-p0-1" :p-ded t) :to-match-window-tree))

  (it "with 1 buffer-dedicated window, switching to same purpose creates new window"
    (build-one-window '(:name "xxx-p0-0" :b-ded t))
    (switch-to-buffer "xxx-p0-1")
    (expect '(split (:name "xxx-p0-0" :b-ded t)
                    (:name "xxx-p0-1" :selected t))
            :to-match-window-tree))

  (it "with 1 purpose-dedicated window, switching to other purpose creates new window"
    (build-one-window '(:name "xxx-p0-0" :p-ded t))
    (switch-to-buffer "xxx-p1-0")
    (expect '(split (:name "xxx-p0-0" :p-ded t)
                    (:name "xxx-p1-0" :p-ded nil :selected t))
            :to-match-window-tree)))

(describe "switch-to-buffer-other-window"
  :var (config-snapshot)
  (before-all
    (purpose-mode)
    (setq config-snapshot (get-purpose-config-2))
    (load-purpose-config-2
     '((:origin test :priority 70 :purpose p0 :regexp "^xxx-p0-")
       (:origin test :priority 70 :purpose p1 :regexp "^xxx-p1-"))))
  (after-all
    (load-purpose-config-2 config-snapshot)
    (purpose-mode -1))
  (before-each
    (create-buffers "xxx-p0-0" "xxx-p0-1" "xxx-p1-0"))

  (it "with 1 window, switching to same purpose creates new window"
    (build-one-window '(:name "xxx-p0-0"))
    (switch-to-buffer-other-window "xxx-p0-1")
    (expect '(split (:name "xxx-p0-0")
                    (:name "xxx-p0-1" :selected t))
            :to-match-window-tree))
  (it "with 2 windows, switching to same purpose uses other window"
    (build-two-windows '((:name "xxx-p0-0" :selected t)
                         (:name "xxx-p1-0")))
    (switch-to-buffer-other-window "xxx-p0-1")
    (expect '(split (:name "xxx-p0-0")
                    (:name "xxx-p0-1" :selected t))
            :to-match-window-tree))
  (it "with 2 windows, other window purpose-dedicated, swithing to same purpose creates new window"
    (build-two-windows '((:name "xxx-p0-0" :selected t)
                         (:name "xxx-p1-0" :p-ded t)))
    (switch-to-buffer-other-window "xxx-p0-1")
    (expect '(split (:name "xxx-p0-0")
                    (:name "xxx-p0-1" :selected t)
                    (:name "xxx-p1-0" :p-ded t))
            :to-match-window-tree))
  (it "with 2 windows, other window buffer-dedicated, swithing to same purpose creates new window"
    (build-two-windows '((:name "xxx-p0-0" :selected t)
                         (:name "xxx-p1-0" :p-ded t)))
    (switch-to-buffer-other-window "xxx-p0-1")
    (expect '(split (:name "xxx-p0-0")
                    (:name "xxx-p0-1" :selected t)
                    (:name "xxx-p1-0" :p-ded t))
            :to-match-window-tree)))

(describe "pop-to-buffer"
  :var (config-snapshot)
  (before-all
    (purpose-mode)
    (setq config-snapshot (get-purpose-config-2))
    (load-purpose-config-2
     '((:origin test :priority 70 :purpose p0 :regexp "^xxx-p0-")
       (:origin test :priority 70 :purpose p1 :regexp "^xxx-p1-"))))
  (after-all
    (load-purpose-config-2 config-snapshot)
    (purpose-mode -1))
  (before-each
    (create-buffers "xxx-p0-0" "xxx-p0-1" "xxx-p1-0"))

  (it "with 1 window, switching to same purpose reuses window"
    (build-one-window '(:name "xxx-p0-0"))
    (pop-to-buffer "xxx-p0-1")
    (expect '(:name "xxx-p0-1") :to-match-window-tree))

  (it "with 2 windows, switching to same purpose reuses window"
    (build-two-windows '((:name "xxx-p0-0" :selected t) (:name "xxx-p1-0")))
    (pop-to-buffer "xxx-p0-1")
    (expect '(split (:name "xxx-p0-1" :selected t)
                    (:name "xxx-p1-0"))
            :to-match-window-tree))

  (it "with 2 windows, switching to other purpose reuses other window"
    (build-two-windows '((:name "xxx-p1-0" :selected t) (:name "xxx-p0-0")))
    (pop-to-buffer "xxx-p0-1")
    (expect '(split (:name "xxx-p1-0")
                    (:name "xxx-p0-1" :selected t))
            :to-match-window-tree))

  (it "with 1 window, switching to other purpose creates new window"
    (build-one-window '(:name "xxx-p0-0"))
    (pop-to-buffer "xxx-p1-0")
    (expect '(split (:name "xxx-p0-0")
                    (:name "xxx-p1-0" :selected t))
            :to-match-window-tree))

  (it "with 1 purpose-dedicated window, switching to same purpose reuses window"
    (build-one-window '(:name "xxx-p0-0" :p-ded t))
    (pop-to-buffer "xxx-p0-1")
    (expect '(:name "xxx-p0-1" :p-ded t) :to-match-window-tree))

  (it "with 1 buffer-dedicated window, switching to same purpose creates new window"
    (build-one-window '(:name "xxx-p0-0" :b-ded t))
    (pop-to-buffer "xxx-p0-1")
    (expect '(split (:name "xxx-p0-0" :b-ded t)
                    (:name "xxx-p0-1" :selected t))
            :to-match-window-tree))

  (it "with 1 purpose-dedicated window, switching to other purpose creates new window"
    (build-one-window '(:name "xxx-p0-0" :p-ded t))
    (pop-to-buffer "xxx-p1-0")
    (expect '(split (:name "xxx-p0-0" :p-ded t)
                    (:name "xxx-p1-0" :p-ded nil :selected t))
            :to-match-window-tree)))

(describe "pop-to-buffer-same-window"
  :var (config-snapshot)
  (before-all
    (purpose-mode)
    (setq config-snapshot (get-purpose-config-2))
    (load-purpose-config-2
     '((:origin test :priority 70 :purpose p0 :regexp "^xxx-p0-")
       (:origin test :priority 70 :purpose p1 :regexp "^xxx-p1-"))))
  (after-all
    (load-purpose-config-2 config-snapshot)
    (purpose-mode -1))
  (before-each
    (create-buffers "xxx-p0-0" "xxx-p0-1" "xxx-p1-0"))

  (it "with 1 window, switching to same purpose reuses window"
    (build-one-window '(:name "xxx-p0-0"))
    (pop-to-buffer-same-window "xxx-p0-1")
    (expect '(:name "xxx-p0-1") :to-match-window-tree))
  (it "with 1 window, switching to other purpose reuses window"
    (build-one-window '(:name "xxx-p0-0"))
    (pop-to-buffer-same-window "xxx-p1-0")
    (expect '(:name "xxx-p1-0") :to-match-window-tree))
  (it "with 2 windows, switching to same purpose reuses window"
    (build-two-windows '((:name "xxx-p0-0" :selected t) (:name "xxx-p1-0")))
    (pop-to-buffer-same-window "xxx-p0-1")
    (expect '(split (:name "xxx-p0-1" :selected t)
                    (:name "xxx-p1-0"))
            :to-match-window-tree))
  (it "with 2 windows, switching to other purpose reuses current window"
    (build-two-windows '((:name "xxx-p1-0" :selected t) (:name "xxx-p0-0")))
    (pop-to-buffer-same-window "xxx-p0-1")
    (expect '(split (:name "xxx-p0-1" :selected t)
                    (:name "xxx-p0-0"))
            :to-match-window-tree))
  (it "with 2 windows, current window buffer-dedicated, switching to same purpose uses other window"
    (build-two-windows '((:name "xxx-p0-0" :selected t :b-ded t) (:name "xxx-p1-0")))
    (pop-to-buffer-same-window "xxx-p0-1")
    (expect '(split (:name "xxx-p0-0" :b-ded t)
                    (:name "xxx-p0-1" :selected t))
            :to-match-window-tree))
  (it "with 2 buffer-dedicated windows, switching to same purpose creates new window"
    (build-two-windows '((:name "xxx-p0-0" :selected t :b-ded t) (:name "xxx-p1-0" :b-ded t)))
    (pop-to-buffer-same-window "xxx-p0-1")
    (expect '(split (:name "xxx-p0-0" :b-ded t)
                    (:name "xxx-p0-1" :b-ded nil :selected t)
                    (:name "xxx-p1-0" :b-ded t))
            :to-match-window-tree)))

;; can't test, because "emacs -batch" can't raise frames
(describe "switch-to-buffer-other-frame")

(describe "display-buffer"
  :var (config-snapshot)
  (before-all
    (purpose-mode)
    (setq config-snapshot (get-purpose-config-2))
    (load-purpose-config-2
     '((:origin test :priority 70 :purpose p0 :regexp "^xxx-p0-")
       (:origin test :priority 70 :purpose p1 :regexp "^xxx-p1-"))))
  (after-all
    (load-purpose-config-2 config-snapshot)
    (purpose-mode -1))
  (before-each
    (create-buffers "xxx-p0-0" "xxx-p0-1" "xxx-p1-0"))

  ;; `display-buffer-no-window' is not defined in Emacs 24.3
  (when (version<= "24.4" emacs-version)
    (it "doesn't display a buffer when `display-buffer-no-window' is used"
        (build-one-window '(:name "xxx-p0-0"))
        (display-buffer "xxx-p0-1" '(display-buffer-no-window (allow-no-window . t)))
        (expect '(:name "xxx-p0-0") :to-match-window-tree)
        (display-buffer "xxx-p0-1" '((display-buffer-no-window purpose-display-maybe-other-window)
                                     (allow-no-window . t)))
        (expect '(:name "xxx-p0-0") :to-match-window-tree)))

  (it "pops a window when `purpose-display-fallback' is `pop-up-window'"
    (build-one-window '(:name "xxx-p0-0" :b-ded t))
    (let ((purpose-display-fallback 'pop-up-window))
      (display-buffer "xxx-p1-0" '(display-buffer-same-window)))
    (expect '(split (:name "xxx-p0-0" :b-ded t)
                    (:name "xxx-p1-0" :b-ded nil))
            :to-match-window-tree))
  ;; can't test, because "emacs -batch" can't raise frames
  (it  "pops a frame when `purpose-display-fallback' is `pop-up-frame'")
  (it "throws an error when `purpose-display-fallback' is `error'"
    (build-one-window '(:name "xxx-p0-0" :b-ded t))
    (let ((purpose-display-fallback 'error))
      (expect (apply-partially 'switch-to-buffer "xxx-p1-0" nil 'force)
              :to-throw)))
  (it "falls back to stock `display-buffer' when `purpose-display-fallback' is nil"
    (build-one-window '(:name "xxx-p0-0" :b-ded t))
    (let ((purpose-display-fallback nil))
      (expect (apply-partially 'switch-to-buffer "xxx-p1-0" nil 'force)
              :to-throw))
    (build-two-windows '((:name "xxx-p0-0" :p-ded t) (:name "xxx-p0-1" :p-ded t)))
    (let ((purpose-display-fallback nil))
      (display-buffer "xxx-p1-0"))
    (expect '(split (:name "xxx-p0-0" :p-ded t :selected t)
                    (:name "xxx-p1-0" :p-ded t))
            :to-match-window-tree)))

(describe "advised switch functions"
  (before-all
    (purpose-mode)
    (spy-on #'purpose-switch-buffer)
    (spy-on #'purpose-switch-buffer-other-window)
    (spy-on #'purpose-switch-buffer-other-frame)
    (spy-on #'purpose-pop-buffer)
    (spy-on #'purpose-pop-buffer-same-window))
  (after-all
    (purpose-mode -1))
  (it "switch-to-buffer calls purpose-switch-buffer"
    (insert-user-input "foo")
    (call-interactively 'switch-to-buffer)
    (expect 'purpose-switch-buffer :to-have-been-called))
  (it "switch-to-buffer-other-window calls purpose-switch-buffer-other-window"
    (insert-user-input "foo")
    (call-interactively 'switch-to-buffer-other-window)
    (expect 'purpose-switch-buffer-other-window :to-have-been-called))
  (it "switch-to-buffer-other-frame calls purpose-switch-buffer-other-frame"
    (insert-user-input "foo")
    (call-interactively 'switch-to-buffer-other-frame)
    (expect 'purpose-switch-buffer-other-frame :to-have-been-called))
  (it "pop-to-buffer calls purpose-pop-buffer"
    (insert-user-input "foo")
    (call-interactively 'pop-to-buffer)
    (expect 'purpose-pop-buffer :to-have-been-called))
  (it "pop-to-buffer-same-window calls purpose-pop-buffer-same-window"
    (pop-to-buffer-same-window "foo")
    (expect 'purpose-pop-buffer-same-window :to-have-been-called)))

(describe "switch helpers"
  :var (buf1 buf2 buf3)
  (before-each
    (create-buffers "xxx-p0-0" "xxx-p0-1" "xxx-p1-0")
    (setq buf1 (get-buffer "xxx-p0-0")
          buf2 (get-buffer "xxx-p0-1")
          buf3 (get-buffer "xxx-p1-0"))
    (build-one-window '(:name "xxx-p0-0")))

  (describe "purpose-window-buffer-reusable-p"
    (it "returns non-nil only when window contains buffer"
      (expect (purpose-window-buffer-reusable-p nil buf1) :to-be-truthy)
      (expect (purpose-window-buffer-reusable-p nil buf2) :not :to-be-truthy)))

  (describe "purpose--normalize-width"
    (it "normalizes integers"
      (expect (purpose--normalize-width 5) :to-equal 5))
    (it "normalizes percentages"
      (expect (purpose--normalize-width 0.5) :to-equal (/ (frame-width) 2)))
    (it "returns nil when it receives nil"
      (expect (purpose--normalize-width nil) :to-be nil))
    (it "throws error for negative values")
    (expect (apply-partially 'purpose--normalize-width -5) :to-throw))

  (describe "purpose--normalize-height"
    (it "normalizes integers"
      (expect (purpose--normalize-height 5) :to-equal 5))
    (it "normalizes percentages"
      (expect (purpose--normalize-height 0.5) :to-equal (/ (frame-height) 2)))
    (it "returns nil when it receives nil"
      (expect (purpose--normalize-height nil) :to-be nil))
    (it "throws error for negative values")
    (expect (apply-partially 'purpose--normalize-height -5) :to-throw))

  ;; TODO: add equivalents to these old tests
  ;; (ert-deftest purpose-test-display-at ()
  ;; (ert-deftest purpose-test-special-action-sequences ()
  ;; (ert-deftest purpose-cover-select-buffer-without-action-order ()
  ;; (ert-deftest purpose-test-interactive-switch-buffer-with-some-purpose ()
  ;; (ert-deftest purpose-test-temp-actions-1 ()
  ;; (ert-deftest purpose-test-additional-actions-1 ()
  )
