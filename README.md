# Butane-Slack-Hubot

This is a Butane repo for setting up [Hubot](https://hubot.github.com/) for Slack on a Fedora CoreOS VM.

## Create Classic Slack App
Stolen from this issue: https://github.com/slackapi/hubot-slack/issues/584#issuecomment-611808704

> ### Setup a Classic App
>
>     * Create a classic app from https://api.slack.com/apps?new_classic_app=1
>
>     * Go to **Features** > **OAuth & Permissions** > **Scopes**
>
>       * Click "Add an OAuth Scope"
>       * Search "bot" and choose it
>
>     * Go to **Features** > **App Home**
>
>       * Click "Add Legacy Bot User"
>       * Input "Display Name" and "Default username"
>       * Click "Add"
>
>     * Go to **Settings** > **Install App**
>
>       * Click "Install App to Workspace"
>       * Complete the OAuth flow

## Customize butanevars.yaml

You will need to customize the `butanevars.yaml` file with at least the following things:

1. At least add your SSH key to the `core` user. Add a ssh user for yourself if you want.
1. Set system hostname and domainname.
1. Set updates timezone and what days, start time, and length you want for updates.
1. Enable [Blazon](https://github.com/quickvm/blazon) for systemd alerting. You will need a Slack webhook URL for this to work.
1. Enable restic backups for /opt/hubot/redis if running Redis locally.
1. Configure Hubot. You will need to use the Slack bot token from the Classic App you just setup. If you want YouTube support you will need to setup a [Google Developer Console](https://www.npmjs.com/package/hubot-youtube) token You also can set up Hubot to use an external redis instance if you want.
1. If you want to customize the Hubot container, see the `container/` directory.

## Launch Server

### DigitalOcean
https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-digitalocean/

```
# Upload custom image
doctl compute image create my-fcos-image --region nyc3 --image-url https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/36.20220806.3.0/x86_64/fedora-coreos-36.20220806.3.0-digitalocean.x86_64.qcow2.gz

# Wait for image creation to finish
while ! doctl compute image list-user | grep my-fcos-image; do sleep 5; done

# Add your SSH key
doctl compute ssh-key create my-key --public-key "$(cat ~/.ssh/id_rsa.pub)"

# Launch the server
DO_IMAGE_ID=$(doctl compute image list-user | grep my-fcos-image | cut -f1 -d ' ')
DO_KEY_ID=$(doctl compute ssh-key list | grep my-key | cut -f1 -d ' ')
doctl compute droplet create my-fcos-droplet --image "${DO_IMAGE_ID}" --region nyc3 --size s-1vcpu-1gb --user-data-file <(bupy template slack-hubot.bu.j2 butanevars.yaml) --ssh-keys "${DO_KEY_ID}" --wait
```

