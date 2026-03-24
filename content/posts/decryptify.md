---
created: 2026-03-01
tags:
  - note
  - journal
  - cyberStuff
title: decryptify
draft: false
date:
subiect:
dificultate: 3
amuca: false
link:
  - https://tryhackme.com/room/decryptify
lastmod: 2026-03-02T13:14:04.891Z
---
scaning\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301051138.png)\
i did a double scan , cause is seamed a lil bit weird to have a simgle port opened , and i was right , lets search about this waste service\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301052258.png)\
i accesed the website via 1337\
nothing interesting , lets run gobuster\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301053244.png)\
ok lets verify the js\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301053303.png)\
ok interesting\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301053315.png)\
ok lets beatufy if to understand something\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301053352.png)

```
function b(c, d) {
    const e = a();
    return b = function(f, g) {
        f = f - 0x165;
        let h = e[f];
        return h;
    }, b(c, d);
}
const j = b;

function a() {
    const k = ['16OTYqOr', '861cPVRNJ', '474AnPRwy', 'H7gY2tJ9wQzD4rS1', '5228dijopu', '29131EDUYqd', '8756315tjjUKB', '1232020YOKSiQ', '7042671GTNtXE', '1593688UqvBWv', '90209ggCpyY'];
    a = function() {
        return k;
    };
    return a();
}(function(d, e) {
    const i = b,
        f = d();
    while (!![]) {
        try {
            const g = parseInt(i(0x16b)) / 0x1 + -parseInt(i(0x16f)) / 0x2 + parseInt(i(0x167)) / 0x3 * (parseInt(i(0x16a)) / 0x4) + parseInt(i(0x16c)) / 0x5 + parseInt(i(0x168)) / 0x6 * (parseInt(i(0x165)) / 0x7) + -parseInt(i(0x166)) / 0x8 * (parseInt(i(0x16e)) / 0x9) + parseInt(i(0x16d)) / 0xa;
            if (g === e) break;
            else f['push'](f['shift']());
        } catch (h) {
            f['push'](f['shift']());
        }
    }
}(a, 0xe43f0));
const c = j(0x169); 
```

ok interesiting , the majority of the code is obfuscated , lets insert j(0x169) inside the browser console so see if we get something\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301054615.png)\
ok cool this may be the password for the api panel\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301054648.png)\
and it is , cool now we are login at the panel at \$IP/api.php

this functon try to encode and create a invite code usignt an email and constant value , but this aproach is deterministic so we can get the invite code

lets acces the logs page , from gobuster\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301061042.png)\`\`\`

```
5-01-23 14:32:56 - User POST to /index.php (Login attempt)
2025-01-23 14:33:01 - User POST to /index.php (Login attempt)
2025-01-23 14:33:05 - User GET /index.php (Login page access)
2025-01-23 14:33:15 - User POST to /index.php (Login attempt)
2025-01-23 14:34:20 - User POST to /index.php (Invite created, code: MTM0ODMzNzEyMg== for alpha@fake.thm)
2025-01-23 14:35:25 - User GET /index.php (Login page access)
2025-01-23 14:36:30 - User POST to /dashboard.php (User alpha@fake.thm deactivated)
2025-01-23 14:37:35 - User GET /login.php (Page not found)
2025-01-23 14:38:40 - User POST to /dashboard.php (New user created: hello@fake.thm)
```

ok ye may use the email addres hello@fake.thm to login but in the login with invite code\
![](/images/blog-ul-meu/static/Pasted%20image%2020260301072032.png)\
and using the function from the panel we may bruteforce the invite code locally using this script\
i got this small script from this writeup : https://jaxafed.github.io/posts/tryhackme-decryptify/ , to speed up the process , i dont know how to write php and also i dont want to use ai brainlessly

```
<?php

function calculate_seed_value($email, $constant_value) {
    $email_length = strlen($email);
    $email_hex = hexdec(substr($email, 0, 8));
    $seed_value = hexdec($email_length + $constant_value + $email_hex);

    return $seed_value;
}

function generate_token($email, $constant_value) {
     $seed_value = calculate_seed_value($email, $constant_value);
     mt_srand($seed_value);
     $random = mt_rand();
     $invite_code = base64_encode($random);

    return $invite_code;
}


$email = "hello@fake.thm";
$token = generate_token($email, 99999);
print $token

?>
```

using this script we get the code and we are able to log in via invite code\
![](/images/blog-ul-meu/static/Pasted%20image%2020260302072403.png)\
and we got a flag, cool

## THM{CryptographyPwn007}

looking at the source code we can se something interesting about the date parameter , lets try to modify it to see what happens\
![](/images/blog-ul-meu/static/Pasted%20image%2020260302072557.png)\
Padding is a process used in cryptography to ensure that plaintext data fits the fixed block size required by block ciphers like AES. If the plaintext is not a multiple of the block size (e.g., 16 bytes for AES), extra bytes are added to fill the remaining space in the last block. These added bytes, known as **padding**, are removed during decryption to retrieve the original plaintext. Proper padding handling is crucial to avoid security vulnerabilities.\
and we have a padding error , ok cool , now we may use a padding tool to exploit this vuln like padre:https://github.com/glebarez/padre# , with the following payload

```
./padre -u 'http://10.112.171.146:1337/dashboard.php?date=$' -cookie 'PHPSESSID=p1elka0dcenr9iuu1r8fgicvad' <-- PHPSSID from the browser , how to find it :
- Hit F12 - This should open the developer console.
- In the console window, click the Cache menu and select view cookie information.
- This will open a new page with the cookies listed.
- Find the item with the name PHPSESSID.
- Copy the value next to VALUE - this is your session id.

'+3cbo6jT2RANHu+tPAx+1SIUzmehv43y/ABR/m0/SZ0=' <--- value of date

```

![](/images/blog-ul-meu/static/Pasted%20image%2020260302073912.png)

ok cool now we see the padding format of date\
![](/images/blog-ul-meu/static/Pasted%20image%2020260302074042.png)

now leets use the padding in our advantage\
![](/images/blog-ul-meu/static/Pasted%20image%2020260302081050.png)\
cool now lets paste that string in the browser

![](/images/blog-ul-meu/static/Pasted%20image%2020260302074554.png)\
and bam\
**THM{GOT\_COMMAND\_EXECUTION001}**\
cool ctf
