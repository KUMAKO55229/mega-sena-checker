<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit234f0931e9e4b45870f7552553837d02
{
    public static $classMap = array (
        'Composer\\InstalledVersions' => __DIR__ . '/..' . '/composer/InstalledVersions.php',
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->classMap = ComposerStaticInit234f0931e9e4b45870f7552553837d02::$classMap;

        }, null, ClassLoader::class);
    }
}
