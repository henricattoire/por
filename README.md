`por`
================

This repository contains `por`, one of two utility programs that
collectively replace [`find`][find]. [`walk`][walk] recursively walks the directories
specified on the command line (or the current directory, if none is specified),
printing each file path. `por` (“perl or”) reads file paths from standard
input; for each path, it evaluates the arguments as a Perl file test, passing the
path as an argument and printing the path if the test succeeds.
For example, instead of saying

    find . -type f -name \*foo\*

you can say

    walk | grep foo | por -f

If your filenames might contain newlines, you can say

    walk -0 | grep -z foo | por -0 -f

If you supply more than one test, `por` chains them together using logical **or** (hence the name). 
But in some situations I found that using logical **and** to chain tests is better, so I added a -

    walk | por --and -f -x

`and` option to trigger `por` into using logical **and** (and not logical **or**).


[find]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/find.html
[walk]: https://github.com/google/walk

Performance
-----------

Because `find` implements its predicates in-process, it performs much better
than both `por` and `sor`. But `sor` is just awful, even when handling relatively
small amounts of data. Wanting to improve the speed of `sor` while still retaining
its flexibility ([reflection][reflection]), I decided to go with Perl.


    $ time find /usr -type f >/dev/null
    
    real    0m10.973s
    user	0m0.382s
    sys     0m6.572s
    
    $ time walk /usr | sor 'test -f' >/dev/null
    
    real    8m30.253s
    user    2m15.737s
    sys     3m30.890s
    
    $ time walk /usr | por -f >/dev/null
    
    real    0m29.429s
    user	0m8.939s
    sys     0m19.172s
    
[reflection]: https://en.wikipedia.org/wiki/Reflective_programming

History
-------

`walk` and `sor` were originally written for [Plan 9 from Bell Labs][] by
[Dan Cross][]. The [original source][] is available.

[Dan Cross]: http://pub.gajendra.net/about
[Plan 9 from Bell Labs]: https://web.archive.org/web/20170601064029/http://plan9.bell-labs.com/plan9/index.html
[original source]: https://web.archive.org/web/http://plan9.bell-labs.com/sources/contrib/cross/
