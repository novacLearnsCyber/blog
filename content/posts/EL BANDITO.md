---
created: 2026-11-24
tags:
  - note
  - journal
  - thm
  - cyberStuff
title: EL BANDITO
date: 2026-11-24T10:42:49.934Z
lastmod: 2026-11-24T12:03:51.420Z
---
this machine is not working correctly , thanks thm

recon:

```bash

┌──(k㉿kali)-[~]
└─ nmap $IP
Starting Nmap 7.99 ( https://nmap.org ) at 2026-11-24 12:44 +0200
Nmap scan report for 10.114.133.11
Host is up (0.25s latency).
Not shown: 996 closed tcp ports (reset)
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
631/tcp  open  ipp
8080/tcp open  http-proxy

Nmap done: 1 IP address (1 host up) scanned in 4.00 seconds
```

> ipp = The Internet Printing Protocol is a specialized communication protocol used between client devices and printers. The protocol allows clients to submit one or more print jobs to the printer or print server attached via network or USB, and perform tasks such as querying the status of a printer,

examining the burn token page we find this

```javascript
|   |
|---|
|<script type="text/javascript">|
|const date = new Date().getFullYear();|
|document.getElementById("current-date").innerHTML = date;|
||
|$(document).ready(function () {|
|var webSocket;|
|var wsUri = (window.location.protocol === 'https:' ? 'wss://' : 'ws://') + window.location.host + '/ws'; // Adjust the '/ws' if your WebSocket endpoint differs|
|function initWebSocket() {|
|webSocket = new WebSocket(wsUri);|
||
|webSocket.onopen = function(event) {|
|console.log("WebSocket is open now.");|
|};|
||
|webSocket.onmessage = function(event) {|
|console.log("Message from server: ", event.data);|
|$("#response").text(event.data); // Displaying the response from the server|
|};|
||
|webSocket.onerror = function(event) {|
|console.error("This service is not working on purpose ;)", event);|
|};|
||
|webSocket.onclose = function(event) {|
|console.log("WebSocket is closed now.");|
|};|
|}|
||
|initWebSocket();|
||
|// Form submission with WebSocket|
|$("#token-burn").submit(function (event) {|
|event.stopPropagation();|
|event.preventDefault();|
|console.log("here");|
||
|if(webSocket.readyState === WebSocket.OPEN) {|
|var message = {|
|action: "burn",|
|address: $("#address").val(),|
|amount: $("#amount").val()|
|};|
|webSocket.send(JSON.stringify(message));|
|} else {|
|console.error("WebSocket is not open.");|
|}|
|});|
|});|
|</script>|
```

also ts\
![](/images/blog-ul-meu/static/Pasted%20image%2020261124125609.png)

services.html

![](/images/blog-ul-meu/static/Pasted%20image%2020261124132837.png)

![](/images/blog-ul-meu/static/Pasted%20image%2020261124133021.png)

username:hAckLIEN password:YouCanCatchUsInYourDreams404
