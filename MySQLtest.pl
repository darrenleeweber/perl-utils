#!perl

use DBI;
use strict;

$::driver = "mysql";
$::database = "mysql";
$::hostname = "localhost";
$::port = "3306";

$::dsn = "DBI:$::driver:database=$::database;host=$::hostname;port=$::port";

$::user = "root";
$::password = "potsy1969";

#$::dbh = DBI->connect($::dsn, $::user, $::password, { RaiseError => 1, AutoCommit => 0 });
$::dbh = DBI->connect($::dsn, $::user, $::password, { RaiseError => 1 } );

if($::dbh){
    $::rc  = $::dbh->disconnect;
    print "rc => $::rc\n";
}  

exit;
