# Installation

1. Clone the project

```bash
git clone git@github.com:davidjairala/clippo.git
cd clippo

rbenv install
bundle
```

1. Install requirements

```bash
brew install pngpaste
```

2. Edit config file

```bash
cp config/config.example.yml config/config.yml
vim config/config.yml
```

Enter your s3 details into the YML file.

# Usage

Copy some text or a screenshot into your clipboard that you want to share
and then run clippo:

```bash
clippo

Uploaded to (and copied to clipboard):
https://davidjairala-notes.s3-us-west-1.amazonaws.com/2016-03-25/1458940549__196287852.png
```

The file is uploaded to s3 and set with ACL of `public-read`.  The public
url is then copied to the clipboard as well so you can share it easily.

All uploaded files are placed within the bucket you specify in the
`config/config.yml` file and within folders for the date you uploaded
the file in the format `YYYY-MM-DD`.


Included you'll also find `clippo.sh` that you can move to wherever you
keep executable shortcuts in your path (`~/bin` for example), so you can
invoke clippo from everywhere!

**To run with a global shortcut:**

Copy the included `clippo.workflow` folder to `~/Library/Services`:

```bash
cp -Rf clippo.workflow ~/Library/Services/
```

Then go into `System Preferences -> Keyboard -> Shortcuts -> Services`, find clippo and assign the desired keyboard shortcut combo.

# Help

Hit me up here.
