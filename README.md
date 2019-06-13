# backup-with-borg

Backup tool to create easily archives with borgbackup.

## Usage

```
backup do-create
```

Create a new archive with your current configuration.

```
backup do-prune
```

Prune your archives according to `KEEP_*` variables in the configuration file.

```
backup (do)
backup
```

Create a new archive and then prune the repository archives. (Wraps `do-create` and `do-prune`. This can also be accomplished by simply invoking `backup`, 
which if you have installed `backup-with-borg` to the default location will be `/usr/local/bin/backup`.)

### Wrapper

You also can use native `borg` commands like `list` or mount. These will respect the exported `BORG_*` variables. So a plain `backup list` will list all of your current archives in the configured repository. If you want to execute `borg list` (or any other borg commands) on a specific borg archive, make sure you prepend two colons to the repository name. As an example:

    # List borg archives, in this case there is one entry listed
    $ backup list
    testvm-full-2019-05-21T06:30:00 Tue, 2019-05-21 06:30:00 [HASH]
    testvm-full-2019-05-21T07:30:00 Tue, 2019-05-21 07:30:00 [HASH]

    # Pull info from this specific borg archive:
    $ backup info ::testvm-full-2019-05-21T07:30:00

    # Run a diff against two borg archives:
    $ backup diff ::testvm-full-2019-05-21T06:30:00 testvm-full-2019-05-21T07:30:00


### Different configurations

If you want to use different configurations on the same machine, you can set the `BACKUP_CONF`
environment variable. For example, you may have `/etc/backup/default.env` as well as `/etc/backup/secondrepo.env` configuration files present. 
To invoke the second configuration, which will execute the create and prune operations, simply enter:
`BACKUP_CONF=secondrepo /usr/local/bin/backup`

## Installation

You need to have [borgbackup](https://github.com/borgbackup/borg/) prior to your first run. See [borg's installations instructions](https://borgbackup.readthedocs.io/en/stable/installation.html) for details.

    # install scripts
    git clone https://github.com/bebehei/backup-with-borg
    cd backup-with-borg
    make install
    cp /etc/backup/{example,default}.env
    cp /etc/backup/{example,default}.exclude

    # edit default.env to match backup data
    $EDITOR /etc/backup/default.env

    # edit default.exclude to modify any patterns that should be excluded.
    # NOTE: Any directories that contain an empty file called `.nobackup` will automatically be excluded from the backup.
    $EDITOR /etc/backup/default.exclude

    # initialize the repository. Note that with borg 1.1 you must specify the encryption type at initialization.
    backup init -e <preferred_encryption_technique>
    # e.g.: 
    backup init -e repokey-blake2

    # add cronjob (for hourly backup, which will execute (wrap) both do-create and do-prune)
    { crontab -l ; echo "0 * * * * /usr/local/bin/backup"; } | crontab -
    # NOTE: If you are using a crontab entry, for security purposes, you should specify the full path to the script. The example given here
    # assumes you have installed backup-with-borg to the default location, e.g.: /usr/local/bin/backup.

**Hint: Depending on your configuration, you may need sudo for some commands.**
