<?php
namespace YesWikiRepo;

$loader = require __DIR__ . '/vendor/autoload.php';

set_exception_handler(function($e) {
	header('HTTP/1.1 500 Internal Server Error');
	echo htmlSpecialChars($e->getMessage());
	die();
});

openlog('[YesWikiRepo] ', LOG_CONS|LOG_PERROR, LOG_SYSLOG);

// Load command line parameters to $_GET
if (isset($argv)) {
    parse_str(implode('&', array_slice($argv, 1)), $_GET);
}

$configFile = new JsonFile('local.config.json');
$configFile->read();
$repo = new Repository($configFile);

(new ScriptController($repo))->run($_GET);
