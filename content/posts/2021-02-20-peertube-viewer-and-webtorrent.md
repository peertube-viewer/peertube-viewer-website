---
title: "PeerTube viewer and WebTorrent"
author: Sosthène Guédon
type: post
date: 2021-02-20
---

A great thing about [PeerTube](https://joinpeertube.org/) is that in order to reduce hosting costs, it uses [WebTorrent](https://webtorrent.io/) to reduce the load in case a video starts being watched by a large amount of people. For those unfamiliar with the technology, here's how it goes:

If you are watching a video and are the only one watching, PeerTube works like any video platform.
You just load the video from the server and play it.
It gets interesting when more than one person watches the same video.
Instead of having everyone download the video from the server, the browsers of everyone watching the video will start communicating with each others.
If there is a part of the video that one watcher has already downloaded that you don't have, instead of loading it yourself from the server, your browser will ask the other watcher to send it to you, reducing the load on the server.
Similarly, if you have part of a video that an other watchers doesn't have, you will be the one sending it to them.
The server is used only when nobody is able to provide for the part of the video you need.

On most videos on PeerTube currently, this isn't that useful, there are rarely many people watching the same video at the same time, and as soon as the tab is closed, you stop sending bits of the video to other watchers.
Also, web browsers don't allow websites to store multiple Gigabytes of data, so you can only seed the part of the video you are currently watching.
However, at the beginning of 2021, PeerTube V3 was released with a live stream feature.
Testing has shown that the use of WebTorrent is highly beneficial. Indeed, unlike videos, people watching live streams are all synchronized, and watch roughly the same bit of the stream at the same time. This means that WebTorrent can be used at its full potential, despite the limitations of the web.

What this means for PeerTube viewer
===================================

Sadly, due to the complexity of [WebRTC](https://webrtc.org/), the standard that allows WebTorrent to make browsers communicate with each others, there aren't many implementations outside of  the major browsers, which means that the Javascript WebTorrent implementation is pretty much the only one.
[LibTorrent recently added support for WebTorrent](https://feross.org/libtorrent-webtorrent/), but it is yet to be supported by major torrent clients, [even those that use LibTorrent](https://github.com/qbittorrent/qBittorrent/issues/4163#issuecomment-652467673).

As of today, PeerTube viewer relies either on:

1. The [youtube-dl](https://duckduckgo.com/?t=ffab&q=youtube-dl&ia=web) [integration for mpv](https://mpv.io/manual/stable/#options-ytdl)
2. Directly streaming the video from the server (with the `--use-raw-urls` flag)

As a result, PeerTube viewer isn't capable of using the WebTorrent capabilities of PeerTube, so using PeerTube viewer might be harming the hosts of the videos you are watching, by using more of their bandwidth than necessary.

How to temporarily improve the situation
----------------------------------------

At term, I would like for PeerTube viewer to be able to work fully with PeerTube's WebTorrent capabilities, but this will require a lot of work.
For the moment, there are a few solutions:

1. [Setting your browser as the video player](#setting-your-browser-as-the-video-player)
2. [Using mpv's WebTorrent hook](#using-mpvs-webtorrent-hook)
3. [Using your browser for live streams](#using-your-browser-for-live-streams)

### Setting your browser as the video player.


This can be done with the cli argument `--player firefox`, or by adding:

```toml
[player]
command="firefox"
```

It is understandable that this solution is a bit counter productive given that the goal of PeerTube viewer is to be able to go without a web browser.

### Using mpv's WebTorrent hook

There is a [cli version of WebTorrent](https://github.com/webtorrent/webtorrent-cli) as well as an [mpv hook](https://github.com/noctuid/mpv-webtorrent-hook) (thanks [Alex Kenji](https://gitlab.com/a-kenji) for [telling me about it](https://gitlab.com/peertube-viewer/peertube-viewer-rs/-/issues/30#note_511497042)).
With this installed, mpv can play a video coming from WebTorrent by just being given a torrent file.
Amazing! This means that there is an easy way to make PeerTube viewer work with it, once both are installed, just use `peertube-viewer-rs --use-torrent --torrent-downloader=mpv`.
This tricks PeerTube Viewer into thinking that mpv will download the video via torrent, and then the mpv hook will do the trick of launching `webtorrent-cli` and using that to watch the video. Mission accomplished!

Sadly, this doesn't work very well. Indeed, it might work for a few videos, but recent versions of PeerTube use a standard called [HLS](https://en.wikipedia.org/wiki/HTTP_Live_Streaming) via [p2p-media-loarder](https://github.com/novage/p2p-media-loader) for videos, which means that the video is cut into smaller pieces, all having their own torrent file.

For example, this trick won't work for videos coming from [diode.zone](https://diode.zone), and a few other instances. It also will never work with live streams.

### Using your browser for live streams

The final solution, which is the one I use, is to use your browser for watching PeerTube live streams but sticking to PeerTube Viewer for normal videos.
As was said before, WebTorrent for normal videos doesn't bring much. However it is incredibly useful for live streams.

This is a good compromise, where you can use the lightweight CLI for all the videos you watch, and benefit from a fully featured video player (increasing playback speed, offsetting sound) and lightweight browsing, without being too much of a burden on the host.
