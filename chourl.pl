use strict;
use Irssi;

use LWP;
use URI::Escape;

use vars qw($VERSION %IRSSI);

$VERSION = '1.5';
%IRSSI = (
	authors => 'Lennart Takanen',
	contact => 'godzax@bombsquad.org',
	name => 'cho',
	description => 'Shortens long urls using cho.fi',
	license => 'WTFPL'
);

#Bound to command /cho
sub cho {
	my ($msg, $server, $witem) = @_;

	#Split the message at every whitespace sequence. Unfortunately, tabs etc. are lost.
	my @words = split(/\s+/, $msg);

	my @newmessage = ();

	my $fails = 0;
	my $urlified;

	if (scalar(@words) == 1) {
		#Single word mode, don't even match against url regex
		$urlified = urlify(@words[0]);
	} else {

		foreach my $word (@words) {
			#What a f-ing stupid regex
			#                 protocol          wwww    ip                             /localhost/domain                              tld                                                  port      request/param/fragment
			if ($word =~ m/(((https?|ftp):\/\/)|www\.)(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)|localhost|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|net|org|info|biz|gov|name|edu|onion|[a-zA-Z][a-zA-Z]))(:[0-9]+)?((\/|\?)[^ "]*[^ ,;\.:">)])?/) {
				#Try to shorten the detected url
				my $response = urlify($word);

				if ($response) {
					push(@newmessage, $response);
				} else {
					$fails += 1;
					push(@newmessage, $word);
				}
			} else {
				push(@newmessage, $word);
			}
		}

		$urlified = join(' ', @newmessage);
	}


	#If the command was called from a channel or privmsg, send the results there, otherwise print it for the user
	if ($witem && ($witem->{type} eq 'CHANNEL' || $witem->{type} eq 'QUERY')) {
		$witem->command('MSG ' . $witem->{name} . ' ' . $urlified);
	} else {
		Irssi::print("cho: $urlified", MSGLEVEL_CLIENTCRAP);
	}

	if ($fails) {
		Irssi::print("cho: $fails requests failed!", MSGLEVEL_CLIENTCRAP);
	}
}

sub urlify {
	my $url = shift;
	
	#If the url doesn't contain the protocol, assume http
	if (!($url =~ m/^[a-zA-Z]+:\/\/.*/)) {
		$url = "http://" . $url;
	}

	$url = uri_escape($url);

	my $cho_get = LWP::UserAgent->new;
	$cho_get->agent("irssi-cho" . $VERSION);
	
	my $response = $cho_get->get("https://cho.fi/?create=$url");

	if ($response->is_success) {
		return 'https://cho.fi/' . $response->content;
	} else {
		return '';
	}
}


Irssi::command_bind('cho', 'cho');
