#!/bin/bash
# this is a simple example script that demonstrates how bookmarking plugins for newsbeuter are implemented
# (c) 2007 Andreas Krennmair
# (c) 2016 Alexander Batischev

#   Ctrl+B to bookmark an article url
#   Ctrl+G to cancel

url="$1"         # url
title="$2"       # tags
description="$3" # nickname (single word only, no spaces)
# feed_title="$4"
# feed_title="newsboat"

# echo -e "${url}\t${title}\t${description}\t${feed_title}" >>~/bookmarks.txt
# echo -e "${description}\t${url}\t;; ${feed_title} ${title}" >>~/.config/surfraw/bookmarks

echo -e "${description} ${url} ${title}" >>~/.config/surfraw/bookmarks
