# backup-with-borg

Backup tool to easily create archives with borgbackup.

## Usage

Create a new archive with the default configuration (i.e., default.env
and default.exclude):

```
backup do-create
```

Prune your archives according to `KEEP_*` variables in the configuration file:

```
backup do-prune
```

Compact your archives to free up space.  This functionality was separated from borg's `prune` functionality in borg 1.2.

```
backup do-compact
```

Create a new archive, prune the repository archives, then compact the repository archives. (Wraps `do-create`, `do-prune`, and `do-compact`. 
This can also be accomplished by simply invoking `backup`, which if you 
have installed `backup-with-borg` to the default location will be 
`/usr/local/bin/backup`.)

```
backup
```

### Wrapper

You also can use native `borg` commands like `list` or `mount`. These 
will respect the exported `BORG_*` variables. So a plain `backup list` 
will list all of your current archives in the configured repository. 
If you want to execute `borg list` (or any other borg commands) on a 
specific borg archive, make sure you prepend two colons to the 
repository name. As an example:

    # List borg archives, in this case there are two entries listed
    $ backup list
    testvm-full-2019-05-21T06:30:00 Tue, 2019-05-21 06:30:00 [HASH]
    testvm-full-2019-05-21T07:30:00 Tue, 2019-05-21 07:30:00 [HASH]

    # Pull info from this specific borg archive:
    $ backup info ::testvm-full-2019-05-21T07:30:00

    # Run a diff against two borg archives:
    $ backup diff ::testvm-full-2019-05-21T06:30:00 testvm-full-2019-05-21T07:30:00


### Different configurations

If you want to use different configurations on the same machine, you
can set the `BACKUP_CONF` environment variable. For example, you may 
have `/etc/backup/default.env` as well as `/etc/backup/secondrepo.env` 
configuration files present. To invoke the second configuration, which 
will execute the create and prune operations, simply enter:
`BACKUP_CONF=secondrepo /usr/local/bin/backup`

## Installation

You need to install [borgbackup](https://github.com/borgbackup/borg/) prior to 
your first run. See [borg's installations instructions](https://borgbackup.readthedocs.io/en/stable/installation.html) 
for details.

Note that for a single-user installation you can place your config files under
the ~/.config/backup directory.

### Install scripts

    git clone https://github.com/jhuscott/backup-with-borg
    cd backup-with-borg
    make install
    cp /etc/backup/{example,default}.env
    cp /etc/backup/{example,default}.exclude

### Edit default environment and exclusion config files

    # edit default.env to match backup data
    $EDITOR /etc/backup/default.env

    # edit default.exclude to modify any patterns that should be excluded.
    # NOTE: Any directories that contain an empty file called 
    # `.nobackup` will automatically be excluded from the backup.
    $EDITOR /etc/backup/default.exclude

### Initialize the repository

    # Note that with borg ≥1.1 you must specify the encryption type at initialization.
    backup init -e <preferred_encryption_technique>
    # Suggest repokey-blake2 (key stored in repo) or 
    # keyfile-blake2 (separate keyfile, which is more secure)
    # e.g.: 
    backup init -e keyfile-blake2

**WARNING: Make sure you export the borg key and store the result in a safe place!**

    backup key export --paper > ~/encrypted-key-backup.txt
    backup key export --qr-html > ~/encrypted-key-backup.html

### Add cron job
    
    # This example shows an hourly backup, which will execute 
    # (wrap) do-create, do-prune, and do-compact.
    { /usr/bin/crontab -l ; echo "0 * * * * /usr/local/bin/backup"; } | /usr/bin/crontab -
    # NOTE: If you are using a crontab entry, for security purposes, you should specify the full path to the script. The example given here
    # assumes you have installed backup-with-borg to the default location, e.g.: /usr/local/bin/backup.

**Hint: Depending on your configuration, you may need sudo for some commands.**
