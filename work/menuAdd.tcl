gui_add_ui expMenu -type menu -label NewMenu -in main

gui_add_ui expCmd -type command -label "New command ..." \
-command [list puts "execute my command"] -in expMenu

gui_add_ui expToolbar -type toolbar -in main -label \ 
"New Toolbar" -newline true

gui_add_ui expToolbutton -type toolbutton -in expToolbar -label "new toolbutton" -tooltip "new toolbutton" -icon [file join ./  layout-place-in-schematic.png] -command [list puts "New toolbutton "]

gui_delete_ui expMenu 

gui_delete_ui expToolbar

