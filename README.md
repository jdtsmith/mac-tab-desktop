# mac-tab-desktop: save and restore native Mac tabs

Emacs' in-built `desktop.el` enables saving and restoring all open frames, windows, buffers, files etc.  For users of `tab-bar-mode`, tab configuration is correctly handled.  The [emacs-mac](https://bitbucket.org/mituharu/emacs-mac) port of Emacs enables _native_ tabs on emacs.  This tiny package configures `desktop` to automatically save and restore the native tab configuration.

# Install/usage

```elisp
(use-package mac-tab-desktop
  :load-path "~/code/emacs/mac-tab-desktop"
  :config (mac-tab-desktop-mode 1))
```

or, with straight:

```elisp
(use-package mac-tab-desktop
  :straight (mac-tab-desktop :type git :host github :repo "jdtsmith/mac-tab-desktop")
  :config (mac-tab-desktop-mode 1))
```

Be sure to enable `mac-tab-desktop-mode` prior to the first `desktop-read` (whether explicit, or automatic via [`desktop-save-mode`](https://www.gnu.org/software/emacs/manual/html_node/elisp/Desktop-Save-Mode.html)).

# Pictures

How emacs-mac native Mac tabs look:

<img width="1114" alt="emacs-mac tabs" src="https://github.com/jdtsmith/mac-tab-desktop/assets/93749/c7fc26fd-57fc-4aee-9b14-df09b436395c">

The emacs-mac tab overview (bind `mac-toggle-tab-group-overview`, or just pinch to zoom out):

<img width="1113" alt="emacs-mac tab overview" src="https://github.com/jdtsmith/mac-tab-desktop/assets/93749/8ea61a16-8d1b-48d2-8ca9-73b1cb74cdf2">
