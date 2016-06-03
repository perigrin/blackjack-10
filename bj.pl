use 5.14.1;
use IO::Prompt;
use List::Util qw(shuffle);

sub deal {
    state $shoe = [
        shuffle map {
            my $v = $_;
            map {"$v$_"} qw(❤ ◆ ♣ ♠)
            } ( 2 .. 10, qw( J Q K A ) ) x 6
    ];
    push $_[0], splice( $shoe, 0, $_[1] );
    $_[0];
}

sub value {
    my $v;
    for ( local @_ = @{ shift() } ) {
        s/[ ❤ ◆ ♣ ♠ ]//;
        s/[JQK]/10/;
        $v < 11 ? s/A/11/ : s/A/1/;
        $v += $_;
    }
    $v;
}

sub show { say sprintf "%s (%i)", "$_[0] @{$_[1]}", value( $_[1] ) }

my ( $player, $dealer ) = map { deal( $_, 2 ) } ( [], [] );

while ( prompt( "@$player\nHit? ", '-tyn1' ) ) {
    if ( value( deal( $player, 1 ) ) > 21 ) {
        show( "Busted!", $player );
        exit;
    }
}

while ( say("Dealer @$dealer") && value($dealer) < 17 ) {
    if ( value( deal( $dealer, 1 ) ) > 21 ) {
        show( "Dealer busted!", $dealer );
        exit;
    }
}

value($player) >= value($dealer)
    ? show( "Player wins", $player )
    : show( "Dealer wins", $dealer );

__END__

