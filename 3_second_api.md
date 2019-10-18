[< Previous step: Create your first API](./2_first_api.md)

## Put some code in your API

### Before starting

If something goes wrong and if you need debug information, please refer to the [debug you app section](7_debug.md).

### Where is the code?

The code of our API is in the plugin 'main' directory.

``` bash
# As mfserv user
cd ~/hello/main
ls
```

You should see a _wsgi.py_ file. The default bootstrap template for mfserv is in Python WSGI. But you could have choosen other templates like python-django or nodejs.

To show you that MetWork can work with several languages, we are not going to edit this plugin. We are going to create another plugin in nodejs.

``` bash
# As mfserv user
bootstrap_plugin.py list
```

This command outputs the list of available plugin templates. Let's choose node.

``` bash
# As mfserv user
cd ~
bootstrap_plugin.py create --template=node tutorial
```

Press enter several times to accept default values.

And then launch your new plugin.

``` bash
cd tutorial
make develop
```

If you open `http://localhost:18868/tutorial` in your browser, you should see a 'Hello World tutorial' page.

The node template has bootstraped a nodejs express application. Let's edit the code to make it more interesting.

In `~/tutorial/tutorial/server.js`, Replace the line:

``` js
      res.send('Hello World tutorial!)
```

by:
``` js
      var entry = req.param('q')
      res.send('Hello World tutorial! You have entered: ' + entry)
```

Now open `http://localhost:18868/tutorial?q=foobar`

This should output in your browser: 'Hello World tutorial! You have entered: foobar'.

[Next step: Monitor your application >](./4_monitoring.md)