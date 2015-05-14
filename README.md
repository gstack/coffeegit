# Coffeegit

A simple Express / MYSQL / Coffeescript Git repository management system.

Configure with config.cson, run install.sql on your database, setup the application with Nginx or Apache (doesn't matter really, though I much prefer / recommend nginx for speed), configure cgi-bin (so cgit gets executed as CGI, presently the repo file viewer isn't handled by this script.) - oh and don't forget to `npm install` !

Made in 24 hours sometime early-on in 2015, made in part as a neat and simple way to demonstrate coding a sysadmin web app in express coffeescript & node js.
