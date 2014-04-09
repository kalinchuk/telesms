module Telesms
  # This class represents an outgoing message.
  class Outgoing
    extend Base

    # @return [String]
    # The FROM address.
    attr_accessor :from

    # @return [String]
    # The TO address (will be concatinated with a provider).
    attr_accessor :to

    # @return [String]
    # The provider for the number.
    attr_accessor :provider

    # @return [String]
    # The message body being sent.
    attr_accessor :message

    # This method creates a new outgoing message and sends it.
    #
    # @param [String] from
    #   The FROM address.
    #
    # @param [String] to
    #   The TO address.
    #
    # @param [String] provider
    #   The provider name.
    #
    # @param [String] message
    #   The message being sent.
    #
    # @return [Mail]
    def self.deliver(from, to, provider, message)
      self.new(from, to, provider, message).deliver
    end

    # This method creates a new outgoing message.
    #
    # @param [String] from
    #   The FROM address.
    #
    # @param [String] to
    #   The TO address.
    #
    # @param [String] provider
    #   The provider name.
    #
    # @param [String] message
    #   The message being sent.
    #
    # @return [Outgoing]
    def initialize(from, to, provider, message)
      @from     = from
      @to       = to
      @provider = provider
      @message  = message
    end

    # This method sends an email message disguised as an SMS message.
    #
    # @return [Mail]
    def deliver
      Mail.new(from: from, to: formatted_to, body: sanitized_message).deliver!
    end

    # This method formats the TO address to include the provider.
    #
    # @return [String]
    def formatted_to
      "#{to}@#{Base.gateways[@provider][:sms_gateway]}"
    end

    # This method sanitizes the message body.
    #
    # @return [String]
    def sanitized_message
      message.to_s[0,140]
    end
  end
end