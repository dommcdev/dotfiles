#!/bin/env bash

xdg-mime default google-chrome.desktop x-scheme-handler/mailto

# Images with Loupe
xdg-mime default Loupe.desktop image/png
xdg-mime default Loupe.desktop image/jpeg
xdg-mime default Loupe.desktop image/gif
xdg-mime default Loupe.desktop image/webp
xdg-mime default Loupe.desktop image/bmp
xdg-mime default Loupe.desktop image/tiff

# Open PDFs with the Document Viewer
xdg-mime default org.gnome.Papers.desktop application/pdf

# Video with Showtime
xdg-mime default org.gnome.Showtime.desktop video/mp4
xdg-mime default org.gnome.Showtime.desktop video/x-msvideo
xdg-mime default org.gnome.Showtime.desktop video/x-matroska
xdg-mime default org.gnome.Showtime.desktop video/x-flv
xdg-mime default org.gnome.Showtime.desktop video/x-ms-wmv
xdg-mime default org.gnome.Showtime.desktop video/mpeg
xdg-mime default org.gnome.Showtime.desktop video/ogg
xdg-mime default org.gnome.Showtime.desktop video/webm
xdg-mime default org.gnome.Showtime.desktop video/quicktime
xdg-mime default org.gnome.Showtime.desktop video/3gpp
xdg-mime default org.gnome.Showtime.desktop video/3gpp2
xdg-mime default org.gnome.Showtime.desktop video/x-ms-asf
xdg-mime default org.gnome.Showtime.desktop video/x-ogm+ogg
xdg-mime default org.gnome.Showtime.desktop video/x-theora+ogg
xdg-mime default org.gnome.Showtime.desktop application/ogg

# Audio with Decibles
xdg-mime default org.gnome.Decibels.desktop audio/mpeg
xdg-mime default org.gnome.Decibels.desktop audio/wav
xdg-mime default org.gnome.Decibels.desktop audio/x-wav
xdg-mime default org.gnome.Decibels.desktop audio/flac
xdg-mime default org.gnome.Decibels.desktop audio/x-flac
xdg-mime default org.gnome.Decibels.desktop audio/mp4
xdg-mime default org.gnome.Decibels.desktop audio/aac
xdg-mime default org.gnome.Decibels.desktop audio/x-m4a
xdg-mime default org.gnome.Decibels.desktop audio/x-m4b
xdg-mime default org.gnome.Decibels.desktop audio/ogg
xdg-mime default org.gnome.Decibels.desktop application/ogg
xdg-mime default org.gnome.Decibels.desktop audio/opus
xdg-mime default org.gnome.Decibels.desktop audio/x-vorbis+ogg
xdg-mime default org.gnome.Decibels.desktop audio/x-ms-wma
xdg-mime default org.gnome.Decibels.desktop audio/x-aiff
xdg-mime default org.gnome.Decibels.desktop audio/midi
xdg-mime default org.gnome.Decibels.desktop audio/x-matroska

# Text files with Neovim
xdg-mime default nvim.desktop text/plain
xdg-mime default nvim.desktop text/english
xdg-mime default nvim.desktop text/x-makefile
xdg-mime default nvim.desktop text/x-c++hdr
xdg-mime default nvim.desktop text/x-c++src
xdg-mime default nvim.desktop text/x-chdr
xdg-mime default nvim.desktop text/x-csrc
xdg-mime default nvim.desktop text/x-java
xdg-mime default nvim.desktop text/x-moc
xdg-mime default nvim.desktop text/x-pascal
xdg-mime default nvim.desktop text/x-tcl
xdg-mime default nvim.desktop text/x-tex
xdg-mime default nvim.desktop application/x-shellscript
xdg-mime default nvim.desktop text/x-c
xdg-mime default nvim.desktop text/x-c++
xdg-mime default nvim.desktop application/xml
xdg-mime default nvim.desktop text/xml

# Docs with OnlyOffice
xdg-mime default org.onlyoffice.desktopeditors.desktop application/msword
xdg-mime default org.onlyoffice.desktopeditors.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document
xdg-mime default org.onlyoffice.desktopeditors.desktop application/vnd.oasis.opendocument.text
xdg-mime default org.onlyoffice.desktopeditors.desktop application/rtf
xdg-mime default org.onlyoffice.desktopeditors.desktop application/vnd.ms-excel
xdg-mime default org.onlyoffice.desktopeditors.desktop application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
xdg-mime default org.onlyoffice.desktopeditors.desktop application/vnd.oasis.opendocument.spreadsheet
xdg-mime default org.onlyoffice.desktopeditors.desktop text/csv
xdg-mime default org.onlyoffice.desktopeditors.desktop application/vnd.ms-powerpoint
xdg-mime default org.onlyoffice.desktopeditors.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation
xdg-mime default org.onlyoffice.desktopeditors.desktop application/vnd.oasis.opendocument.presentation
