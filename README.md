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

Create a new archive and then prune the repository archives. (Wraps `do-create` and `do-prune`)

### Wrapper

You also can use native `borg` commands like `list` or mount. These will respect the exported `BORG_*` variables. So a plain `backup list` will list all of your current archives in the configured repository.

## Installation

You need to have [borgbackup](https://github.com/borgbackup/borg/) prior to your first run. See [borg's installations instructions](https://borgbackup.readthedocs.io/en/stable/installation.html) for details.

    # install scripts
    git clone https://github.com/bebehei/backup-with-borg
    cd backup-with-borg
    make install
    cp /etc/backup/{example,default}.env

    # edit default.env to match backup data
    $EDITOR /etc/backup/default.env

    # initialize everything
    backup init -e <preferred_encryption_technique>

    # add cronjob (for hourly backup)
    { crontab -l ; echo "0 * * * * backup"; } | crontab -

**Hint: Depending on your configuration, you may need sudo for some commands.**
