# Snapshotify

A simple tool for backing up a full site into a static instance.

## To install
```sh
gem install snapshotify
```

## To fetch website
```sh
snapshotify go fetch [website_url] [--debug]
```

## To serve
```sh
snapshotify serve [website_url]
```

## Todo

* Add tests
* Add code to limit hops
* Add code to limit domains to scrape
* Fix bugs in asset rewriting
