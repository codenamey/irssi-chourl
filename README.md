irssi-chourl
==========

Shorten long urls using [cho.fi](https://cho.fi) -service.

Features
--------

Invoke using `/cho something`. If *something* contains spaces, all detected urls in the text are replaced with urlified ones. If *something* is a single "word", no checking is done, i.e. shortening is forced.

If the command was invoked in a chat window, the output is sent to the channel/query. Otherwise, it is printed in the client messages.

If error(s) occur, the count of failed shortenings is printed in a client message.

Installing
----------

1. `wget -O ~/.irssi/scripts/chourl.pl https://raw.github.com/codenamey/irssi-chourl/master/chourl.pl`
2. *optional* `ln -s ~/.irssi/scripts/chourl.pl ~/.irssi/scripts/autorun/chourl.pl`
3. `/run chourl.pl`

Known issues
------------

* Whitespace sequences in sentence-mode are replaced with a single space
