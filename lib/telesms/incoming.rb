module Telesms
  # This class represents an incoming message.
  class Incoming
    extend Base

    # @return [Mail::Message]
    # The mail message created from the params.
    attr_reader :mail

    # This method receives a mail param and parses it.
    #
    # @param [Hash] params
    #   The params from the mail received.
    #
    # @return [Hash]
    def self.receive(params)
      self.new(params).parse
    end

    # This method creates a new incoming message and parses it.
    #
    # @param [Hash] params
    #   The params from the mail received.
    #
    # @return [Incoming]
    def initialize(params)
      @mail = Mail.new(params)
      parse
    end

    # This method parses the received mail param.
    #
    # @return [Hash]
    #   * +from+:     The number who is sending the message.
    #   * +to+:       Who the message is for.
    #   * +body+:     The clean body.
    #   * +provider+: Name of the provider.
    def parse
      clean_body!

      {
        from:     from,
        to:       to,
        body:     body,
        provider: provider
      }
    end

    # This method gets the receiver of the message.
    #
    # @return [String]
    def to
      @mail.to.first
    end

    # This method gets the number that is sending the message.
    #
    # @return [String]
    def from
      @mail.from.first.to_s.match(/(.*)\@/)[1] rescue nil
    end

    # This method gets the body of the message.
    #
    # @return [String]
    def body
      @mail.body.to_s[0,160]
    end

    # This method gets the gateway host from the FROM field.
    #
    # @return [String]
    def gateway_host
      @mail.from.first.to_s.match(/\@(.*)/)[1] rescue nil
    end

    # This method gets the provider name from the FROM field.
    #
    # @return [String]
    def provider
      Base.gateways.select do |name,gateways|
        [gateways[:sms], gateways[:mms]].include? gateway_host
      end.keys.first
    end

    # This method cleans the body that was received.
    #
    # @return [Boolean]
    def clean_body!
      body        = @mail.parts.last.body.decoded if @mail.multipart?
      body        ||= @mail.body.to_s
      body        = body[0, body.index(original_message_regex) || body.length].to_s
      body        = body.split(/\n\s*\n/m, 2)[1] || body if body.match(/\n/)
      @mail.body  = body.to_s.gsub(/\n/, '').strip
      return true
    end

    # This method is the original message regex.
    #
    # @return [Regexp]
    def original_message_regex
      /(-----Original Message-----)/
    end
  end
end