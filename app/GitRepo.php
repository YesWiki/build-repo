<?php
namespace YesWikiRepo;

class GitRepo extends Files
{
    private $link;
    private $branch;

    public $path = "";

    public function __construct($link, $branch)
    {
        $this->link = $link;
        $this->branch = $branch;
    }

    /**
     * get files frome repo
     * @return [type] [description]
     */
    public function clone($path = "")
    {
        $this->path = $path;
        if ($path === ""){
            $this->path = $this->tmpdir();
        }
        $this->git("clone " . $this->link . ' ' . $this->path);

        $this->checkout();

        return $this->path;
    }

    /**
     * Change project branch
     * @return [type] [description]
     */
    private function checkout()
    {
        $this->git('-C ' . $this->path . ' checkout ' . $this->branch);
    }

    /**
     * Delete all files
     * @return [type] [description]
     */
    public function purge()
    {
        $this->delete($this->path);
    }

    private function git($command)
    {
        //escapeshellarg(
        $command = 'git ' . $command;
        exec($command, $output, $returnValue);
        echo $command."\r\n".$output[0];
        if ($returnValue !== 0) {
            throw new \RuntimeException(implode("\r\n", $output));
        }
        return $output;
    }

}
