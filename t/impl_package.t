use strict;
use Test::More;
use Class::Minion ();

package Counter::Impl;

our %__Meta = (
    has  => {
        count => { default => 0 },
    }, 
);

sub next {
    my ($self) = @_;

    $self->{$$}{count}++;
}

package Counter;

our %__Meta = (
    interface => [qw(next)],
    implementation => 'Counter::Impl',
);
Class::Minion->minionize;

package main;

my $counter = Counter->new;

is($counter->next, 0);
is($counter->next, 1);
is($counter->next, 2);
done_testing();
