use 5.36.1;
use IO::Prompt   qw( prompt );
use List::Util   qw( reduce shuffle );
use Set::Product qw( product );

sub new_shoe( $n = 6 ) {
    my @d = ();
    product { push @d, "@_" } [ ( 2 .. 10, qw( J Q K A ) ) ], [qw(❤ ◆ ♣ ♠)];
    shuffle( (@d) x $n );
}

sub deal( $hand, $n ) {
    state @shoe = new_shoe();
    push @$hand, splice( @shoe, 0, $n );
    $hand;
}

sub value($hand) {
    reduce { $a += ( "$b" ne 'A' ? $b : $a < 11 ? 1 : 11 ) }
    map { s/[ ❤ ◆ ♣ ♠ ]//g; s/[JQK]/10/r; } [@$hand]->@*;
}

sub show( $msg, $hand ) {
    printf "%s (%i)\n", "$msg @$hand", value($hand);
    exit 0;
}

my ( $player, $dealer ) = map deal( $_, 2 ), ( [], [] );

say "Dealer shows: $dealer->[0]";

while ( prompt( "@$player\nHit? ", '-tyn1' ) ) {
    show( "Busted!", $player ) if value( deal( $player, 1 ) ) > 21;
}

while ( say("Dealer @$dealer") && value($dealer) < 17 ) {
    show( "Busted!", $dealer ) if value( deal( $dealer, 1 ) ) > 21;
}

value($player) >= value($dealer)
  ? show( "Player wins", $player )
  : show( "Dealer wins", $dealer );

__END__
