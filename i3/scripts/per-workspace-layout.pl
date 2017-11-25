use strict;
use warnings;
use AnyEvent;
use AnyEvent::I3;
use v5.10;

my %layouts = (
    '1' => 'tabbed',
    '2' => 'tabbed',
);

my $i3 = i3();

die "Could not connect to i3: $!" unless $i3->connect->recv();

die "Could not subscribe to the workspace event: $!" unless
    $i3->subscribe({
        workspace => sub {
            my ($msg) = @_;
            return unless $msg->{change} eq 'focus';
            die "Your version of i3 is too old. You need >= v4.4"
                unless exists($msg->{current});
            my $ws = $msg->{current};

            # If the workspace already has children, don’t change the layout.
            return unless scalar @{$ws->{nodes}} == 0;

            my $name = $ws->{name};
            my $con_id = $ws->{id};

            return unless exists $layouts{$name};

            $i3->command(qq|[con_id="$con_id"] layout | . $layouts{$name});
        },
        _error => sub {
            my ($msg) = @_;
            say "AnyEvent::I3 error: $msg";
            say "Exiting.";
            exit 1;
        },
    })->recv->{success};

# Run forever.
AnyEvent->condvar->recv
