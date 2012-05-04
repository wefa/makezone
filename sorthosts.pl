#!/usr/bin/env perl


# sorthosts.pl - sort a hosts file
# Copyright (C) 2010  Rudolf Polzer
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


# /etc/hosts sorting script
#
# Author:	Rudolf Polzer
#
# 1.0	initial version				January 2010


use strict;
use warnings;

sub parse_v4 {
	my ($addr) = @_;
	my (@addr);

	return ()
		if $addr =~ /^$|[^0-9.]/;

	@addr = split /\./, $addr;
	push @addr, 0
		while @addr < 4;
	&error("invalid ipv4 address: $addr")
		if @addr != 4;
	if ( grep { $_ < 0 || $_ > 255 } @addr ) {
		&error("IPv4 address contains component with value greater than ffff.");
		return;
	}
	return @addr;
}

sub parse_v6 {
	my ($addr) = @_;
	my (@addr);

	return ()
		if $addr =~ /^$|[^0-9a-fA-F:]/;

	if ( $addr =~ /([0-9a-fA-F:]*)::([0-9a-fA-F:]*)/ ) {
		my ($addr_pre)  = $1;
		my ($addr_post) = $2;
		my (@addr_pre)  = map { hex $_ } split /:/, $addr_pre;
		my (@addr_post) = map { hex $_ } split /:/, $addr_post;
		return ()
			if @addr_pre + @addr_post > 8;
		@addr = ( @addr_pre, (0) x ( 8 - @addr_pre - @addr_post ), @addr_post );
	}
	else {
		@addr = map { hex $_ } split /:/, $addr;
		return ()
			if @addr != 8;
	}
	if ( grep { $_ < 0 || $_ > 65535 } @addr ) {
		return ()
	}
	return @addr;
}

my @data = ();
while(<>)
{
	chomp;
	my $addr = [$_ =~ /^(\S*)/]->[0];
	if((my @addr = parse_v4 $addr))
	{
		push @data, [[4, @addr], $_];
	}
	elsif((@addr = parse_v6 $addr))
	{
		push @data, [[6, @addr], $_];
	}
	else
	{
		print "$_\n";
	}
}
sub acmp($$);
sub acmp($$)
{
	my ($a, $b) = @_;
	my ($afirst, $arest) = ($a->[0], [@{$a}[1..@$a-1]]);
	my ($bfirst, $brest) = ($b->[0], [@{$b}[1..@$b-1]]);
	return 0
		if not defined $afirst and not defined $bfirst;
	my $r = ((defined $afirst) <=> (defined $bfirst));
	return $r
		if $r;
	$r = ($afirst <=> $bfirst);
	return $r
		if $r;
	return acmp $arest, $brest;
}
for(sort { acmp $a->[0], $b->[0] } @data)
{
	print "$_->[1]\n";
}
