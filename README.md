# mac-tab-desktop: save and restore native mac tab configuration

Emacs' in-built `desktop.el` enables saving and restoring all open frames, windows, buffers, files etc.  For users of `tab-bar-mode`, tab configuration is correctly handled.  The [emacs-mac](https://bitbucket.org/mituharu/emacs-mac) port of Emacs enables _native_ tabs on emacs.  This tiny package configures `desktop` to automatically save and restore the native tab configuration with `desktop`.

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
