# Strapping Young Lad (or just Lad for short)

[![endorse](http://api.coderwall.com/kouphax/endorsecount.png)](http://coderwall.com/kouphax)

__Strapping Young Lad__ is a tokenised solution template substitution engine.  A bit of a mouthful I know but it actually much simpler than it sounds (and hopefully much more useful that you'd think).  So what does it do?  Well running

    lad /path/to/git/repo MyNewProject

Will do the following things,

1. Clone the repo at `path/to/git/repo` into a temporary folder
2. Remove the `.git` folder from the repo
3. Check for the existence of a `.ladconfig` in the freshly cloned repo
  - If one exists it loads the config setting
  - Otherwise it falls back to the defaults
4. Replace all instances of the configured token (eg. `__NAME__`) in all files, directories and file contents with the project name (in our case `MyNewProject`)
5. Copy the new folder over to your current working directory (`./MyNewProject`)

What this allows you to do is have a standard project template for pretty much anything (.NET, Ruby, Scala - listen I mean anything - if it a collection of folders and files in a git repo then you set) and create a new instance with a few keystrokes - saving you time and potential RSI.

SYL was inspired by [WarmuP](https://github.com/chucknorris/warmup) which is itself a gem but it requires you to be running .NET which for a lot of my requirement isn't going to cut it.

## Installation

Add this line to your application's Gemfile:

    gem 'lad'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lad

## Usage

The example above shows you how to use the gem,

    lad <PathToRepo> <ProjectName>

- `PathToRepo` is the git repository url that will be cloned
- `ProjectName` is the name of the project.  This will replace the `__NAME__` token in the repository directories, files and contents.  It is possible to declare other tokens as well via the `.ladconfig` file

## Configuring the engine via `.ladconfig`

SYL, once the repository has been cloned will check for the existence of file with the name `.ladconfig` from which it will load the settings.  If it doesn't exist the default setting will be applied.

### Configuration Options

- `token` - this is the token/indetifier that will be replaced in the template with the name of the project (defaults to `__NAME__`).  This option will also accept and array of tokens ['__NAME__', '__NAMESPACE__'].  In this case the user will be prompted for the values of these tokens.
- `ignore` - a list of extensions that SYL will ignore when it comes to replacing CONTENTS.  It will still RENAME the file if the file name includes the token.  This allows us to ignore binary files whose contents should not change.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changes

    20 Apr 2012 - Version 0.1.2 released.  .ladconfig now accepts multiple tokens to be specified.
    17 Apr 2012 - Version 0.0.2 released.  Addition of simple help text on the command line.
    17 Apr 2012 - Version 0.0.1 released.

## Roadmap

- zip support (generate project from zip file)
- other things as yet undetermined
