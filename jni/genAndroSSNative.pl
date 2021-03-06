#!/usr/bin/perl

use warnings;
use strict;

my $package_name = "net.tedstein.AndroSS";
my $header = <<END
/*
 * DO NOT EDIT THIS FILE!
 * AndroSSNative.java is automatically generated from the AndroSS binary by
 * genAndroSSNative.pl.
 */

package $package_name;

public class AndroSSNative {
    public static final String native64 = 
END
;
my $footer = <<END
}
END
;

my($last_chunk, $current_chunk);



# Assume we have a base64 binary in our path to do the conversion. Maybe someday
# do it inside this script.
open(B64, "base64 -w 0 ../obj/local/armeabi/AndroSS |") or
    die("Couldn't open pipe to base64: $!");
open(JAVA, ">", "../src/net/tedstein/AndroSS/AndroSSNative.java") or
    die("Couldn't open output Java file: $!");

print(JAVA $header);

# Format and copy the base64 output one 80-char line at a time. We need to
# format the final chunk differently, so operate one chunk behind while(read).
read(B64, $last_chunk, 68);
while (read(B64, $current_chunk, 68) > 0) {
    printf(JAVA "        \"$last_chunk\" +\n");
    $last_chunk = $current_chunk;
}
# Get the last of it.
printf(JAVA "        \"$last_chunk\";\n");
print(JAVA $footer);

