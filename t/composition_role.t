use strict;
use Test::Lib;
use Test::Most;
use AlphabetRole;
use Class::Minion ();

{
    package AlphabetImpl;

    our %__Meta = (
        roles => [qw( AlphabetRole )],
    );
}

{
    package Alphabet;

    our %__Meta = (
        interface => [qw( alpha bravo charlie delta )],
        implementation => 'AlphabetImpl',
    );
    Class::Minion->minionize;
}

{
    package KeyboardImpl;
    our %__Meta = (
        has => { 
            alphabet => {
                handles  => 'AlphabetRole',
                init_arg => 'alphabet' 
            }
        }
    );
}

{
    package Keyboard;

    our %__Meta = (
        interface => [qw( alpha bravo charlie delta )],
        construct_with => {
            alphabet => { },
        },
        implementation => 'KeyboardImpl',
    );
    Class::Minion->minionize();
}

package main;

my $kb = Keyboard->new(alphabet => Alphabet->new);
can_ok($kb, qw( alpha bravo charlie delta ));
is($kb->alpha,   'alpha');
is($kb->bravo,   'bravo');
is($kb->charlie, 'charlie');
is($kb->delta,   'delta');

done_testing();
