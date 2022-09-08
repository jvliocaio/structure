# Structure - a simple bash script to start services.

This script is designed to start a new service. Its function is simple, create the entire structure of folders and files and up the service's Docker container.

Now an explanation on how to use it. The only external commands present in the script are from Docker.

##

##### To show all options 
```
$ ./service_structure.sh --help
```
##### The message will be this
``` 
$ service_structure.sh - [MENU]

  -------------------------------------------------------
  | INFOS:                                              |
  |    --help : Help Menu                               |
  |    --about : Version && Maintener                   |
  -------------------------------------------------------
  | USAGE (--back/--front):                             |
  |    ./service_structure.sh --frontend 8080           |
  -------------------------------------------------------
  | FUNCTIONS:                                          |
  |    --back : Don't install npm (to run VueJs)        |
  |    --front : Install npm (to run VueJs)             |
  -------------------------------------------------------
```

##### When you choose an option (back || front) and inform the ports, the script starts to run and creates all the necessary structure 
```
$ ./service_structure.sh --back || --front
```
##### On the screen, you will see the step by step happening along with the "echos" that tell you which step you are in.

``` 
Creating directories and files 


Running container 

``` 

It's a simple script but it saves a good few minutes.
