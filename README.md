# Vim profiles

vim-profiles is a [pathogen](https://github.com/tpope/vim-pathogen)-inspired-and-based
[Vim](http://www.vim.org) plugin, that has it's goal to reduce your Vim startup
time. It gives you an ability to organize your plugins (or so called bundles)
into several sets (profiles) to be loaded on demand.

## Installation

The easiest way to install vim-profies is to copy `autoload/profiles.vim` file
to the `autoload` directory under your vim runtime path (usually it will be
`~/.vim/autoload`).

Then you just have to add the following into your `vimrc`:

    exec profiles#init()

Also you need to install pathogen. Unfortunately, vim-profiles requires to use
a forked version from the `develop` branch of this github repo:
[mirlord/vim-pathogen](https://github.com/mirlord/vim-pathogen).

But to be honest, you'll get nothing amazing until you organize and configure
your profiles. On how to do it - see "Usage" section below.

## Usage

1. Create some directories under your `~/.vim/profiles/` (if your vim runtime
   files are located in another directory - you definitely should know how to
   correctly interpret the defaults I use here). Example:

        $ ls ~/.vim/profiles
        base
        development
        lib

2. Move your bundles to the appropriate profile directories (see FAQ section if
   you have trouble with relocating bundles as git submodules). Let's imagine the
   following result:

        $ ls ~/.vim/profiles/lib
        genutils
        $ ls ~/.vim/profiles/base
        localvimrc
        airline
        $ ls ~/.vim/profiles/development
        ctrlp
        syntastic
        ultisnips

3. For 80% of our vim usage we need only a good colorscheme and a nice
   statusbar. So we decide to always load `lib` and `base` profiles on startup.
   To acieve this we should define the confguration variable:

        let g:profiles_default = ['lib', 'base']

   or you can do the same by setting the environment variable `$VIM_PROFILES`. It
   should contain just profiles names separated by space, i.e.:

        alias vim='env VIM_PROFILES="lib base" vim'

   Note, that it's a very good idea to include
   [localvimrc](https://github.com/embear/vim-localvimrc/) to one of your default
   profiles. It will help you to use vim-profiles most effectively.

4. Sure, vim now starts 100500 times faster without those development plugins.
   But what if we need them? Just type the following command:

        :LoadProfiles development

   or as a shortcut:

        :LP development

   and go working hard to start a Rise of Machines.

5. Place `.lvimrc` file with this command into your `~/projects/` directory and
   may the Force be with you. That's localvimrc to always load I told you why.

## FAQ

> Is it something similar around?

The very close idea is implemented by [ipi](https://github.com/jceb/vim-ipi/).
But it does not exactly the same things vim-profiles does. And I actually never
tried to use it. I just know it and if it will be more useful for you - pony
will die. But how cares about pony.

> Why the plugin xXx fails to be loaded with vim-profiles?

Most probably this plugin uses some autocommands, that are binded to the
VimEnter event. If you load a plugin's profile at runtime, this event will
never be fired so the plugin won't work. vim-profiles knows about some of those
plugins an have a built-in support of them (such as airline, fugitive and some
other), but it can't know all of them. Please notify me about such plugins and
I will teach vim-profiles to load them properly. It's also configurable from
user-space, but not documented. If you are familiar with vimscript -
pull-requests are always appreciated.

> How to relocate a bundle if it's a git submodule?

Yes, a tricky way of manual removing and re-adding bundles and git submodules
is a pain. For that reason there are some shell-scripts distributed with this
plugin, that will try to do their best to save your time and nerves.  Their
names and usage info should be self-explanatory, I hope. Scripts are under
`bin/` directory.

> Any roadmap?

Maybe. I just don't want to violate my promises.

## License

[The MIT License](http://www.opensource.org/licenses/mit-license.php)

Copyright (c) 2013 Vladimir Chizhov <master@mirlord.com>

