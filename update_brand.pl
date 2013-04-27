#!/usr/bin/perl
use strict;
use LWP;
use JSON;

#
# This script updates Brands from the BigCommerce API, using ID.
# 
print "\nWhich Brand ID to update? ";
my $brand_id = <STDIN>;
chomp($brand_id);

# Global
my $uri = 'https://store-bwvr466.mybigcommerce.com/api/v2/brands/'.$brand_id.'.json';
my $user = 'test';
my $pass = '4afe2a8a38fbd29c32e8fcd26dc51f6d9b5ab99b';

# 
# Define user agent
my $user_agent = LWP::UserAgent->new();

# GET
# make request to gather information
my $request = HTTP::Request->new('GET', $uri);
$request->authorization_basic($user, $pass);

# execute request
my $response = $user_agent->request($request);

# check request
if($response->is_success())
{
	# get contents
	my $json_content = $response->content();

	# decode JSON
	my $decoded_json = decode_json($json_content);

	# create hash for updating values
	my %update = ();

	# loop the referenced hash.
	print "\n - - - (enter 'y' to update) - - -\n";
	while( my($key,$value) = each(%$decoded_json))
	{
		if($key ne "id")
		{
			print "\nWould you like to update the ".$key."? ";
			my $answer = <STDIN>;
			chomp($answer);
			if ($answer eq "y")
			{
				print "Please enter new value: ";
				$value = <STDIN>;
				chomp($value);
			}
			# populate hash
			$update{$key}=$value;
		}
	}

	# convert %update hash to JSON string
	my $json_update = encode_json(\%update);
	#print $json_update;

	# PUT
	# make request to update the brand
	$request = HTTP::Request->new('PUT', $uri);
	$request->authorization_basic($user, $pass);
	$request->header("content-type" => "application/json");
	$request->content($json_update);

	# execute request
	$user_agent->request($request);

	print "\n\n Brand ID ".$brand_id.", is now updated\n\n";

}
else
{
	print "\n\n Brand ID ".$brand_id.", could not be updated\n\n";
}


exit;