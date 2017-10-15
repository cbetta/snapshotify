# Snapshotify

A simple tool for backing up a full site into a static instance.

## To install
```sh
gem install snapshotify
```

## Quick start
```sh
> snapshotify https://example.com
................
> snapshotify serve example.com
[2017-10-15 13:30:57] INFO  WEBrick 1.3.1
[2017-10-15 13:30:57] INFO  ruby 2.4.2 (2017-09-14) [x86_64-darwin16]
[2017-10-15 13:30:57] INFO  WEBrick::HTTPServer#start: pid=7103 port=8000

## To fetch website
```sh
snapshotify [website_url] [--debug]
```

## To serve
```sh
snapshotify serve [relative_folder]
```

## Todo

* Add tests
* Add code to limit hops
* Add code to limit domains to scrape
* Fix bugs in asset rewriting
