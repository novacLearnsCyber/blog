---
created: 2026-11-12
tags:
  - note
  - journal
  - dreamhack
  - cyberStuff
title: Dreamhack > phpreg
date: 2026-11-12T10:38:07.889Z
lastmod: 2026-11-12T10:45:56.523Z
---
link:https://dreamhack.io/wargame/challenges/873

access the page, u will be prompted to input a pass and username.\
inspecting the step2.php we see the following :

```php
          if ($_SERVER["REQUEST_METHOD"] == "POST") {
            $input_name = $_POST["input1"] ? $_POST["input1"] : "";
            $input_pw = $_POST["input2"] ? $_POST["input2"] : "";

            // pw filtering
            if (preg_match("/[a-zA-Z]/", $input_pw)) {
              echo "alphabet in the pw :(";
            }
            else{
              $name = preg_replace("/nyang/i", "", $input_name);
              $pw = preg_replace("/\d*\@\d{2,3}(31)+[^0-8\"]\!/", "d4y0r50ng", $input_pw);
              
              if ($name === "dnyang0310" && $pw === "d4y0r50ng+1+13") {
                echo '<h4>Step 2 : Almost done...</h4><div class="door_box"><div class="door_black"></div><div class="door"><div class="door_cir"></div></div></div>';
```

basically what happens here is that our input in modifyed using regex so we have to bypass this.\
our username has to be `dnnyangyang0310` because the first `nyang` will be removed, and the password has to be `@12319!+1+13` because the `@12319!` will be replaced with `d4y0r50ng`

after using those creds we get to step 2 where we can input a command :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112124413.png)\
is we try `cat ../dream/flag.txt` we get a error\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112124456.png)\
so we use `cat ../dream/*.txt` to get the flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112124553.png)\
ez
