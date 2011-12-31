# A 10 Line Black Jack

So the file here is based on wanting a 10 line version of Black Jack based upon
the answers to a question on [stack overflow][1]
here is the 10 line version

    use 5.14.1; use IO::Prompt; use List::Util qw(shuffle);
    sub deal(+$) { state $shoe = [ shuffle map { my $c = $_; map {"$c$_"} qw(❤ ◆ ♣ ♠) } ( 2 .. 10, qw( J Q K A ) ) x 6 ]; push $_[0], shift $shoe for ( 1 .. $_[1] ); $_[0]; }
    sub value { my $v; for ( local @_ = @{ shift() } ) { s/[ ❤ ◆ ♣ ♠ ]//; s/[JQK]/10/; $v < 11 ? s/A/11/ : s/A/1/; $v += $_; } $v; }
    sub show($+) { say sprintf "%s (%i)", "$_[0] @{$_[1]}", value( $_[1] ) }
    my ( $player, $dealer ) = map { deal( $_, 2 ) } ( [], [] );
    while ( prompt( "@$player\nHit? ", '-tyn1' ) ) { show( "Busted!", $player ) && exit if value( deal( $player, 1 ) ) > 21;}
    while ( say("Dealer @$dealer") && value($dealer) < 17 ) { show( "Dealer busted!", $dealer ) && exit if value( deal( $dealer, 1 ) ) > 21; }
    value($player) > value($dealer) ? show( "Player wins", $player ) : show( "Dealer wins", $dealer );

# Spot the Bug

There is a subtle bug in teh logic (plus probably a thousand other unsubtle
ones I have no clue about). I would love it if someone could fix it.

[1]: http://stackoverflow.com/questions/811074/what-is-the-coolest-thing-you-can-do-in-10-lines-of-simple-code-help-me-inspir