<?php
$CONFIG = array (
  'trusted_domains' =>
  array (
    0 => '127.0.0.1',
  ),
  'datadirectory' => '/var/www/owncloud/data',
  'overwrite.cli.url' => 'https://127.0.0.1',
  'dbtype' => 'mysql',
  'version' => '11.0.2.7',
  'memcache.local' => '\OC\Memcache\Redis',
  'redis' => [
     'host' => '/var/run/redis/redis.sock',
     'port' => 0,
     'timeout' => 0,
     'dbindex' => 1,
  ],
  'memcache.locking' => '\OC\Memcache\Redis',
  'logtimezone' => 'UTC',
  'installed' => false,
);

