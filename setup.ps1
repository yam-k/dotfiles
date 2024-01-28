md $HOME\.emacs.d

sudo New-Item -ItemType SymbolicLink -Path $HOME\.emacs.d\init.el -Target $PSScriptRoot\sources\.emacs.d\init.el

sudo New-Item -ItemType SymbolicLink -Path $HOME\.emacs.d\emacs.org -Target $PSScriptRoot\sources\.emacs.d\emacs.org

if (!(Test-Path "$HOME\.emacs.d\skk-jisyo")) {
    Copy-Item -Recurse "$PSScriptRoot\sources\.emacs.d\skk-jisyo" "$HOME\.emacs.d\skk-jisyo"
}
