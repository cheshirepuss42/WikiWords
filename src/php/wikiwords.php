<?php
function isValidSet($names)
{
	for ($i = 0; $i < count($names); $i++)	
	{
		if (strlen($names[$i]["title"]) > 60)
			return false;		
	}
	return true;
}

$seedID = 0;
$seed = $_GET["seed"];
$numRandom = $_GET["random"];
$numRelated = $_GET["related"];
$language = $_GET["language"];
$numberOfExternalCalls = 0;
//$language = "en";
$base = "http://".$language.".wikipedia.org/w/api.php?action=query&format=php&";

//get random links
$randomQuery = "list=random&rnlimit=".$numRandom."&rnnamespace=0";
ini_set( 'user_agent', 'WikiWords Bot' );


do
{
	$randoms = unserialize(file_get_contents($base.$randomQuery));
	$numberOfExternalCalls++;
	$randomLinks = $randoms["query"]["random"];
}
while(!isValidSet($randomLinks));

//get seed and related links
do
{
	//get seed
	$randomSeed = unserialize(file_get_contents($base."list=random&rnlimit=1&rnnamespace=0"));
	$seed = $randomSeed["query"]["random"][0]["title"];
	$seedID = $randomSeed["query"]["random"][0]["id"];		
	$seedQuery = "prop=links&pllimit=499&plnamespace=0&titles=".urlencode($seed);
	
	//get related links
	$related = unserialize(file_get_contents($base.$seedQuery));
	$relatedLinks = $related["query"]["pages"][$seedID]["links"];
	shuffle($relatedLinks);
	$relatedLinks = array_slice($relatedLinks, 0, $numRelated);	
	//print_r($relatedLinks);
	$numberOfExternalCalls += 2;

}
while(count($relatedLinks)<$numRelated || !isValidSet($relatedLinks));

// make xml
$xml = "<wikiwords>";
$xml.= "<seed>".$seed."</seed>";
for($i = 0; $i < $numRandom; $i++)
{
	$xml.= "<random>".$randomLinks[$i]["title"]."</random>";
}
for($i = 0; $i < $numRelated; $i++)
{
	$xml.= "<related>".$relatedLinks[$i]["title"]."</related>";
}
//$xml.= "<wikicalls>".$numberOfExternalCalls."</wikicalls>";
//$xml.= "<info>".count($relatedLinks)."_".isValidSet($relatedLinks)."_".$numRelated."</info>";
$xml.= "</wikiwords>";

// set headers and output xml
header("Expires: Mon, 26 Jul 1990 05:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header ("content-type: text/xml");

echo $xml;
?>