# A 10 Line Black Jack

So the file here is based on wanting a 10 line version of Black Jack based upon
the answers to a question on [stack overflow][1]
here is the 10 line version

UPDATE: I've updated this code to reflect the changes in how I'd write it now as opposed to 13 years ago. I take advantage of the changes in Perl 5.36.1, like subroutine signatures. This version splits out building the shoe, and includes showing the dealer's initial hand … so more features, but the same number of lines.

```perl
use 5.36.1; use IO::Prompt qw(prompt); use List::Util qw(reduce shuffle); use Set::Product qw(product);
sub new_shoe($n=6) { my @d = (); product { push @d, "@_" } [ ( 2 .. 10, qw( J Q K A ) ) ], [qw(❤ ◆ ♣ ♠)]; shuffle( (@d) x $n ); }
sub deal($hand,$n) { state @shoe = new_shoe(); push @$hand, splice( @shoe, 0, $n ); $hand; }
sub value($hand) { reduce { $a += ( "$b" ne 'A' ? $b : $a < 11 ? 1 : 11 ) } map { s/[ ❤ ◆ ♣ ♠ ]//g; s/[JQK]/10/r; } [@$hand]->@*; }
sub show($msg,$hand) { printf "%s (%i)\n", "$msg @$hand", value($hand); exit 0; }
my ($player, $dealer) = map deal( $_, 2 ), ( [], [] );
say "Dealer shows: $dealer->[0]";
while ( prompt( "@$player\nHit? ", '-tyn1' ) ) { show( "Busted!", $player ) if value( deal( $player, 1 ) ) > 21; }
while ( say("Dealer @$dealer") && value($dealer) < 17 ) { show( "Busted!", $dealer ) if value( deal( $dealer, 1 ) ) > 21; }
value($player) >= value($dealer) ? show( "Player wins", $player ) : show( "Dealer wins", $dealer );
```

# Spot the Bug

There is a subtle bug in the logic (plus probably a thousand other unsubtle
ones I have no clue about). I would love it if someone could fix it.

[1]: http://stackoverflow.com/questions/811074/what-is-the-coolest-thing-you-can-do-in-10-lines-of-simple-code-help-me-inspir
