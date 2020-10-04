#!/usr/bin/env php
<?php
// application.php

require __DIR__.'/vendor/autoload.php';

use Symfony\Component\Console\SingleCommandApplication;

$application = new SingleCommandApplication();
$application->setName('Yes… Wiki!')->setVersion('1.0.0');

$application->run();
