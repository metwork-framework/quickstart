## Debug your app

You might have noticed that MetWork is configured in production mode by default. That implies that it does not display any debug information to the end user.

Here is an easy way to get debug information if you need it.

If you want to debug a mfserv plugin (the procedure is similar for mfdata and other MetWork modules):

1. Login as mfserv user
2. Look inside the `~/log` directory

To get a continuous display of logs, including errors:

``` bash
# Login as mfserv user
su - mfserv
# Go to log directory
cd ~/log
# Print logs continuously
tail -f *
```

[Next step: Where to go next? >](./8_next.md)