---
title: n8n
date: 2026-01-04T12:00:00+03:00
draft: false
---
def n8n: open-source software used to automation 
version 0.211.0 through 1.120.3 contains a RCE vuln , exploaited it can enable attackes to exectue system level commands 

Tehnical Background : 
i gonna be very short here the full information can be found on the link 

cause of some pourly designed exprssion evaluator , we can bypass and juggle with the escalation tehcnics to reach executing system commands via  `child_process`



