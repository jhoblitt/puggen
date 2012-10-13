# NAME

puggen - generate puppet user/group resources from system database

# SYNOPSIS

    puggen --users <file name> --groups <file name> [--class_name my::users]

# DESCRIPTION

This utility generates the text of a puppet class containing virtual user,
group, and ssh\_authorized\_key resources that are unrealized.  It is
intended to be used as a base class for other classes which then realize
these resources.  A defined type, user\_setup, is provided to help realize
all of the resources associated with a user.  All users have a user\_setup
type declared in the generated base class with ensure => absent set such
that if a resources are realized for a user in a subclass and then
user\_setup declaration is subsequently removed, so are all of the
resources associated with that user.

    class my::users::dev inherits my::users {
      User_setup[jrandom]{ ensure => present }

      # my::users does not have this user included in the wheel group
      User['jrandom']{
          groups => ['wheel'],
      }

    }

# EXAMPLE

    sudo ./puggen --users ../users.txt --groups ../groups.txt > users.pp

# GOTCHAS

This program \*must\* be run as root in order to gather the hashed password
entries for the user resources.  This is very likely also the case for
gathering ssh public keys out of user directories.

# CREDITS

Just me, myself, and I.

# SUPPORT

Please contact the author directly via e-mail.

# AUTHOR

Joshua Hoblitt <jhoblitt@cpan.org>

# COPYRIGHT

Copyright (C) 2012  Joshua Hoblitt

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

The full text of the license can be found in the LICENSE file included with
this module or in the [perlgpl](http://search.cpan.org/perldoc?perlgpl) Pod included with Perl 5.8.1 or later.

# SEE ALSO

[User::pwent](http://search.cpan.org/perldoc?User::pwent), [User::grent](http://search.cpan.org/perldoc?User::grent), [Template](http://search.cpan.org/perldoc?Template), [Net::SSH::AuthorizedKey](http://search.cpan.org/perldoc?Net::SSH::AuthorizedKey)
