#!/usr/bin/env perl

# Copyright (C) 2012  Joshua Hoblitt

use strict;
use warnings;

use lib qw( ./lib ./t );

use Test::More tests => 28;

use File::Temp qw( tempdir );
use Test::Cmd;

my $cmd = Test::Cmd->new(prog => "$^X ppwent", workdir => '');
isa_ok($cmd, 'Test::Cmd');

# missing required options

{
    $cmd->run(args => "");
    cmd_output($cmd, 3, qr/^$/, qr/^\Qrequired option(s):/);
}

{
    $cmd->run(args => "--users /tmp/foo");
    cmd_output($cmd, 3, qr/^$/, qr/^\Qrequired option(s):/);
}

{
    $cmd->run(args => "--groups /tmp/foo");
    cmd_output($cmd, 3, qr/^$/, qr/^\Qrequired option(s):/);
}

# unknown options

{
    $cmd->run(args => "--users /tmp/foo --groups /tmp/foo --asdf");
    cmd_output($cmd, 2, qr/^$/, qr/^\QUnknown option:/);
}

# left overs in @ARGV
{
    $cmd->run(args => "--users /tmp/foo --groups /tmp/foo asdf");
    cmd_output($cmd, 4, qr/^$/, qr/^\Qunknown argument(s)/);
}

# file doesn't exist 
{
    my $dir = tempdir( CLEANUP => 1 );
    my $tmp_valid   = File::Temp->new( DIR => $dir );

    $cmd->run(args => "--users /tmp/foo --groups $tmp_valid");
    cmd_output($cmd, 5, qr/^$/, qr/^--users.+: file does not exist/);
}

{
    my $dir = tempdir( CLEANUP => 1 );
    my $tmp_valid   = File::Temp->new( DIR => $dir );

    $cmd->run(args => "--users $tmp_valid --groups /tmp/foo");
    cmd_output($cmd, 7, qr/^$/, qr/^--groups.+: file does not exist/);
}


# path is not a plain file
{
    my $dir = tempdir( CLEANUP => 1 );
    my $tmp_valid   = File::Temp->new( DIR => $dir );

    $cmd->run(args => "--users $dir --groups $tmp_valid" );
    cmd_output($cmd, 6, qr/^$/, qr/^--users.+: file is not a plain file/);
}

{
    my $dir = tempdir( CLEANUP => 1 );
    my $tmp_valid   = File::Temp->new( DIR => $dir );

    $cmd->run(args => "--users $tmp_valid --groups $dir ");
    cmd_output($cmd, 8, qr/^$/, qr/^--groups.+: file is not a plain file/);
}

sub cmd_output {
    my ($cmd, $exit, $stdout, $stderr) = @_;

    is($? >> 8, $exit, "error code is: $exit");
    like($cmd->stdout, $stdout, "stdout string");
    like($cmd->stderr, $stderr, "stderr string");
}
