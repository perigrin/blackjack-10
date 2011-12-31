use 5.14.1;
use IO::Prompt;
use List::Util qw(shuffle);

sub deal(+$) {
    state $shoe = [                          # we will only need one Shoe of decks, so use a state variable
        shuffle map {                        # shuffle the decks together
            my $v = $_;                      # capture the card value
            map {"$v$_"} qw(❤ ◆ ♣ ♠)         # attach the Suit
            } ( 2 .. 10, qw( J Q K A ) ) x 6 # for values 2-10, J Q K A ... across 6 decks 
    ];
    push $_[0], shift $shoe for ( 1 .. $_[1] ); # deal the cards by pushing 1..$n cards into the hand 
    $_[0]; # return the hand
}

sub value {
    my $v;
    for ( local @_ = @{ shift() } ) { # for each card in a local copy of the hand
        s/[ ❤ ◆ ♣ ♠ ]//;              # strip the suit
        s/[JQK]/10/;                  # change face cards to 10
        $v < 11 ? s/A/11/ : s/A/1/;   # change Aces to 1 or 11 based on which looks best
        $v += $_;                     # add it to the current value
    }
    $v; # return the value
}
sub show($+) { say sprintf "%s (%i)", "$_[0] @{$_[1]}", value( $_[1] ) }

my ( $player, $dealer ) = map { deal( $_, 2 ) } ( [], [] ); # deal two cards to the player and the dealer

while ( prompt( "@$player\nHit? ", '-tyn1' ) ) { # ask the player if they wanna hit or stay
    # deal them a new card, if the value is over 21 tell them they busted
    show( "Busted!", $player ) && exit if value( deal( $player, 1 ) ) > 21;
}
# while the dealer is less than 17
while ( say("Dealer @$dealer") && value($dealer) < 17 ) {
    # draw a card, if the value is over 21 say the Dealer busted
    show( "Dealer busted!", $dealer ) && exit
        if value( deal( $dealer, 1 ) ) > 21;
}
# figure out who won
value($player) > value($dealer)
    ? show( "Player wins", $player )
    : show( "Dealer wins", $dealer );

__END__

