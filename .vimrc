"Set syntax highlighting on"
syntax on

"Set line numbers"
set number

"Adding powerline plugin"
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2
