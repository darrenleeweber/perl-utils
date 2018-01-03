#!/usr/local/bin/perl
require "sub_error.lib";

open (FILE, "nofile.txt") || &ErrorMessage("Can't open file");
