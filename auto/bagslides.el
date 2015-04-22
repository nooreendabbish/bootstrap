(TeX-add-style-hook
 "bagslides"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("beamer" "bigger")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1")))
   (TeX-run-style-hooks
    "latex2e"
    "beamer"
    "beamer10"
    "inputenc"
    "fontenc"
    "fixltx2e"
    "graphicx"
    "longtable"
    "float"
    "wrapfig"
    "soul"
    "textcomp"
    "marvosym"
    "wasysym"
    "latexsym"
    "amssymb"
    "hyperref"
    "tikz"
    "pgfplots"
    "pgfplotstable"
    "amsmath"
    "xspace"
    "geometry"
    "subcaption")
   (TeX-add-symbols
    '("alert" 1)
    '("pa" 1)
    "A"
    "B")
   (LaTeX-add-labels
    "sec-1"
    "sec-1-1"
    "sec-1-1-1"
    "sec-1-1-2"
    "sec-1-1-3"
    "sec-1-1-4"
    "sec-1-1-5"
    "sec-1-1-6"
    "sec-1-2"
    "sec-1-2-1"
    "sec-1-2-1-1"
    "sec-1-2-1-2"
    "sec-1-2-2"
    "sec-1-2-3"
    "sec-1-3"
    "sec-1-3-1"
    "sec-1-3-2"
    "sec-1-3-3"
    "sec-1-3-4"
    "sec-1-3-4-1"
    "sec-1-3-4-2"
    "sec-1-3-5"
    "sec-1-4"
    "sec-1-4-1"
    "sec-1-4-2"
    "sec-2"
    "sec-3")))

