# TeleSMS

TeleSMS is a library for sending and receiving SMS messages with emails.
It uses carrier-provided email-to-sms gateways to send and receive messages.
To see a list of gateways, visit https://web.archive.org/web/20130906122931/http://en.wikipedia.org/wiki/List_of_SMS_gateways.

The purpose of this library is to encapsulate the code for sending and receiving 
email-to-sms messages since there are many edge cases. The goal is to maintain
the configuration and parsers to reduce the number of failed messages.

http://www.telefio.com

## Installation

Add this line to your application's Gemfile:

    gem 'telesms'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install telesms

## Usage

To send a message:

    # Order: FROM, TO, PROVIDER, BODY
    Telesms::Outgoing.deliver('john@example.com', '555555555', 'Verizon', 'Message body')

To receive and parse a message:

    Telesms::Incoming.receive(params[:mail])
    # => { from: '555555555', to: 'john@example.com', body: 'Message body', provider: 'Verizon' }

To get a list of available gateways:

    Telesms::Base.gateways
    # => { 'AT&T' => { sms: 'att.com', mms: 'mmode.com'}, ... }

## Configuration

Configure the mail gem to use the correct delivery method:

    Mail.defaults do
      delivery_method :sendmail # or :smtp, options
    end

## Contributing

To fetch & test the library for development, do:

    $ git clone https://github.com/kalinchuk/telesms.git
    $ cd telesms
    $ bundle
    $ rake spec

If you want to contribute, please:

  * Fork the project.
  * Write tests for the feature or bug fix.
  * Add your feature or bug fix.
  * Please update CHANGELOG.md
  * Send me a pull request on Github.

## LICENSE:

TeleSMS is Copyright © 2014 Telefio. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.