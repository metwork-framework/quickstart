[< Create a database](./5_database.md)

## Tasks triggered by files

### What is mfdata?

We are going to showcase some possibilities of the mfdata MetWork module. But what is mfdata?

__Example of use case:__ Imagine that you have files that are provided to your app by ftp. For instance, images sent by another app. Imagine that you want to trigger a task each time an image arrives. This task would convert the image to jpeg and move it to another directory.

__Other example of use case:__ A third party app exports data every night in csv format and put it in a directory. When this csv file arrives, you want to trigger a task to insert it in a database.

With mfdata, you can manage these kind of worklows. All you have to do is configuring the events that will trigger your app (most of the time it will be when a file arrives), and mfdata will launch your app when the events occur.

### What are we going to do?

We are going to create a service that will do the following tasks:

1. monitor 'incoming' directory
2. each time a file arrives in this directory, insert its content in our database
3. delete the file

The MetWork mfdata module deals automatically with the points 1 and 3 above. The only thing we have to do will be to write the code for inserting the file content in the database.

### Installation of mfdata

Login as root user, and install mfdata:

``` bash
# As root user
yum -y install metwork-mfdata
```

Start the services:

``` bash
service metwork start
```

### Create your plugin

Let's create a mfdata plugin and launch it.

``` bash
# Login as mfdata user
su - mfdata
# Create your plugin with default template
bootstrap_plugin.py create tutodata
# Launch your plugin in dev mode
cd tutodata
make develop
```

### Create a dummy file

Let's create a dummy txt file, to have something to insert in the database. As our 'records' table contains only one column, this file will be very simple.

Create the file `~/myfile.txt` and put the following content inside:

``` csv
foo
bar
```

### First try

For now, our plugin doesn't do anything. If we copy the txt file in the 'incoming' directory, we will see that it will be deleted, and nothing will happen. That's because mfdata already monitors the 'incoming' directory and consumes the incoming files.

``` bash
# As mfdata user
cd ~
cp myfile.txt ~/var/in/incoming/
ll ~/var/in/incoming
# Should output "total 0"
```

### Modify the template plugin to process our file

The default template is in python 3. First, we will need to install a python library to be able to connect to our postgresql database. MetWork deals automatically with the requirements. All you have to do is to tell it what requirements you need. We will use the 'psycopg2' library.

Edit `~/tutodata/virtualenv_sources/requirements-to-freeze.txt`, and add the following line:

``` txt
# python3 requirements.txt file
...
psycopg2
```

Because psycopg2 is a python wrapper upon a C library, we also need to load the C libpq library. Fortunately, it's already bundled in MetWork.

Edit `~/tutodata/.layerapi2_dependencies` and add:

``` bash
...
scientific_core@mfext
```

For more details on how MetWork deals with dependencies, refer to the mfext module documentation.

Now, rebuild the environment:
``` bash
# As mfdata user
cd ~/tutodata
make develop
```

If you get an error, it's probably because you don't have gcc compiler. If so, install it like this and rebuild your plugin:

``` bash
# As root user
su -
yum -y install gcc
# go back to user mfdata
exit
# rebuild your plugin
make superclean # We use the 'superclean' target to remove junk that has been created by the previous failed build
```

Now, we are going to modify the plugin code to achieve our goal: insert the file contents in the database when a file arrives. Replace the content of ~/tutodata/main.py by:

``` python
#!/usr/bin/env python3

from acquisition import AcquisitionStep
import psycopg2

class TutodataMainStep(
        AcquisitionStep):

    plugin_name = "tutodata"
    step_name = "main"

    def init(self):
        # Connect to the database
        self.conn = psycopg2.connect(dbname='plugin_foo', user='plugin_foo', host='localhost' ,password='plugin_foo', port=7432)
        self.cur = self.conn.cursor()

    def process(self, xaf):
        self.info("process for file %s" % xaf.filepath)
        # Process the incoming file and insert it into the database
        with open(xaf.filepath, 'r') as f:
            content = f.readlines()
            for line in content:
                line = line.strip()
                self.cur.execute("INSERT INTO records VALUES (%s)", (line,))
            self.conn.commit()
        return True


if __name__ == "__main__":
    x = TutodataMainStep()
    x.run()
```

### Configure the plugin to receive files

One last thing we have to do is to configure the plugin routing rule to accept incoming files.

Edit `~/tutodata/config.ini`, and modify the 'switch_logical_condition' parameter to set it to True:

``` ini
...
switch_logical_condition = True
...
```

### Check that everything works

Let's check that it works! Put the file to mfdata incoming directory, and its contents should be inserted into the database.

``` bash
# As mfdata user
cd ~
cp myfile.txt ~/var/in/incoming/
```

You can now check that you get records in your database:

``` bash
# As mfbase user
su - mfbase
psql -U plugin_foo -h localhost -p 7432 plugin_foo
SELECT * FROM records;
\q
```

[Next step: Debug your app >](./7_debug.md)