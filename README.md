# backup-with-borg

Backup tool to create easily encrypted archives with borgbackup.

## Usage

I'm too tired now. Maybe tomorrow.

At least I can say, it's dead easy.

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
    backup init --encryption=repokey

    # add cronjob (for hourly backup)
    { crontab -l ; echo "0 * * * * backup"; } | crontab -

**Hint: Depending on your configuration, you may need sudo for some commands.**
