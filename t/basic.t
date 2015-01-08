use strict;
use Test::Most tests => 9;
use Class::Minion ();

my %Class = (
    interface => [qw(next)],
    implementation => {
        has  => {
            count => { default => 0 },
        }, 
        methods => {
            next => sub {
                my ($self) = @_;

                $self->{$$}{count}++;
            }
        },
    },
);

my $counter = Class::Minion->minionize(\%Class)->new;

is($counter->next, 0);
is($counter->next, 1);
is($counter->next, 2);

throws_ok { $counter->new } qr/Can't locate object method "new"/;

# Now create a named class

my %Named_class = (
    name => 'Counter',
    interface => [qw(next)],
    implementation => {
        has  => {
            count => { default => 0 },
        }, 
        methods => {
            next => sub {
                my ($self) = @_;

                $self->{$$}{count}++;
            }
        },
    }, 
);
Class::Minion->minionize(\%Named_class);
my $counter2 = Counter->new;

isa_ok($counter2, 'Counter::__Class::Minion');
is($counter2->next, 0);
is($counter2->next, 1);
is($counter2->next, 2);
throws_ok { Counter->next } qr/Can't locate object method "next"/;
