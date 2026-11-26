---
created: 2026-11-12
tags:
  - note
  - journal
  - dreamhack
  - cyberStuff
title: Dreamhack > ex-reg-ex
date: 2026-11-12T09:48:52.203Z
lastmod: 2026-11-12T09:59:05.773Z
---
link : https://dreamhack.io/wargame/challenges/834

the webserver displayes the following :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112115007.png)\
at first i tried to obtain the flag using reg ex without looking at the app.py code with the following payload :

```regex
SpongeBoB@DH\{[A-Za-z][A-Za-z][A-Za-z][A-Za-z][A-Za-z]\}
```

it did not work , i thought that the flag should be displayed using a regex expression\
then i inspected the app.py code , the interesting part is bellow :

```python
try:
    FLAG = open("./flag.txt", "r").read()      
except:
    FLAG = "[**FLAG**]"

@app.route("/", methods = ["GET", "POST"])
def index():
    input_val = ""
    if request.method == "POST":
        input_val = request.form.get("input_val", "")
        m = re.match(r'dr\w{5,7}e\d+am@[a-z]{3,7}\.\w+', input_val)
        if m:
            return render_template("index.html", pre_txt=input_val, flag=FLAG)
    return render_template("index.html", pre_txt=input_val, flag='?')
```

the input has to match `'dr\w{5,7}e\d+am@[a-z]{3,7}\.\w+'` which translated from regex means:

* `dr`: Must start with 'dr'
* `\w{5,7}`: 5~7 alphabet/number characters
* `e`: Character 'e'
* `\d+`: 1 or more numbers
* `am@`: Text 'am@'
* `[a-z]{3,7}`: 3~7 lowercase letters
* `\.`: Period (.) symbol
* `\w+`: 1 or more letters/numbers

so if we input anything like : `drcccccce3am@dihh.smth` we get the flag:\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112115904.png)
