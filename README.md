# PROJECT AUCTION #


## RUNNING THE PROJECT ##

After checking out the project, you should be able to run it by installing
padrino then using the start command. If you run into problems, take a look
at the full [Padrino install guide][1]

    sudo gem install padrino
    cd auction
    bundle install
    padrino start

The application should now be available at [http://localhost:3000](http://localhost:3000)
A development database URL is currently hard-coded into the application hosted
by MongoHQ, so for the time-being you don't need to worry about running your
own Mongo instance (unless you want to).

## CREATING A NEW USER ##

To create a new user:

    padrino rake seed

You will be prompted for a username and password (the rest of the user values
will be stubbed in for you -- you can change them from the application after
logging in).


[1]: http://www.padrinorb.com/guides/installation
