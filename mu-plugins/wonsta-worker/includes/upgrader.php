<?php

$upgrader = new \Plugin_Upgrader( new Quiet_Skin() );

class Quiet_Skin extends \WP_Upgrader_Skin {
    public function feedback( $string, ...$args ) {
        // This is quiet skin.
        return $string;
    }
}