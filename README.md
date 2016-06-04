# Get Latest Chromium Nightly

:repeat: A simple ruby script for fetching the latest Chromium Nightly and copying it into ~/Applications, as I was tired of the [Homebrew Cask version](https://github.com/caskroom/homebrew-cask) being two major releases behind.

## Installation

I'm using ruby@2.3.0. The only thing you have to do is a `gem install rubyzip'.

Clone the repo with 'git clone git@github.com:kramsee/get-latest-chromium-nightly.git' and add following alias into your `~/.bash_profile`:

    alias get_latest_chromium_nightly="ruby ~/path/to/get-latest-chromium-nightly/main.rb"

That's it. ✌️

